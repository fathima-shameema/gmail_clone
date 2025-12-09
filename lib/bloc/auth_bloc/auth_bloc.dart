import 'package:bloc/bloc.dart';
import 'package:gmail_clone/data/local/local_storage.dart';
import 'package:gmail_clone/data/models/user_account.dart';
import 'package:gmail_clone/data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;
  final LocalStorage storage;

  AuthBloc(this.authRepo, this.storage) : super(AuthState()) {
    on<LoadSavedAccounts>(_onLoadSaved);
    on<SignInWithGoogle>(_onSignIn);
    on<SwitchAccount>(_onSwitch);
    on<SignOut>(_onSignOut);
    add(LoadSavedAccounts());
  }
  Future<void> _onLoadSaved(
    LoadSavedAccounts event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    final accounts = await storage.loadAccounts();
    final active = await storage.loadActiveUser();

    emit(
      state.copyWith(loading: false, accounts: accounts, activeUser: active),
    );
  }

  Future<void> _onSignIn(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final user = await authRepo.signInWithGoogle();

      if (user == null) {
        emit(state.copyWith(loading: false, error: "Sign-in cancelled"));
        return;
      }

      await storage.saveAccount(user);
      await storage.saveActiveUser(user);

      final accounts = await storage.loadAccounts();

      emit(
        state.copyWith(loading: false, accounts: accounts, activeUser: user),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: "Google sign-in failed: $e"));
    }
  }

  Future<void> _onSwitch(SwitchAccount event, Emitter<AuthState> emit) async {
    await storage.saveActiveUser(event.user);

    emit(state.copyWith(activeUser: event.user, error: null));
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    await authRepo.signOut();
    await storage.clearActiveUser();

    emit(state.copyWith(activeUser: null));
  }
}
