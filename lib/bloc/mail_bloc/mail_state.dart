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
  bin,
}

class MailState {
  final List<MailModel> inbox;
  final List<MailModel> sent;
  final bool loading;
  final String? error;
  final DrawerFilterType filterType;
  final List<MailModel> bin;
  final Set<String> expandedMailInfoIds;
  final List<MailModel> important;

  MailState({
    this.inbox = const [],
    this.sent = const [],
    this.loading = false,
    this.error,
    this.filterType = DrawerFilterType.primary,
    this.bin = const [],
    this.expandedMailInfoIds = const {},
    this.important = const [],
  });

  MailState copyWith({
    List<MailModel>? inbox,
    List<MailModel>? sent,
    bool? loading,
    String? error,
    DrawerFilterType? filterType,
    List<MailModel>? bin,
    Set<String>? expandedMailInfoIds,
    List<MailModel>? important,
  }) {
    return MailState(
      inbox: inbox ?? this.inbox,
      sent: sent ?? this.sent,
      loading: loading ?? this.loading,
      error: error,
      filterType: filterType ?? this.filterType,
      bin: bin ?? this.bin,
      expandedMailInfoIds: expandedMailInfoIds ?? this.expandedMailInfoIds,
      important: important ?? this.important,
    );
  }
}
