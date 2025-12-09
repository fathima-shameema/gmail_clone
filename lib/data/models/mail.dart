// lib/data/models/mail.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class MailModel {
  final String id;
  final String from;
  final String to;
  final String? cc;
  final String subject;
  final String body;
  final DateTime timestamp;
  final Map<String, dynamic> userStatus;
  // optional list of userIds who are part of mail (sender + receiver)
  final List<String> userIds;

  MailModel({
    required this.id,
    required this.from,
    required this.to,
    required this.cc,
    required this.subject,
    required this.body,
    required this.timestamp,
    required this.userStatus,
    required this.userIds,
  });

  factory MailModel.fromMap(Map<String, dynamic> map) {
    return MailModel(
      id: map['id'] as String,
      from: map['from'] as String,
      to: map['to'] as String,
      cc: map['cc'] as String?,
      subject: map['subject'] as String? ?? '',
      body: map['body'] as String? ?? '',
      timestamp:
          (map['timestamp'] is Timestamp)
              ? (map['timestamp'] as Timestamp).toDate()
              : (map['timestamp'] is DateTime)
              ? map['timestamp'] as DateTime
              : DateTime.now(),
      userStatus: Map<String, dynamic>.from(map['userStatus'] ?? {}),
      userIds:
          (map['userIds'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "from": from,
      "to": to,
      "cc": cc,
      "subject": subject,
      "body": body,
      "timestamp": timestamp,
      "userStatus": userStatus,
      "userIds": userIds,
    };
  }

  bool isDeleted(String uid) => userStatus[uid]?["deleted"] ?? false;
  bool isStarred(String uid) => userStatus[uid]?["starred"] ?? false;
  bool isImportant(String uid) => userStatus[uid]?["important"] ?? false;

  bool starred(String uid) => isStarred(uid);
  bool important(String uid) => isImportant(uid);

  bool isDeletedFor(String uid, String email) {
    final uidEntry = userStatus[uid];
    if (uidEntry != null && uidEntry is Map && uidEntry['deleted'] != null) {
      return uidEntry['deleted'] as bool;
    }

    final emailEntry = userStatus[email];
    if (emailEntry != null &&
        emailEntry is Map &&
        emailEntry['deleted'] != null) {
      return emailEntry['deleted'] as bool;
    }

    return false;
  }

  bool isStarredFor(String uid, String email) {
    final uidEntry = userStatus[uid];
    if (uidEntry != null && uidEntry is Map && uidEntry['starred'] != null) {
      return uidEntry['starred'] as bool;
    }
    final emailEntry = userStatus[email];
    if (emailEntry != null &&
        emailEntry is Map &&
        emailEntry['starred'] != null) {
      return emailEntry['starred'] as bool;
    }
    return false;
  }

  bool isImportantFor(String uid, String email) {
    final uidEntry = userStatus[uid];
    if (uidEntry != null && uidEntry is Map && uidEntry['important'] != null) {
      return uidEntry['important'] as bool;
    }
    final emailEntry = userStatus[email];
    if (emailEntry != null &&
        emailEntry is Map &&
        emailEntry['important'] != null) {
      return emailEntry['important'] as bool;
    }
    return false;
  }
}
