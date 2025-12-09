// lib/data/repository/mail_repository.dart
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gmail_clone/data/models/mail.dart';

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
    final Map<String, dynamic> userStatus = {};

    userStatus[senderUid] = {
      "starred": false,
      "important": false,
      "deleted": false,
    };

    final toReceiverUid = await _uidForEmail(mail.to);
    if (toReceiverUid != null) {
      userStatus[toReceiverUid] = {
        "starred": false,
        "important": false,
        "deleted": false,
      };
    } else {
      userStatus[mail.to] = {
        "starred": false,
        "important": false,
        "deleted": false,
      };
    }

    if (mail.cc != null && mail.cc!.trim().isNotEmpty) {
      // support single or multiple (comma-separated)
      final ccList =
          mail.cc!
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      for (final ccEmail in ccList) {
        final ccUid = await _uidForEmail(ccEmail);

        if (ccUid != null) {
          userStatus[ccUid] = {
            "starred": false,
            "important": false,
            "deleted": false,
          };
        } else {
          userStatus[ccEmail] = {
            "starred": false,
            "important": false,
            "deleted": false,
          };
        }
      }
    }

    // finally write mail
    await _fire.collection("mails").doc(mail.id).set({
      ...mail.toMap(),
      "userStatus": userStatus,
      "userIds": userStatus.keys.toList(),
    });
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
                        m.userStatus[email]?['deleted'] == true),
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
            .where((m) => !m.isDeletedFor(uid, /* choose a fallback email if available */ ''))
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
}
