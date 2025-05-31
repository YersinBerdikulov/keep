import 'package:flutter/material.dart';
import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/core/constants/font_config.dart';

void showSnackBar(BuildContext context, {
  required String content,
  bool isError = false,
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: FontConfig.body2().copyWith(
          color: Colors.white,
        ),
      ),
      backgroundColor: isError ? ColorConfig.error : ColorConfig.secondary,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
    ),
  );
} 