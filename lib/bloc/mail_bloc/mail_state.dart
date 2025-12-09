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
  final bool loading; // existing (used for sending)
  final bool inboxLoading;
  final bool sentLoading;
  final bool allInboxLoading;
  final bool allSentLoading;
  final bool importantLoading;
  final bool binLoading;

  final List<MailModel> inbox;
  final List<MailModel> sent;
  final List<MailModel> important;
  final List<MailModel> bin;

  final Set<String> expandedMailInfoIds;
  final DrawerFilterType filterType;
  final String? error;

  MailState({
    this.loading = false,
    this.inboxLoading = false,
    this.sentLoading = false,
    this.allInboxLoading = false,
    this.allSentLoading = false,
    this.importantLoading = false,
    this.binLoading = false,
    this.inbox = const [],
    this.sent = const [],
    this.important = const [],
    this.bin = const [],
    this.expandedMailInfoIds = const {},
    this.filterType = DrawerFilterType.primary,
    this.error,
  });

  MailState copyWith({
    bool? loading,
    bool? inboxLoading,
    bool? sentLoading,
    bool? allInboxLoading,
    bool? allSentLoading,
    bool? importantLoading,
    bool? binLoading,
    List<MailModel>? inbox,
    List<MailModel>? sent,
    List<MailModel>? important,
    List<MailModel>? bin,
    Set<String>? expandedMailInfoIds,
    DrawerFilterType? filterType,
    String? error,
  }) {
    return MailState(
      loading: loading ?? this.loading,
      inboxLoading: inboxLoading ?? this.inboxLoading,
      sentLoading: sentLoading ?? this.sentLoading,
      allInboxLoading: allInboxLoading ?? this.allInboxLoading,
      allSentLoading: allSentLoading ?? this.allSentLoading,
      importantLoading: importantLoading ?? this.importantLoading,
      binLoading: binLoading ?? this.binLoading,
      inbox: inbox ?? this.inbox,
      sent: sent ?? this.sent,
      important: important ?? this.important,
      bin: bin ?? this.bin,
      expandedMailInfoIds: expandedMailInfoIds ?? this.expandedMailInfoIds,
      filterType: filterType ?? this.filterType,
      error: error,
    );
  }
}
