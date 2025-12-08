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

  MailState({
    this.inbox = const [],
    this.sent = const [],
    this.loading = false,
    this.error,
    this.filterType = DrawerFilterType.primary,
  });

  MailState copyWith({
    List<MailModel>? inbox,
    List<MailModel>? sent,
    bool? loading,
    String? error,
    DrawerFilterType? filterType,
  }) {
    return MailState(
      inbox: inbox ?? this.inbox,
      sent: sent ?? this.sent,
      loading: loading ?? this.loading,
      error: error,
      filterType: filterType ?? this.filterType,
    );
  }
}
