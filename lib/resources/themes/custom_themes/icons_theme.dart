import 'package:flutter/material.dart';
import 'package:gmail_clone/resources/colors/colors.dart';

class AppIconsTheme {
  AppIconsTheme._();

  static IconThemeData lightIconTheme = IconThemeData(
    size: 15,
    color: AppColors.textBlack,
  );
  static IconThemeData darkIconTheme = IconThemeData(
    size: 15,
    color: AppColors.textWhite,
  );
}
