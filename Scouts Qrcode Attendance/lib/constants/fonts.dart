
import 'package:asdt_app/constants/colors.dart';
import 'package:flutter/material.dart';

class ConstFonts {
  static const TextTheme appTextTheme = TextTheme(
    headline1: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: ConstColors.primaryColor,
    ),
    button: TextStyle(fontSize: 20),
    headline2: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 8
        ),
    subtitle1: TextStyle(
      fontSize: 20,
      // fontWeight: FontWeight.w500,
    ),
    subtitle2: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
    bodyText2: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    caption: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );
}
