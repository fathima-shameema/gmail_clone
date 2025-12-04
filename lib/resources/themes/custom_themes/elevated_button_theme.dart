import 'package:flutter/material.dart';
import 'package:gmail_clone/resources/colors/colors.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.textBlack,
      backgroundColor: AppColors.transparent,
      disabledBackgroundColor: AppColors.headingTexts,
      disabledForegroundColor: AppColors.headingTexts,
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.textBlack),
      ),
      textStyle: const TextStyle(
        fontSize: 15,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.textWhite,
      backgroundColor: AppColors.transparent,
      disabledBackgroundColor: AppColors.headingTexts,
      disabledForegroundColor: AppColors.headingTexts,
      padding: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.textWhite),
      ),
      textStyle: const TextStyle(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
