import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gmail_clone/data/models/mail.dart';

class MailRepository {
  final _fire = FirebaseFirestore.instance;

  Future<void> sendMail(MailModel mail) async {
    log("📨 [SEND] Sending mail: ${mail.toMap()}");
    try {
      final mailData = mail.toMap();

      if (mailData["from"] == null || mailData["from"].toString().isEmpty) {
        throw Exception("Mail 'from' field is missing or empty");
      }

      log(
        "📨 [SEND] From: ${mailData["from"]}, To: ${mailData["to"]}, Subject: ${mailData["subject"]}",
      );

      await _fire
          .collection("mails")
          .doc(mail.id)
          .set(mailData, SetOptions(merge: false));

      log("✅ [SEND] Mail stored successfully with ID: ${mail.id}");
      log("✅ [SEND] Mail stored successfully.");
    } catch (e) {
      log("❌ [SEND][ERROR] Failed to send mail: $e");
      log("❌ [SEND][ERROR] Failed to send mail: $e");
      rethrow;
    }
  }

  Stream<List<MailModel>> getInbox(String userEmail) {
    log("📥 [INBOX] Listening for inbox mails of: $userEmail");
    return _fire
        .collection("mails")
        .where("to", isEqualTo: userEmail)
        .where("isDeleted", isEqualTo: false)
        .snapshots()
        .map((s) {
          log("📥 [INBOX] Received ${s.docs.length} mails");
          return s.docs.map((d) => MailModel.fromMap(d.data())).toList();
        });
  }

  Stream<List<MailModel>> getSent(String userEmail) {
    log("📤 [SENT] Listening for sent mails of: $userEmail");
    return _fire
        .collection("mails")
        .where("from", isEqualTo: userEmail)
        .snapshots()
        .map((s) {
          log("📤 [SENT] Received ${s.docs.length} mails");
          return s.docs.map((d) => MailModel.fromMap(d.data())).toList();
        });
  }

  Stream<List<MailModel>> getAllInboxes(List<String> userEmails) {
    log("📥 [ALL INBOXES] Listening for inbox mails of: $userEmails");
    if (userEmails.isEmpty) {
      return Stream.value([]);
    }

    if (userEmails.length <= 10) {
      return _fire
          .collection("mails")
          .where("to", whereIn: userEmails)
          .where("isDeleted", isEqualTo: false)
          .snapshots()
          .map((s) {
            log("📥 [ALL INBOXES] Received ${s.docs.length} mails");
            return s.docs.map((d) => MailModel.fromMap(d.data())).toList();
          });
    } else {
      final limitedEmails = userEmails.take(10).toList();
      return _fire
          .collection("mails")
          .where("to", whereIn: limitedEmails)
          .where("isDeleted", isEqualTo: false)
          .snapshots()
          .map((s) {
            log(
              "📥 [ALL INBOXES] Received ${s.docs.length} mails (limited to 10 accounts)",
            );
            return s.docs.map((d) => MailModel.fromMap(d.data())).toList();
          });
    }
  }

  Stream<List<MailModel>> getAllSent(List<String> userEmails) {
    log("📤 [ALL SENT] Listening for sent mails of: $userEmails");
    if (userEmails.isEmpty) {
      return Stream.value([]);
    }

    if (userEmails.length <= 10) {
      return _fire
          .collection("mails")
          .where("from", whereIn: userEmails)
          .snapshots()
          .map((s) {
            log("📤 [ALL SENT] Received ${s.docs.length} mails");
            return s.docs.map((d) => MailModel.fromMap(d.data())).toList();
          });
    } else {
      final limitedEmails = userEmails.take(10).toList();
      return _fire
          .collection("mails")
          .where("from", whereIn: limitedEmails)
          .snapshots()
          .map((s) {
            log(
              "📤 [ALL SENT] Received ${s.docs.length} mails (limited to 10 accounts)",
            );
            return s.docs.map((d) => MailModel.fromMap(d.data())).toList();
          });
    }
  }

  Future<void> toggleStar(String id, bool value) async {
    log("⭐ [STAR] Mail $id → $value");
    try {
      await _fire.collection("mails").doc(id).update({"starred": value});
    } catch (e) {
      log("❌ [STAR][ERROR] $e");
    }
  }

  Future<void> toggleImportant(String id, bool value) async {
    log("❗ [IMPORTANT] Mail $id → $value");
    try {
      await _fire.collection("mails").doc(id).update({"important": value});
    } catch (e) {
      log("❌ [IMPORTANT][ERROR] $e");
      rethrow;
    }
  }

  Future<void> deleteMail(String id) async {
    log("🗑 [DELETE] Marking mail $id as deleted");
    try {
      await _fire.collection("mails").doc(id).update({"isDeleted": true});
    } catch (e) {
      log("❌ [DELETE][ERROR] $e");
    }
  }

  Stream<List<MailModel>> getDeleted(String userEmail) {
    log("🗑 [BIN] Listening for deleted mails of: $userEmail");
    return _fire
        .collection("mails")
        .where("to", isEqualTo: userEmail)
        .where("isDeleted", isEqualTo: true)
        .snapshots()
        .map((s) {
          log("🗑 [BIN] Received ${s.docs.length} mails");
          return s.docs.map((d) => MailModel.fromMap(d.data())).toList();
        });
  }

  Stream<List<MailModel>> getImportant(String email) {
    return _fire
        .collection("mails")
        .where("to", isEqualTo: email)
        .where("important", isEqualTo: true)
        .snapshots()
        .map((s) => s.docs.map((d) => MailModel.fromMap(d.data())).toList());
  }
}
