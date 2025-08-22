import 'package:ayron_crm/ui/core/themes/material_theme.dart';
import 'package:flutter/material.dart';

// Used https://material-foundation.github.io/material-theme-builder/
// to generate color scheme

abstract final class AppTheme {
  static TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontFamily: 'Lemon Milk'),
    displayMedium: TextStyle(fontFamily: 'Lemon Milk'),
    displaySmall: TextStyle(fontFamily: 'Lemon Milk'),
    headlineLarge: TextStyle(fontFamily: 'Lemon Milk'),
    headlineMedium: TextStyle(fontFamily: 'Lemon Milk'),
    headlineSmall: TextStyle(fontFamily: 'Lemon Milk'),
  );

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Play',
    colorScheme: MaterialTheme.lightScheme(),
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      alignLabelWithHint: true,
    ),
  );
  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Play',
    colorScheme: MaterialTheme.darkScheme(),
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(),
      alignLabelWithHint: true,
    ),
  );
}
