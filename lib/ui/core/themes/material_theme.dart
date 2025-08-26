import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff010102),
      surfaceTint: Color(0xff5f5e61),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1c1c1f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff5f5e5f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe5e1e3),
      onSecondaryContainer: Color(0xff656465),
      tertiary: Color(0xff020101),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1f1b1d),
      onTertiaryContainer: Color(0xff898285),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffdf8f8),
      onSurface: Color(0xff1c1b1c),
      onSurfaceVariant: Color(0xff47464b),
      outline: Color(0xff77767b),
      outlineVariant: Color(0xffc8c5cb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffc8c6c9),
      primaryFixed: Color(0xffe4e1e5),
      onPrimaryFixed: Color(0xff1b1b1e),
      primaryFixedDim: Color(0xffc8c6c9),
      onPrimaryFixedVariant: Color(0xff47464a),
      secondaryFixed: Color(0xffe5e1e3),
      onSecondaryFixed: Color(0xff1c1b1d),
      secondaryFixedDim: Color(0xffc9c6c7),
      onSecondaryFixedVariant: Color(0xff474648),
      tertiaryFixed: Color(0xffe9e0e3),
      onTertiaryFixed: Color(0xff1e1a1c),
      tertiaryFixedDim: Color(0xffcdc4c7),
      onTertiaryFixedVariant: Color(0xff4b4548),
      surfaceDim: Color(0xffddd9d9),
      surfaceBright: Color(0xfffdf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f3f2),
      surfaceContainer: Color(0xfff1eded),
      surfaceContainerHigh: Color(0xffebe7e7),
      surfaceContainerHighest: Color(0xffe5e2e1),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff010102),
      surfaceTint: Color(0xff5f5e61),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1c1c1f),
      onPrimaryContainer: Color(0xffa9a7aa),
      secondary: Color(0xff373637),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff6e6c6e),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff020101),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1f1b1d),
      onTertiaryContainer: Color(0xffada5a8),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffdf8f8),
      onSurface: Color(0xff111111),
      onSurfaceVariant: Color(0xff36363a),
      outline: Color(0xff525256),
      outlineVariant: Color(0xff6d6c71),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffc8c6c9),
      primaryFixed: Color(0xff6e6c70),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff555458),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff6e6c6e),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff555456),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff726b6e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff595356),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc9c6c5),
      surfaceBright: Color(0xfffdf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f3f2),
      surfaceContainer: Color(0xffebe7e7),
      surfaceContainerHigh: Color(0xffe0dcdc),
      surfaceContainerHighest: Color(0xffd4d1d0),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff010102),
      surfaceTint: Color(0xff5f5e61),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff1c1c1f),
      onPrimaryContainer: Color(0xffd3d0d4),
      secondary: Color(0xff2c2c2d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4a494a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff020101),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff1f1b1d),
      onTertiaryContainer: Color(0xffd7cfd1),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffdf8f8),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2c2c30),
      outlineVariant: Color(0xff49494d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff313030),
      inversePrimary: Color(0xffc8c6c9),
      primaryFixed: Color(0xff49494c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff333235),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4a494a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff333234),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4d484a),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff363133),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbbb8b8),
      surfaceBright: Color(0xfffdf8f8),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff4f0ef),
      surfaceContainer: Color(0xffe5e2e1),
      surfaceContainerHigh: Color(0xffd7d3d3),
      surfaceContainerHighest: Color(0xffc9c6c5),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffc8c6c9),
      surfaceTint: Color(0xffc8c6c9),
      onPrimary: Color(0xff303033),
      primaryContainer: Color(0xff1c1c1f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xffc9c6c7),
      onSecondary: Color(0xff313031),
      secondaryContainer: Color(0xff474648),
      onSecondaryContainer: Color(0xffb7b4b6),
      tertiary: Color(0xffcdc4c7),
      onTertiary: Color(0xff342f31),
      tertiaryContainer: Color(0xff1f1b1d),
      onTertiaryContainer: Color(0xff898285),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff141313),
      onSurface: Color(0xffe5e2e1),
      onSurfaceVariant: Color(0xffc8c5cb),
      outline: Color(0xff919095),
      outlineVariant: Color(0xff47464b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff5f5e61),
      primaryFixed: Color(0xffe4e1e5),
      onPrimaryFixed: Color(0xff1b1b1e),
      primaryFixedDim: Color(0xffc8c6c9),
      onPrimaryFixedVariant: Color(0xff47464a),
      secondaryFixed: Color(0xffe5e1e3),
      onSecondaryFixed: Color(0xff1c1b1d),
      secondaryFixedDim: Color(0xffc9c6c7),
      onSecondaryFixedVariant: Color(0xff474648),
      tertiaryFixed: Color(0xffe9e0e3),
      onTertiaryFixed: Color(0xff1e1a1c),
      tertiaryFixedDim: Color(0xffcdc4c7),
      onTertiaryFixedVariant: Color(0xff4b4548),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff3a3939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1c1b1c),
      surfaceContainer: Color(0xff201f20),
      surfaceContainerHigh: Color(0xff2b2a2a),
      surfaceContainerHighest: Color(0xff353435),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffdedbdf),
      surfaceTint: Color(0xffc8c6c9),
      onPrimary: Color(0xff252528),
      primaryContainer: Color(0xff929094),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffdfdbdd),
      onSecondary: Color(0xff262527),
      secondaryContainer: Color(0xff929091),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffe3dadd),
      onTertiary: Color(0xff292427),
      tertiaryContainer: Color(0xff968f91),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff141313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdedbe0),
      outline: Color(0xffb3b1b6),
      outlineVariant: Color(0xff918f94),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff48474b),
      primaryFixed: Color(0xffe4e1e5),
      onPrimaryFixed: Color(0xff111114),
      primaryFixedDim: Color(0xffc8c6c9),
      onPrimaryFixedVariant: Color(0xff363639),
      secondaryFixed: Color(0xffe5e1e3),
      onSecondaryFixed: Color(0xff111112),
      secondaryFixedDim: Color(0xffc9c6c7),
      onSecondaryFixedVariant: Color(0xff373637),
      tertiaryFixed: Color(0xffe9e0e3),
      onTertiaryFixed: Color(0xff141012),
      tertiaryFixedDim: Color(0xffcdc4c7),
      onTertiaryFixedVariant: Color(0xff3a3537),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff454444),
      surfaceContainerLowest: Color(0xff070707),
      surfaceContainerLow: Color(0xff1e1d1e),
      surfaceContainer: Color(0xff282828),
      surfaceContainerHigh: Color(0xff333232),
      surfaceContainerHighest: Color(0xff3e3d3d),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff2eff3),
      surfaceTint: Color(0xffc8c6c9),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffc4c2c6),
      onPrimaryContainer: Color(0xff0b0b0e),
      secondary: Color(0xfff3eff0),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffc5c2c3),
      onSecondaryContainer: Color(0xff0b0b0c),
      tertiary: Color(0xfff7eef0),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffc9c0c3),
      onTertiaryContainer: Color(0xff0e0a0c),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff141313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff2eff4),
      outlineVariant: Color(0xffc4c2c7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe5e2e1),
      inversePrimary: Color(0xff48474b),
      primaryFixed: Color(0xffe4e1e5),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffc8c6c9),
      onPrimaryFixedVariant: Color(0xff111114),
      secondaryFixed: Color(0xffe5e1e3),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffc9c6c7),
      onSecondaryFixedVariant: Color(0xff111112),
      tertiaryFixed: Color(0xffe9e0e3),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffcdc4c7),
      onTertiaryFixedVariant: Color(0xff141012),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff515050),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff201f20),
      surfaceContainer: Color(0xff313030),
      surfaceContainerHigh: Color(0xff3c3b3b),
      surfaceContainerHighest: Color(0xff484646),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
