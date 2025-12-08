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
