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

class LoadAllInboxesEvent extends MailEvent {
  final List<String> emails;
  LoadAllInboxesEvent(this.emails);
}

class LoadAllSentEvent extends MailEvent {
  final List<String> emails;
  LoadAllSentEvent(this.emails);
}

class SetDrawerFilterEvent extends MailEvent {
  final DrawerFilterType filterType;
  SetDrawerFilterEvent(this.filterType);
}

class ToggleStarEvent extends MailEvent {
  final String id;
  final bool value;
  ToggleStarEvent(this.id, this.value);
}

class DeleteMailEvent extends MailEvent {
  final String id;
  DeleteMailEvent(this.id);
}

class LoadBinEvent extends MailEvent {
  final String email;
  LoadBinEvent(this.email);
}

class ResetMailStateEvent extends MailEvent {}

class ToggleMailInfoEvent extends MailEvent {
  final String mailId;
  ToggleMailInfoEvent(this.mailId);
}

class ToggleImportantEvent extends MailEvent {
  final String id;
  final bool value;

  ToggleImportantEvent(this.id, this.value);
}

class LoadImportantEvent extends MailEvent {
  final String email;
  LoadImportantEvent(this.email);
}

class EmptyBinEvent extends MailEvent {
  final String email;
  EmptyBinEvent(this.email);
}


class AutoCleanBinEvent extends MailEvent {
  final String email;
  AutoCleanBinEvent(this.email);
}
