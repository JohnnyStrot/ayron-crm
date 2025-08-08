import 'package:flutter/material.dart';

abstract final class AppTheme {
  static TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontFamily: 'Lemon Milk'),
    displayMedium: TextStyle(fontFamily: 'Lemon Milk'),
    displaySmall: TextStyle(fontFamily: 'Lemon Milk'),
    headlineLarge: TextStyle(fontFamily: 'Lemon Milk'),
    headlineMedium: TextStyle(fontFamily: 'Lemon Milk'),
    headlineSmall: TextStyle(fontFamily: 'Lemon Milk'),
  );

  static ColorScheme lightColorScheme = ColorScheme.light(
    primary: Color(0xff1c1c1f),
  );
  static ColorScheme darkColorScheme = ColorScheme.dark();

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Play',
    colorScheme: lightColorScheme,
    textTheme: textTheme,
  );
  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Play',
    colorScheme: darkColorScheme,
    textTheme: textTheme,
  );
}
