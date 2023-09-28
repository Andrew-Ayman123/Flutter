import 'package:flutter/material.dart';

class ConstColors {
  static const Color primaryColor = Color.fromRGBO(172, 107, 255, 1);
  static const Color secondaryColor = Color.fromRGBO(254, 200, 0, 1);
  static const Color thirdColor = Color.fromRGBO(172, 240, 255, 1);
  static const Color disabledPrimaryColor = Color.fromRGBO(172, 107, 255, 0.3);
  static const Color disabledSecondaryColor = Color.fromRGBO(254, 200, 0, 0.3);
  static const Color disabledThirdColor = Color.fromRGBO(172, 240, 255, 0.3);
  static const Color successColor = Color.fromRGBO(30, 193, 115, 1);
  static const Color errorColor = Color.fromRGBO(221, 49, 49, 1);
  static const Color disabledColor = Color.fromRGBO(156, 163, 175, 1);
  static const Color darkGreyColor = Color.fromRGBO(107, 114, 128, 1);
  static const Color lightGreyColor = Color.fromRGBO(238, 238, 238, 1);
  static const Color backgroundColor = Colors.white;
  static const Color darkColor = Colors.black;
  static final MaterialColor primarySwatch = MaterialColor(
    primaryColor.value,
    <int, Color>{
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor,
    },
  );
  static const List<Color> activeColors = [
    ConstColors.primaryColor,
    ConstColors.secondaryColor,
    ConstColors.thirdColor
  ];
  static const List<Color> disabledColors = [
    ConstColors.disabledPrimaryColor,
    ConstColors.disabledSecondaryColor,
    ConstColors.disabledThirdColor,
  ];
}
