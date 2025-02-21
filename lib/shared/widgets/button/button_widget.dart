import 'package:dongi/core/constants/color_config.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/font_config.dart';

@immutable
class ButtonWidget extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final String? title;
  final bool? isLoading;
  final VoidCallback? onPressed;
  final Widget? icon;

  const ButtonWidget({
    super.key,
    required this.onPressed,
    this.title,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: BorderSide(color: borderColor ?? Colors.transparent),
        ),
        elevation: 0,
      ),
      child: SizedBox(
        height: 50,
        child: Center(
          child: isLoading ?? false
              ? SizedBox(
                  width: 25,
                  height: 25,
                  child:
                      CircularProgressIndicator(color: ColorConfig.secondary),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      const SizedBox(width: 10),
                    ],
                    Text(
                      title ?? "",
                      style: FontConfig.button()
                          .copyWith(color: textColor ?? Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
