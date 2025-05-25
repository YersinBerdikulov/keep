import 'package:dongi/core/constants/color_config.dart';
import 'package:flutter/material.dart';

//class CardWidget extends Card {
//  final EdgeInsets? padding;
//  final Color? borderColor;
//  final Color? backColor;
//  final void Function()? onTap;
//  const CardWidget({
//    super.key,
//    super.child,
//    super.margin = EdgeInsets.zero,
//    super.color,
//    this.padding,
//    this.borderColor,
//    this.backColor,
//    this.onTap,
//  });

//  @override
//  Color? get color => backColor ?? ColorConfig.grey;

//  @override
//  double? get elevation => 0;

//  @override
//  ShapeBorder? get shape => ;

//  @override
//  Widget? get child =>
//}

class CardWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? borderColor;
  final Color? backColor;
  final void Function()? onTap;
  final double? elevation;
  final BorderRadius? borderRadius;

  const CardWidget({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.backColor,
    this.onTap,
    this.margin = EdgeInsets.zero,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: backColor ?? ColorConfig.grey,
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: borderColor ?? Colors.transparent,
          ),
          boxShadow: [
            if (elevation != null)
              BoxShadow(
                color: ColorConfig.primarySwatch.withOpacity(0.08),
                blurRadius: elevation!,
                offset: Offset(0, elevation! * 0.5),
              )
            else
              BoxShadow(
                color: ColorConfig.primarySwatch.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}
