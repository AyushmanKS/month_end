import 'package:flutter/material.dart';

class AppTypography {
  const AppTypography._();

  static const String fontFamily = 'Roboto';

  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextTheme textThemeFor(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: display.copyWith(color: primary),
      headlineMedium: headline.copyWith(color: primary),
      titleLarge: title.copyWith(color: primary),
      bodyMedium: body.copyWith(color: primary),
      labelLarge: label.copyWith(color: primary),
      bodySmall: caption.copyWith(color: secondary),
    );
  }
}
