class MailModel {
  final String id;
  final String from;
  final String to;
  final String? cc;
  final String subject;
  final String body;
  final DateTime timestamp;
  final bool starred;
  final bool important;
  final String category;
  final bool isSent;
  final bool isDeleted;

  MailModel({
    required this.id,
    required this.from,
    required this.to,
    this.cc,
    required this.subject,
    required this.body,
    required this.timestamp,
    this.starred = false,
    this.important = false,
    this.category = "primary",
    this.isSent = true,
    this.isDeleted = false,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "from": from,
    "to": to,
    "cc": cc,
    "subject": subject,
    "body": body,
    "timestamp": timestamp.toIso8601String(),
    "starred": starred,
    "important": important,
    "category": category,
    "isSent": isSent,
    "isDeleted": isDeleted,
  };

  factory MailModel.fromMap(Map<String, dynamic> map) {
    return MailModel(
      id: map["id"] ?? "",
      from: map["from"] ?? "",
      to: map["to"] ?? "",
      cc: map["cc"],
      subject: map["subject"] ?? "",
      body: map["body"] ?? "",
      timestamp: DateTime.tryParse(map["timestamp"] ?? "") ?? DateTime.now(),
      starred: map["starred"] ?? false,
      important: map["important"] ?? false,
      category: map["category"] ?? "primary",
      isSent: map["isSent"] ?? true,
      isDeleted: map["isDeleted"] ?? false,
    );
  }
}
