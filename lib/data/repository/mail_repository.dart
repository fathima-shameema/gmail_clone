import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gmail_clone/data/models/mail.dart';
import 'package:gmail_clone/data/services/ai_classifier.dart';

class MailRepository {
  final _fire = FirebaseFirestore.instance;
  final usersColl = FirebaseFirestore.instance.collection('users');

  Future<String?> _uidForEmail(String email) async {
    try {
      final snap =
          await usersColl.where('email', isEqualTo: email).limit(1).get();
      if (snap.docs.isEmpty) return null;
      return snap.docs.first.id;
    } catch (e) {
      log('[repo] uid lookup error: $e');
      return null;
    }
  }

  Future<void> sendMail(MailModel mail, String senderUid) async {
    try {
      final Map<String, dynamic> userStatus = {};
      final List<String> userIds = [];

      userStatus[senderUid] = {
        "starred": false,
        "important": false,
        "deleted": false,
        "isSender": true,
      };
      userIds.add(senderUid);

      final toReceiverUid = await _uidForEmail(mail.to);

      if (toReceiverUid != null) {
        userStatus[toReceiverUid] = {
          "starred": false,
          "important": false,
          "deleted": false,
        };
        userIds.add(toReceiverUid);
      } else {
        userStatus[mail.to] = {
          "starred": false,
          "important": false,
          "deleted": false,
        };
        userIds.add(mail.to);
      }

      if (mail.cc != null && mail.cc!.trim().isNotEmpty) {
        final ccList =
            mail.cc!
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();

        for (final cc in ccList) {
          final ccUid = await _uidForEmail(cc);

          if (ccUid != null) {
            userStatus[ccUid] = {
              "starred": false,
              "important": false,
              "deleted": false,
            };
            userIds.add(ccUid);
          } else {
            userStatus[cc] = {
              "starred": false,
              "important": false,
              "deleted": false,
            };
            userIds.add(cc);
          }
        }
      }

      // generate a category using the deployed Cloud Function
      String category = ManualClassifier.classify(
        subject: mail.subject,
        body: mail.body,
        from: mail.from,
      );

      await _fire.collection("mails").doc(mail.id).set({
        ...mail.toMap(),
        "category": category,
        "userStatus": userStatus,
        "userIds": userIds,
        "senderUid": senderUid,
      });
    } catch (e, st) {
      log("sendMail error: $e\n$st");
      rethrow;
    }
  }

  Stream<List<MailModel>> getInbox(String email, String uid) {
    return _fire
        .collection("mails")
        .where("userIds", arrayContainsAny: [uid, email])
        .snapshots()
        .map((snap) {
          return snap.docs
              .map((d) => MailModel.fromMap(d.data()))
              .where(
                (m) =>
                    !(m.userStatus[uid]?['deleted'] == true ||
                        m.userStatus[email]?['deleted'] == true) &&
                    m.from != email,
              )
              .toList();
        });
  }

  Stream<List<MailModel>> getSent(String email, String uid) {
    return _fire
        .collection("mails")
        .where("from", isEqualTo: email)
        .snapshots()
        .map((snap) {
          return snap.docs
              .map((d) => MailModel.fromMap(d.data()))
              .where((m) => !m.isDeleted(uid) || m.userStatus[uid] == null)
              .toList();
        });
  }

  Stream<List<MailModel>> getAllInboxes(List<String> emails, String uid) {
    if (emails.isEmpty) return Stream.value([]);
    final limited = emails.length <= 10 ? emails : emails.take(10).toList();
    return _fire
        .collection("mails")
        .where("userIds", arrayContainsAny: limited)
        .snapshots()
        .map((snap) {
          return snap.docs
              .map((d) => MailModel.fromMap(d.data()))
              .where(
                (m) =>
                    !m.isDeletedFor(
                      uid,
                      /* choose a fallback email if available */ '',
                    ),
              )
              .toList();
        });
  }

  Stream<List<MailModel>> getAllSent(List<String> emails, String uid) {
    if (emails.isEmpty) return Stream.value([]);
    final limited = emails.length <= 10 ? emails : emails.take(10).toList();
    return _fire
        .collection("mails")
        .where("from", whereIn: limited)
        .snapshots()
        .map((snap) {
          return snap.docs
              .map((d) => MailModel.fromMap(d.data()))
              .where((m) => !m.isDeleted(uid) || m.userStatus[uid] == null)
              .toList();
        });
  }

  Future<void> toggleStar(String mailId, String uid, bool value) async {
    await _fire.collection("mails").doc(mailId).update({
      "userStatus.$uid.starred": value,
    });
  }

  Future<void> toggleImportant(String mailId, String uid, bool value) async {
    await _fire.collection("mails").doc(mailId).update({
      "userStatus.$uid.important": value,
    });
  }

  Future<void> deleteMail(String mailId, String uid) async {
    await _fire.collection("mails").doc(mailId).update({
      "userStatus.$uid.deleted": true,
    });
  }

