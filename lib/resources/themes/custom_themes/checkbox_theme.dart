import 'package:flutter/material.dart';
import 'package:gmail_clone/resources/colors/colors.dart';

class AppCheckboxTheme {
  AppCheckboxTheme._();

  static CheckboxThemeData lightCheckBoxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.all(AppColors.darkgGey),
    checkColor: WidgetStateProperty.all(AppColors.liightGrey),
    side: BorderSide.none,
  );
  static CheckboxThemeData darkCheckBoxTheme = CheckboxThemeData(
    fillColor: WidgetStateProperty.all(AppColors.liightGrey),
    checkColor: WidgetStateProperty.all(AppColors.darkgGey),
    side: BorderSide.none,
  );
}
