import 'package:flutter/material.dart';

class ColorTheme {
  static Color primaryColor = const Color(0XFF0F469A);
  static Color textColor = const Color(0XFF272727);
  static Color lightGrey = const Color(0XFFF0F0F0);
  static Color hintColor = const Color(0xFFA1A1A1);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      primaryColor: ColorTheme.primaryColor,
      colorScheme: ColorScheme.light(primary: ColorTheme.primaryColor),
      textTheme: const TextTheme(
          headlineLarge: TextStyle(
              fontFamily: "Righteous",
              fontSize: 73,
              fontWeight: FontWeight.w400),
          headlineMedium: TextStyle(
              fontFamily: "Righteous",
              fontSize: 45,
              fontWeight: FontWeight.w400),
          headlineSmall: TextStyle(
              fontFamily: "Righteous",
              fontSize: 36,
              fontWeight: FontWeight.w400),
          titleLarge: TextStyle(
              fontFamily: "Roboto", fontSize: 26, fontWeight: FontWeight.w400),
          bodyLarge: TextStyle(
              fontFamily: "Roboto", fontSize: 16, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(
              fontFamily: "Roboto", fontSize: 14, fontWeight: FontWeight.w400),
          bodySmall: TextStyle(
              fontFamily: "Roboto", fontSize: 12, fontWeight: FontWeight.w400),
          labelLarge: TextStyle(
              fontFamily: "Roboto",
              fontSize: 14,
              fontWeight: FontWeight.w500)));
}
