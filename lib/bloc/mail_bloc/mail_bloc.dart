// lib/bloc/mail_bloc.dart
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
    on<ResetMailStateEvent>((event, emit) => emit(MailState()));
    on<ToggleMailInfoEvent>(_onToggleMailInfo);
    on<ToggleImportantEvent>(_onToggleImportant);
    on<LoadImportantEvent>(_onLoadImportant);
    on<EmptyBinEvent>(_onEmptyBin);
    on<AutoCleanBinEvent>(_onAutoCleanBin);
  }

  Future<void> _onSendMail(SendMailEvent event, Emitter<MailState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      await repo.sendMail(event.mail, event.senderUid);
      emit(state.copyWith(loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onLoadInbox(LoadInboxEvent event, Emitter<MailState> emit) async {
    await emit.forEach<List<MailModel>>(
      repo.getInbox(event.email, event.uid),
      onData: (list) => state.copyWith(inbox: list),
      onError: (err, st) => state.copyWith(error: err.toString()),
    );
  }

  Future<void> _onLoadSent(LoadSentEvent event, Emitter<MailState> emit) async {
    await emit.forEach<List<MailModel>>(
      repo.getSent(event.email, event.uid),
      onData: (list) => state.copyWith(sent: list),
      onError: (err, st) => state.copyWith(error: err.toString()),
    );
  }

  Future<void> _onLoadAllInboxes(LoadAllInboxesEvent event, Emitter<MailState> emit) async {
    await emit.forEach<List<MailModel>>(
      repo.getAllInboxes(event.emails, event.uid),
      onData: (list) => state.copyWith(inbox: list),
      onError: (err, st) => state.copyWith(error: err.toString()),
    );
  }

  Future<void> _onLoadAllSent(LoadAllSentEvent event, Emitter<MailState> emit) async {
    await emit.forEach<List<MailModel>>(
      repo.getAllSent(event.emails, event.uid),
      onData: (list) => state.copyWith(sent: list),
      onError: (err, st) => state.copyWith(error: err.toString()),
    );
  }

  void _onSetDrawerFilter(SetDrawerFilterEvent e, Emitter<MailState> emit) {
    emit(state.copyWith(filterType: e.filterType));
  }

  Future<void> _onToggleStar(ToggleStarEvent e, Emitter<MailState> emit) async {
    await repo.toggleStar(e.mailId, e.uid, e.value);
  }

  Future<void> _onToggleImportant(ToggleImportantEvent e, Emitter<MailState> emit) async {
    await repo.toggleImportant(e.mailId, e.uid, e.value);
  }

  Future<void> _onDeleteMail(DeleteMailEvent e, Emitter<MailState> emit) async {
    await repo.deleteMail(e.mailId, e.uid);
  }

  Future<void> _onLoadBin(LoadBinEvent e, Emitter<MailState> emit) async {
    await emit.forEach<List<MailModel>>(
      repo.getBin(e.uid),
      onData: (list) => state.copyWith(bin: list),
      onError: (err, st) => state.copyWith(error: err.toString()),
    );
  }

  Future<void> _onLoadImportant(LoadImportantEvent e, Emitter<MailState> emit) async {
    await emit.forEach<List<MailModel>>(
      repo.getImportant(e.uid),
      onData: (list) => state.copyWith(important: list),
      onError: (err, st) => state.copyWith(error: err.toString()),
    );
  }

  Future<void> _onEmptyBin(EmptyBinEvent e, Emitter<MailState> emit) async {
    await repo.emptyBin(e.uid);
    add(LoadBinEvent(e.uid));
  }

  Future<void> _onAutoCleanBin(AutoCleanBinEvent e, Emitter<MailState> emit) async {
    await repo.autoCleanBin(e.uid);
    add(LoadBinEvent(e.uid));
  }

  void _onToggleMailInfo(ToggleMailInfoEvent e, Emitter<MailState> emit) {
    final current = Set<String>.from(state.expandedMailInfoIds);
    if (current.contains(e.mailId)) {
      current.remove(e.mailId);
    } else {
      current.add(e.mailId);
    }
    emit(state.copyWith(expandedMailInfoIds: current));
  }
}
