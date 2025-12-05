import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gmail_clone/bloc/auth_bloc/auth_bloc.dart';
import 'package:gmail_clone/bloc/mail_bloc/mail_bloc.dart';
import 'package:gmail_clone/data/local/local_storage.dart';
import 'package:gmail_clone/data/repository/auth_repository.dart';
import 'package:gmail_clone/data/repository/mail_repository.dart';
import 'package:gmail_clone/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final mailRepo = MailRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  AuthBloc(AuthRepository(), LocalStorage())
                    ..add(LoadSavedAccounts()),
        ),
        BlocProvider(create: (context) => MailBloc(mailRepo)),
      ],
      child: const MyApp(),
    ),
  );
}
