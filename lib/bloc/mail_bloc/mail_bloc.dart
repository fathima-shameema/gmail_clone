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
    on<LoadPromotionsEvent>(_onLoadPromotions);
    on<LoadSocialEvent>(_onLoadSocial);
    on<LoadSpamEvent>(_onLoadSpam);
    on<LoadPrimaryEvent>(_onLoadPrimary);
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

  Future<void> _onLoadInbox(
    LoadInboxEvent event,
    Emitter<MailState> emit,
  ) async {
    emit(state.copyWith(inboxLoading: true));

    await emit.forEach<List<MailModel>>(
      repo.getInbox(event.email, event.uid),
      onData: (list) => state.copyWith(inbox: list, inboxLoading: false),

      onError:
          (err, st) =>
              state.copyWith(error: err.toString(), inboxLoading: false),
    );
  }

  Future<void> _onLoadSent(LoadSentEvent event, Emitter<MailState> emit) async {
    emit(state.copyWith(sentLoading: true));

    await emit.forEach<List<MailModel>>(
      repo.getSent(event.email, event.uid),
      onData: (list) => state.copyWith(sent: list, sentLoading: false),
      onError:
          (err, st) =>
              state.copyWith(error: err.toString(), sentLoading: false),
    );
  }

  Future<void> _onLoadAllInboxes(
    LoadAllInboxesEvent event,
    Emitter<MailState> emit,
  ) async {
    emit(state.copyWith(allInboxLoading: true));

    await emit.forEach<List<MailModel>>(
      repo.getAllInboxes(event.emails, event.uid),
      onData: (list) => state.copyWith(inbox: list, allInboxLoading: false),
      onError:
          (err, st) =>
              state.copyWith(error: err.toString(), allInboxLoading: false),
    );
  }

  Future<void> _onLoadAllSent(
    LoadAllSentEvent event,
    Emitter<MailState> emit,
  ) async {
    emit(state.copyWith(allSentLoading: true));

    await emit.forEach<List<MailModel>>(
      repo.getAllSent(event.emails, event.uid),
      onData: (list) => state.copyWith(sent: list, allSentLoading: false),
      onError:
          (err, st) =>
              state.copyWith(error: err.toString(), allSentLoading: false),
    );
  }

  void _onSetDrawerFilter(SetDrawerFilterEvent e, Emitter<MailState> emit) {
    emit(state.copyWith(filterType: e.filterType));
  }

  Future<void> _onToggleStar(ToggleStarEvent e, Emitter<MailState> emit) async {
    await repo.toggleStar(e.mailId, e.uid, e.value);
  }

  Future<void> _onToggleImportant(
    ToggleImportantEvent e,
    Emitter<MailState> emit,
  ) async {
    await repo.toggleImportant(e.mailId, e.uid, e.value);
  }

  Future<void> _onDeleteMail(DeleteMailEvent e, Emitter<MailState> emit) async {
    await repo.deleteMail(e.mailId, e.uid);
  }

  Future<void> _onLoadBin(LoadBinEvent e, Emitter<MailState> emit) async {
    emit(state.copyWith(binLoading: true));

    await emit.forEach<List<MailModel>>(
      repo.getBin(e.uid),
      onData: (list) => state.copyWith(bin: list, binLoading: false),
      onError:
          (err, st) => state.copyWith(error: err.toString(), binLoading: false),
    );
  }

  Future<void> _onLoadImportant(
    LoadImportantEvent e,
    Emitter<MailState> emit,
  ) async {
    emit(state.copyWith(importantLoading: true));

    await emit.forEach<List<MailModel>>(
      repo.getImportant(e.uid),
      onData:
          (list) => state.copyWith(important: list, importantLoading: false),
      onError:
          (err, st) =>
              state.copyWith(error: err.toString(), importantLoading: false),
    );
  }

  Future<void> _onEmptyBin(EmptyBinEvent e, Emitter<MailState> emit) async {
    await repo.emptyBin(e.uid);
    add(LoadBinEvent(e.uid));
  }

  Future<void> _onAutoCleanBin(
    AutoCleanBinEvent e,
    Emitter<MailState> emit,
  ) async {
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
  Future<void> _onLoadPromotions(
  LoadPromotionsEvent event,
  Emitter<MailState> emit,
) async {
  emit(state.copyWith(inboxLoading: true));

  await emit.forEach<List<MailModel>>(
    repo.getPromotions(),
    onData: (list) => state.copyWith(inbox: list, inboxLoading: false),
    onError: (err, st) =>
        state.copyWith(error: err.toString(), inboxLoading: false),
  );
}

Future<void> _onLoadSocial(
  LoadSocialEvent event,
  Emitter<MailState> emit,
) async {
  emit(state.copyWith(inboxLoading: true));

  await emit.forEach<List<MailModel>>(
    repo.getSocial(),
    onData: (list) => state.copyWith(inbox: list, inboxLoading: false),
    onError: (err, st) =>
        state.copyWith(error: err.toString(), inboxLoading: false),
  );
}

Future<void> _onLoadSpam(
  LoadSpamEvent event,
  Emitter<MailState> emit,
) async {
  emit(state.copyWith(inboxLoading: true));

  await emit.forEach<List<MailModel>>(
    repo.getSpam(),
    onData: (list) => state.copyWith(inbox: list, inboxLoading: false),
    onError: (err, st) =>
        state.copyWith(error: err.toString(), inboxLoading: false),
  );
}

Future<void> _onLoadPrimary(
  LoadPrimaryEvent event,
  Emitter<MailState> emit,
) async {
  emit(state.copyWith(inboxLoading: true));

  await emit.forEach<List<MailModel>>(
    repo.getPrimary(),
    onData: (list) => state.copyWith(inbox: list, inboxLoading: false),
    onError: (err, st) =>
        state.copyWith(error: err.toString(), inboxLoading: false),
  );
}

}
