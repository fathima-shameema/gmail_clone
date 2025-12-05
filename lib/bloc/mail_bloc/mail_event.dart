part of 'mail_bloc.dart';

abstract class MailEvent {}

class SendMailEvent extends MailEvent {
  final MailModel mail;
  SendMailEvent(this.mail);
}

class LoadInboxEvent extends MailEvent {
  final String email;
  LoadInboxEvent(this.email);
}

class LoadSentEvent extends MailEvent {
  final String email;
  LoadSentEvent(this.email);
}

class ToggleStarEvent extends MailEvent {
  final String id;
  final bool value;
  ToggleStarEvent(this.id, this.value);
}
