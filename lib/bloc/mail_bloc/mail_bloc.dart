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
    on<ToggleStarEvent>(_onToggleStar);
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
    repo.getInbox(event.email).listen((list) {
      emit(state.copyWith(inbox: list));
    });
  }

  Future<void> _onLoadSent(LoadSentEvent event, Emitter<MailState> emit) async {
    repo.getSent(event.email).listen((list) {
      emit(state.copyWith(sent: list));
    });
  }

  Future<void> _onToggleStar(
    ToggleStarEvent event,
    Emitter<MailState> emit,
  ) async {
    await repo.toggleStar(event.id, event.value);
  }
}
