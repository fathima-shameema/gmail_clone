import 'package:flutter/material.dart';
import 'package:gmail_clone/data/models/mail.dart';
import 'package:gmail_clone/presentation/screens/home/compose_screen.dart';
import 'package:gmail_clone/presentation/screens/home/home_screen.dart';
import 'package:gmail_clone/presentation/screens/home/mail_details_screen.dart';
import 'package:gmail_clone/resources/themes/theme.dart';
import 'package:gmail_clone/root_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      home: const RootScreen(), 
      routes: {
        '/Home': (context) => HomeScreen(),
        '/Compose mail': (context) => ComposeScreen(),
        '/Mail details': (context) {
          final args = ModalRoute.of(context)!.settings.arguments;

          if (args is Map) {
            final mail = args["mail"] as MailModel?;
            final isSent = args["isSent"] as bool? ?? false;

            return MailDetailsScreen(mail: mail, isSent: isSent);
          }

          return const MailDetailsScreen(isSent: false);
        },
      },
    );
  }
}
