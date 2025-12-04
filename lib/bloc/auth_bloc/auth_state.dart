part of 'auth_bloc.dart';

class AuthState {
  final List<AppUser> accounts;
  final AppUser? activeUser;
  final bool loading;
  final String? error;

  AuthState({
    this.accounts = const [],
    this.activeUser,
    this.loading = false,
    this.error,
  });

  AuthState copyWith({
    List<AppUser>? accounts,
    AppUser? activeUser,
    bool? loading,
    String? error,
  }) {
    return AuthState(
      accounts: accounts ?? this.accounts,
      activeUser: activeUser ?? this.activeUser,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
