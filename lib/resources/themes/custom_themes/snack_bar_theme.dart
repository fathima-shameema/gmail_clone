import 'package:flutter/material.dart';
import 'package:gmail_clone/resources/colors/colors.dart';
import 'package:gmail_clone/resources/themes/custom_themes/text_theme.dart';

class AppSnackBarTheme {
  AppSnackBarTheme._();

  static SnackBarThemeData lightSnackBarTheme = SnackBarThemeData(
    backgroundColor: AppColors.liightGrey,
    elevation: 3,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    contentTextStyle: AppTextTheme.lightTextTheme.bodyMedium,
    insetPadding: const EdgeInsets.symmetric(horizontal: 5),
  );
  static SnackBarThemeData darkSnackBarTheme = SnackBarThemeData(
    backgroundColor: AppColors.darkgGey,
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    contentTextStyle: AppTextTheme.darkTextTheme.bodyMedium,
    behavior: SnackBarBehavior.floating,
    insetPadding: const EdgeInsets.symmetric(horizontal: 5),
  );
}
