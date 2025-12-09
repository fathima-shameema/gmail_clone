part of 'compose_bloc.dart';

@immutable
class ComposeState {
  final bool expandFrom;
  final bool expandTo;
  final String selectedFrom;
  final bool isSending;

  const ComposeState({
    required this.expandFrom,
    required this.expandTo,
    required this.selectedFrom,
    required this.isSending,
  });

  factory ComposeState.initial(String initialFrom) => ComposeState(
        expandFrom: false,
        expandTo: false,
        selectedFrom: initialFrom,
        isSending: false,
      );

  ComposeState copyWith({
    bool? expandFrom,
    bool? expandTo,
    String? selectedFrom,
    bool? isSending,
  }) {
    return ComposeState(
      expandFrom: expandFrom ?? this.expandFrom,
      expandTo: expandTo ?? this.expandTo,
      selectedFrom: selectedFrom ?? this.selectedFrom,
      isSending: isSending ?? this.isSending,
    );
  }
}
