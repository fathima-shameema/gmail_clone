part of 'mail_bloc.dart';

class MailState {
  final List<MailModel> inbox;
  final List<MailModel> sent;
  final bool loading;
  final String? error;

  MailState({
    this.inbox = const [],
    this.sent = const [],
    this.loading = false,
    this.error,
  });

  MailState copyWith({
    List<MailModel>? inbox,
    List<MailModel>? sent,
    bool? loading,
    String? error,
  }) {
    return MailState(
      inbox: inbox ?? this.inbox,
      sent: sent ?? this.sent,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
