import 'package:flutter/material.dart';

class CustomFonts {}

class CustomAppColor {
  static Color lightBackgroundColor = const Color(0xfff2f2f2);
  static Color lightBackgroundColor_Home = Color.fromARGB(255, 246, 245, 248);
  static Color lightParticleColor = const Color(0x44948282);
  static Color lightAccentColor = Colors.blueGrey.shade200;
  static Color lightTextColor = Colors.black54;
  static Color lightSecondaryColor = const Color(0xff040415);

  static Color lightYellow = const Color(0xffff8900);
  static Color primaryColorOrange = const Color(0xffFD5D20);
  static Color primaryRedColor = const Color(0xFFDB3022);

  static Color textColor1 = const Color(0xff353047);
  static Color textColor2 = Color(0xff6F6B7A);
  const CustomAppColor._();

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColorOrange,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(backgroundColor: primaryColorOrange),
    colorScheme: ColorScheme.light(secondary: lightSecondaryColor),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(backgroundColor: lightBackgroundColor),
    ),
  );
}
