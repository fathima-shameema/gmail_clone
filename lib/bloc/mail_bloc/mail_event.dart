// lib/bloc/mail_event.dart
part of 'mail_bloc.dart';

abstract class MailEvent {}

class SendMailEvent extends MailEvent {
  final MailModel mail;
  final String senderUid;
  SendMailEvent(this.mail, this.senderUid);
}

class LoadInboxEvent extends MailEvent {
  final String email;
  final String uid;
  LoadInboxEvent(this.email, this.uid);
}

class LoadSentEvent extends MailEvent {
  final String email;
  final String uid;
  LoadSentEvent(this.email, this.uid);
}

class LoadImportantEvent extends MailEvent {
  final String uid;
  LoadImportantEvent(this.uid);
}

class LoadBinEvent extends MailEvent {
  final String uid;
  LoadBinEvent(this.uid);
}

class LoadAllInboxesEvent extends MailEvent {
  final List<String> emails;
  final String uid;
  LoadAllInboxesEvent(this.emails, this.uid);
}

class LoadAllSentEvent extends MailEvent {
  final List<String> emails;
  final String uid;
  LoadAllSentEvent(this.emails, this.uid);
}

class ToggleStarEvent extends MailEvent {
  final String mailId;
  final String uid;
  final bool value;
  ToggleStarEvent(this.mailId, this.uid, this.value);
}

class ToggleImportantEvent extends MailEvent {
  final String mailId;
  final String uid;
  final bool value;
  ToggleImportantEvent(this.mailId, this.uid, this.value);
}

class DeleteMailEvent extends MailEvent {
  final String mailId;
  final String uid;
  DeleteMailEvent(this.mailId, this.uid);
}

class EmptyBinEvent extends MailEvent {
  final String uid;
  EmptyBinEvent(this.uid);
}

class AutoCleanBinEvent extends MailEvent {
  final String uid;
  AutoCleanBinEvent(this.uid);
}

class SetDrawerFilterEvent extends MailEvent {
  final DrawerFilterType filterType;
  SetDrawerFilterEvent(this.filterType);
}

class ToggleMailInfoEvent extends MailEvent {
  final String mailId;
  ToggleMailInfoEvent(this.mailId);
}

class ResetMailStateEvent extends MailEvent {}
