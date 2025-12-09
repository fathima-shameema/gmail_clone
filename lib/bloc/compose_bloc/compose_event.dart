part of 'compose_bloc.dart';

@immutable
abstract class ComposeEvent {}

class ToggleExpandFromEvent extends ComposeEvent {}

class ToggleExpandToEvent extends ComposeEvent {}

class SetSelectedFromEvent extends ComposeEvent {
  final String from;
  SetSelectedFromEvent(this.from);
}

class StartSendingEvent extends ComposeEvent {}

class StopSendingEvent extends ComposeEvent {}
