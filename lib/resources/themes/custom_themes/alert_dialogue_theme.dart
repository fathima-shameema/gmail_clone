import 'package:flutter/material.dart';
import 'package:gmail_clone/resources/colors/colors.dart';

class AppAlertDialogueTheme {
  AppAlertDialogueTheme._();
  static DialogThemeData lightAlertDialogue = DialogThemeData(
    backgroundColor: AppColors.liightGrey,
    titleTextStyle: TextStyle(
      color: AppColors.textBlack,
      fontSize: 23,
      fontWeight: FontWeight.w400,
    ),
    contentTextStyle: TextStyle(
      color: AppColors.textBlack,
      fontSize: 15,
    ),
  );
  static DialogThemeData darkAlertDialogue = DialogThemeData(
    backgroundColor: AppColors.darkgGey,
    titleTextStyle: TextStyle(
      color: AppColors.textWhite,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
    contentTextStyle: TextStyle(
      color: AppColors.textWhite,
      fontSize: 15,
    ),
  );
}
