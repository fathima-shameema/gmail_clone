part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoadSavedAccounts extends AuthEvent {}

class SignInWithGoogle extends AuthEvent {}

class SwitchAccount extends AuthEvent {
  final AppUser user;
  SwitchAccount(this.user);
}

class SignOut extends AuthEvent {}
