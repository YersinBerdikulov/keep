import 'package:flutter/material.dart';

class AppTypography {
  static const String _fontFamilyBrand = "Brand";
  static const String _fontFamilyPlain = "Plain";

  // Display Styles
  static TextStyle displayLarge = const TextStyle(
    fontFamily: _fontFamilyBrand,
    fontWeight: FontWeight.w400,
    fontSize: 57,
    height: 64 / 57,
    letterSpacing: -0.25,
  );

  static TextStyle displayMedium = const TextStyle(
    fontFamily: _fontFamilyBrand,
    fontWeight: FontWeight.w400,
    fontSize: 45,
    height: 52 / 45,
  );

  static TextStyle displaySmall = const TextStyle(
    fontFamily: _fontFamilyBrand,
    fontWeight: FontWeight.w400,
    fontSize: 36,
    height: 44 / 36,
  );

  // Headline Styles
  static TextStyle headlineLarge = const TextStyle(
    fontFamily: _fontFamilyBrand,
    fontWeight: FontWeight.w400,
    fontSize: 32,
    height: 40 / 32,
  );

  static TextStyle headlineMedium = const TextStyle(
    fontFamily: _fontFamilyBrand,
    fontWeight: FontWeight.w400,
    fontSize: 28,
    height: 36 / 28,
  );

  static TextStyle headlineSmall = const TextStyle(
    fontFamily: _fontFamilyBrand,
    fontWeight: FontWeight.w400,
    fontSize: 24,
    height: 32 / 24,
  );

  // Title Styles
  static TextStyle titleLarge = const TextStyle(
    fontFamily: _fontFamilyBrand,
    fontWeight: FontWeight.w500,
    fontSize: 22,
    height: 28 / 22,
  );

  static TextStyle titleMedium = const TextStyle(
    fontFamily: _fontFamilyPlain,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.15,
  );

  static TextStyle titleSmall = const TextStyle(
    fontFamily: _fontFamilyPlain,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

  // Label Styles
  static TextStyle labelLarge = const TextStyle(
    fontFamily: _fontFamilyPlain,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

  static TextStyle labelMedium = const TextStyle(
    fontFamily: _fontFamilyPlain,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall = const TextStyle(
    fontFamily: _fontFamilyPlain,
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: 16 / 11,
    letterSpacing: 0.5,
  );

  // Body Styles
  static TextStyle bodyLarge = const TextStyle(
    fontFamily: _fontFamilyPlain,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.5,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontFamily: _fontFamilyPlain,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.25,
  );

  static TextStyle bodySmall = const TextStyle(
    fontFamily: _fontFamilyPlain,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.4,
  );
}
