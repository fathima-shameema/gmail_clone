import 'package:bloc/bloc.dart';
import 'package:gmail_clone/data/models/mail.dart';
import 'package:gmail_clone/data/repository/mail_repository.dart';

part 'mail_event.dart';
part 'mail_state.dart';

class MailBloc extends Bloc<MailEvent, MailState> {
  final MailRepository repo;

  MailBloc(this.repo) : super(MailState()) {
    on<SendMailEvent>(_onSendMail);
    on<LoadInboxEvent>(_onLoadInbox);
    on<LoadSentEvent>(_onLoadSent);
    on<LoadAllInboxesEvent>(_onLoadAllInboxes);
    on<LoadAllSentEvent>(_onLoadAllSent);
    on<SetDrawerFilterEvent>(_onSetDrawerFilter);
    on<ToggleStarEvent>(_onToggleStar);
    on<DeleteMailEvent>(_onDeleteMail);
    on<LoadBinEvent>(_onLoadBin);
  }

  Future<void> _onSendMail(SendMailEvent event, Emitter<MailState> emit) async {
    emit(state.copyWith(loading: true));

    try {
      await repo.sendMail(event.mail);
      emit(state.copyWith(loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onLoadInbox(
    LoadInboxEvent event,
    Emitter<MailState> emit,
  ) async {
    await emit.forEach(
      repo.getInbox(event.email),
      onData: (List<MailModel> list) {
        return state.copyWith(inbox: list);
      },
      onError: (error, stackTrace) {
        return state.copyWith(error: error.toString());
      },
    );
  }

  Future<void> _onLoadSent(LoadSentEvent event, Emitter<MailState> emit) async {
    await emit.forEach(
      repo.getSent(event.email),
      onData: (List<MailModel> list) {
        return state.copyWith(sent: list);
      },
      onError: (error, stackTrace) {
        return state.copyWith(error: error.toString());
      },
    );
  }

  Future<void> _onLoadAllInboxes(
    LoadAllInboxesEvent event,
    Emitter<MailState> emit,
  ) async {
    await emit.forEach(
      repo.getAllInboxes(event.emails),
      onData: (List<MailModel> list) {
        return state.copyWith(inbox: list);
      },
      onError: (error, stackTrace) {
        return state.copyWith(error: error.toString());
      },
    );
  }

  Future<void> _onLoadAllSent(
    LoadAllSentEvent event,
    Emitter<MailState> emit,
  ) async {
    await emit.forEach(
      repo.getAllSent(event.emails),
      onData: (List<MailModel> list) {
        return state.copyWith(sent: list);
      },
      onError: (error, stackTrace) {
        return state.copyWith(error: error.toString());
      },
    );
  }

  void _onSetDrawerFilter(SetDrawerFilterEvent event, Emitter<MailState> emit) {
    emit(state.copyWith(filterType: event.filterType));
  }

  Future<void> _onToggleStar(
    ToggleStarEvent event,
    Emitter<MailState> emit,
  ) async {
    await repo.toggleStar(event.id, event.value);
  }

  Future<void> _onDeleteMail(
    DeleteMailEvent event,
    Emitter<MailState> emit,
  ) async {
    await repo.deleteMail(event.id);
  }

  Future<void> _onLoadBin(LoadBinEvent event, Emitter<MailState> emit) async {
    await emit.forEach(
      repo.getDeleted(event.email),
      onData: (list) => state.copyWith(bin: list),
      onError: (error, stackTrace) => state.copyWith(error: error.toString()),
    );
  }
}
