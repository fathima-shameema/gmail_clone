
import 'package:flutter/material.dart';
import 'package:gmail_clone/resources/colors/colors.dart';
import 'package:gmail_clone/resources/themes/custom_themes/icons_theme.dart';

class AppAppBarTheme {
  AppAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.transparent,
    toolbarHeight: 80,
    titleSpacing: 2,
    iconTheme: AppIconsTheme.lightIconTheme,
  );
  static AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: AppColors.transparent,
    toolbarHeight: 80,
    titleSpacing: 2,
    iconTheme: AppIconsTheme.darkIconTheme,
  );
}
