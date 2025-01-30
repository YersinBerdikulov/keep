import 'package:dongi/core/constants/color_config.dart';
import 'package:flutter/material.dart';

enum SnackBarType { success, error, info }

void showSnackBar(
  BuildContext context, {
  required String content,
  int seconds = 3,
  SnackBarType type = SnackBarType.info,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  Color backgroundColor;
  switch (type) {
    case SnackBarType.success:
      backgroundColor = ColorConfig.secondary;
      break;
    case SnackBarType.error:
      backgroundColor = ColorConfig.error;
      break;
    case SnackBarType.info:
      backgroundColor = ColorConfig.grey;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      duration: Duration(seconds: seconds),
      backgroundColor: backgroundColor,
      action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onAction,
              textColor: Colors.white,
            )
          : null,
    ),
  );
}
