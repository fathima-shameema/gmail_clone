import 'package:flutter/material.dart';
import 'package:gmail_clone/presentation/screens/home/compose_screen.dart';
import 'package:gmail_clone/presentation/screens/home/home_screen.dart';
import 'package:gmail_clone/presentation/screens/auth/signup_screen.dart';
import 'package:gmail_clone/presentation/screens/home/mail_details_screen.dart';
import 'package:gmail_clone/resources/themes/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => SignupScreen(),
        '/Home': (context) => HomeScreen(),
        '/Compose mail': (context) => ComposeScreen(),
        '/Mail details': (context) => MailDetailsScreen(),
      },
    );
  }
}
