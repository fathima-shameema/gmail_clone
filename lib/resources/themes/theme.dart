
import 'package:flutter/material.dart';
import 'package:gmail_clone/resources/themes/custom_themes/alert_dialogue_theme.dart';
import 'package:gmail_clone/resources/themes/custom_themes/app_bar_theme.dart';
import 'package:gmail_clone/resources/themes/custom_themes/checkbox_theme.dart';
import 'package:gmail_clone/resources/themes/custom_themes/elevated_button_theme.dart';
import 'package:gmail_clone/resources/themes/custom_themes/icons_theme.dart';
import 'package:gmail_clone/resources/themes/custom_themes/snack_bar_theme.dart';
import 'package:gmail_clone/resources/themes/custom_themes/text_button_theme.dart';
import 'package:gmail_clone/resources/themes/custom_themes/text_theme.dart';

class AppTheme {
  AppTheme._();
  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      primaryColorDark: Colors.black,
      primaryColor: const Color.fromARGB(255, 232, 141, 14),
      brightness: Brightness.light,
      textTheme: AppTextTheme.lightTextTheme,
      elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
      textButtonTheme: AppTextButtonTheme.lightTextButtonTheme,
      iconTheme: AppIconsTheme.lightIconTheme,
      checkboxTheme: AppCheckboxTheme.lightCheckBoxTheme,
      appBarTheme: AppAppBarTheme.lightAppBarTheme,
      snackBarTheme: AppSnackBarTheme.lightSnackBarTheme,
      dialogTheme: AppAlertDialogueTheme.lightAlertDialogue);

  static ThemeData darkTheme = ThemeData(
      primaryColorDark: Colors.white,
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      primaryColor: const Color.fromARGB(255, 232, 141, 14),
      textTheme: AppTextTheme.darkTextTheme,
      elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
      textButtonTheme: AppTextButtonTheme.darkTextButtonTheme,
      iconTheme: AppIconsTheme.darkIconTheme,
      checkboxTheme: AppCheckboxTheme.darkCheckBoxTheme,
      appBarTheme: AppAppBarTheme.darkAppBarTheme,
      snackBarTheme: AppSnackBarTheme.darkSnackBarTheme,
      dialogTheme: AppAlertDialogueTheme.darkAlertDialogue);
}
