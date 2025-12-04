import 'package:equatable/equatable.dart';

enum MailCategory { primary, promotion, social, spam, sent, bin }

class Mail extends Equatable {
  final String id;
  final String fromName;
  final String fromEmail;
  final List<String> to;
  final List<String> cc;
  final String subject;
  final String body;
  final DateTime date;
  final bool starred;
  final MailCategory category;
  final bool isRead;

  const Mail({
    required this.id,
    required this.fromName,
    required this.fromEmail,
    required this.to,
    this.cc = const [],
    required this.subject,
    required this.body,
    required this.date,
    this.starred = false,
    this.category = MailCategory.primary,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id];
}
