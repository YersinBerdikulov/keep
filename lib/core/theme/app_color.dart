import 'package:flutter/material.dart';

class AppColor {
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color gray = Color(0xFF808080);
  static const Color black = Color(0xFF000000);

  // Typography
  static const Color title = black;
  static const Color body = gray;
  static const Color textButton = black;
  static const Color label = black;

  // TextField (Primary)
  static const Color textFieldLabel = black;
  static const Color textFieldInput = black;
  static const Color textFieldPlaceholder = gray;

  // Primary Button
  static const Color primaryButtonBase = black;
  static const Color primaryButtonText = white;
  static Color primaryButtonDisabled =
      const Color(0xFFFFFFFF).withAlpha((0.32 * 255).toInt());

  // Secondary Button
  static const Color secondaryButtonBase = lightGray;
  static const Color secondaryButtonText = black;
  static const Color secondaryButtonDisabled = gray;
}
