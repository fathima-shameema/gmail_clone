import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/presentation/screens/auth/signup_screen.dart';
import 'package:gmail_clone/presentation/screens/home/home_screen.dart';
import 'package:gmail_clone/presentation/widgets/custom_loader.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.loading) {
          return const Scaffold(
            body: Center(child: CustomLoader()),
          );
        }

        if (state.activeUser == null) {
          return const SignupScreen();
        }

        return const HomeScreen();
      },
    );
  }
}
