// lib/bloc/mail_state.dart
part of 'mail_bloc.dart';

enum DrawerFilterType {
  allInboxes,
  primary,
  promotions,
  social,
  starred,
  important,
  sent,
  spam,
  bin
}

class MailState {
  final List<MailModel> inbox;
  final List<MailModel> sent;
  final List<MailModel> bin;
  final List<MailModel> important;
  final DrawerFilterType filterType;
  final bool loading;
  final String? error;
  final Set<String> expandedMailInfoIds;

  MailState({
    List<MailModel>? inbox,
    List<MailModel>? sent,
    List<MailModel>? bin,
    List<MailModel>? important,
    this.filterType = DrawerFilterType.primary,
    this.loading = false,
    this.error,
    Set<String>? expandedMailInfoIds,
  })  : inbox = inbox ?? [],
        sent = sent ?? [],
        bin = bin ?? [],
        important = important ?? [],
        expandedMailInfoIds = expandedMailInfoIds ?? {};

  MailState copyWith({
    List<MailModel>? inbox,
    List<MailModel>? sent,
    List<MailModel>? bin,
    List<MailModel>? important,
    DrawerFilterType? filterType,
    bool? loading,
    String? error,
    Set<String>? expandedMailInfoIds,
  }) {
    return MailState(
      inbox: inbox ?? this.inbox,
      sent: sent ?? this.sent,
      bin: bin ?? this.bin,
      important: important ?? this.important,
      filterType: filterType ?? this.filterType,
      loading: loading ?? this.loading,
      error: error,
      expandedMailInfoIds: expandedMailInfoIds ?? this.expandedMailInfoIds,
    );
  }
}
