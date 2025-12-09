import 'package:bloc/bloc.dart';

part 'compose_event.dart';
part 'compose_state.dart';

class ComposeBloc extends Bloc<ComposeEvent, ComposeState> {
  ComposeBloc({required String initialFrom})
    : super(ComposeState.initial(initialFrom)) {
    on<ToggleExpandFromEvent>((e, emit) {
      emit(state.copyWith(expandFrom: !state.expandFrom));
    });

    on<ToggleExpandToEvent>((e, emit) {
      emit(state.copyWith(expandTo: !state.expandTo));
    });

    on<SetSelectedFromEvent>((e, emit) {
      emit(state.copyWith(selectedFrom: e.from, expandFrom: false));
    });

    on<StartSendingEvent>((e, emit) {
      emit(state.copyWith(isSending: true));
    });

    on<StopSendingEvent>((e, emit) {
      emit(state.copyWith(isSending: false));
    });
  }
}
