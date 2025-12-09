import 'package:flutter/material.dart';
import 'package:gmail_clone/resources/colors/colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final systemTheme = MediaQuery.of(context).platformBrightness;
    return CircularProgressIndicator(
      strokeWidth: 2,
      color:
          systemTheme == Brightness.dark
              ? AppColors.liightGrey
              : AppColors.darkgGey,
    );
  }
}
