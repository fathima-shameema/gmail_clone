import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/presentation/widgets/google_signin_button.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              Center(
                child: Image.asset(
                  "assets/icons/gmail_5968534.png",
                  height: 80,
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Welcome",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),
              const Text("Sign in to continue", style: TextStyle(fontSize: 16)),

              const SizedBox(height: 40),

              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state.activeUser != null) {
                    Navigator.pushReplacementNamed(context, '/Home');
                  }
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return GoogleSignInButton(
                      isLoading: state.loading,
                      onPressed: () {
                        if (!state.loading) {
                          context.read<AuthBloc>().add(SignInWithGoogle());
                        }
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "Use another account",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Center(
                child: Text(
                  "By continuing, you agree to our Terms & Privacy Policy",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