  Stream<List<MailModel>> getBin(String uid) {
    return _fire.collection("mails").snapshots().map((snap) {
      return snap.docs
          .map((d) => MailModel.fromMap(d.data()))
          .where((m) => m.isDeleted(uid))
          .toList();
    });
  }

  Stream<List<MailModel>> getImportant(String uid) {
    return _fire.collection("mails").snapshots().map((snap) {
      return snap.docs
          .map((d) => MailModel.fromMap(d.data()))
          .where((m) => m.isImportant(uid))
          .toList();
    });
  }

  Future<void> emptyBin(String uid) async {
    // Delete documents where userStatus[uid].deleted == true and either:
    // - only uid present in userIds -> delete doc, or
    // - more users present -> remove the uid from userStatus and userIds
    final snap = await _fire.collection("mails").get();
    for (var doc in snap.docs) {
      final data = doc.data();
      final MailModel m = MailModel.fromMap(data);
      if (m.isDeleted(uid)) {
        final docRef = doc.reference;
        final otherUserIds = List<String>.from(
          m.userIds.where((u) => u != uid),
        );
        if (otherUserIds.isEmpty) {
          await docRef.delete();
        } else {
          // remove uid fields from doc
          final updates = {
            "userStatus.$uid": FieldValue.delete(),
            "userIds": otherUserIds,
          };
          await docRef.update(updates);
        }
      }
    }
  }

  Future<void> autoCleanBin(String uid) async {
    final threshold = DateTime.now().subtract(const Duration(days: 30));
    final snap = await _fire.collection("mails").get();
    for (var doc in snap.docs) {
      final m = MailModel.fromMap(doc.data());
      if (m.isDeleted(uid)) {
        if (m.timestamp.isBefore(threshold)) {
          // if only this user remains, delete doc; otherwise remove user entry
          final otherUserIds = List<String>.from(
            m.userIds.where((u) => u != uid),
          );
          if (otherUserIds.isEmpty) {
            await doc.reference.delete();
          } else {
            await doc.reference.update({
              "userStatus.$uid": FieldValue.delete(),
              "userIds": otherUserIds,
            });
          }
        }
      }
    }
  }

  Stream<List<MailModel>> getPromotions() {
    return _fire
        .collection("mails")
        .where("category", isEqualTo: "promotion")
        .snapshots()
        .map((s) => s.docs.map((d) => MailModel.fromMap(d.data())).toList());
  }

  Stream<List<MailModel>> getSocial() {
    return _fire
        .collection("mails")
        .where("category", isEqualTo: "social")
        .snapshots()
        .map((s) => s.docs.map((d) => MailModel.fromMap(d.data())).toList());
  }

  Stream<List<MailModel>> getSpam() {
    return _fire
        .collection("mails")
        .where("category", isEqualTo: "spam")
        .snapshots()
        .map((s) => s.docs.map((d) => MailModel.fromMap(d.data())).toList());
  }

  Stream<List<MailModel>> getPrimary() {
    return _fire
        .collection("mails")
        .where("category", isEqualTo: "none")
        .snapshots()
        .map((s) => s.docs.map((d) => MailModel.fromMap(d.data())).toList());
  }

  Future<List<MailModel>> searchMails(
    String query, {
    required String userId,
    required String userEmail,
    int limit = 50,
  }) async {
    if (query.trim().isEmpty) return [];
    final normalized = query.toLowerCase();

    // Fetch mails (no orderBy --> avoids required index)
    final snapshot =
        await _fire
            .collection('mails')
            .where('userIds', arrayContainsAny: [userId, userEmail])
            .limit(200)
            .get();

    final mails =
        snapshot.docs.map((d) => MailModel.fromMap(d.data())).toList();

    final filtered =
        mails.where((mail) {
          final subject = mail.subject.toLowerCase();
          final body = mail.body.toLowerCase();
          final from = mail.from.toLowerCase();
          final to = mail.to.toLowerCase();
          final cc = (mail.cc ?? "").toLowerCase();
          final category = mail.category.toLowerCase();

          return subject.contains(normalized) ||
              body.contains(normalized) ||
              from.contains(normalized) ||
              to.contains(normalized) ||
              cc.contains(normalized) ||
              category.contains(normalized);
        }).toList();

    filtered.sort((a, b) {
      final aScore = _scoreForQuery(a, normalized);
      final bScore = _scoreForQuery(b, normalized);
      return bScore.compareTo(aScore);
    });

    return filtered.take(limit).toList();
  }

  int _scoreForQuery(MailModel m, String q) {
    int score = 0;

    final subject = m.subject.toLowerCase();
    final body = m.body.toLowerCase();
    final from = m.from.toLowerCase();
    final to = m.to.toLowerCase();
    final cc = (m.cc ?? "").toLowerCase();
    final category = m.category.toLowerCase();

    if (subject.contains(q)) score += 30;
    if (subject.startsWith(q)) score += 15;

    if (from.contains(q) || to.contains(q) || cc.contains(q)) score += 20;

    if (body.contains(q)) score += 10;

    if (category.contains(q)) score += 5;

    return score;
  }
}
