import 'package:flutter/material.dart';
import '../../../core/constants/font_config.dart';

class ListTileWidget extends ListTile {
  final String titleString;
  final String? subtitleString;
  final String? headerString;
  final TextStyle? titleStringStyle;
  final TextStyle? headerStringStyle;
  final TextStyle? subtitleStyle;
  const ListTileWidget({
    super.key,
    super.trailing,
    super.leading,
    super.contentPadding,
    super.visualDensity,
    required this.titleString,
    this.subtitleString,
    this.headerString,
    this.headerStringStyle,
    this.titleStringStyle,
    this.subtitleStyle,
  });

  @override
  double? get horizontalTitleGap => 10;

  @override
  Widget? get title => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerString != null
              ? Column(
                  children: [
                    Text(
                      headerString!,
                      style: headerStringStyle ?? FontConfig.overline(),
                    ),
                    const SizedBox(height: 5),
                  ],
                )
              : const SizedBox(),
          Text(titleString, style: titleStringStyle ?? FontConfig.body2()),
        ],
      );

  @override
  Widget? get subtitle => subtitleString != null 
    ? Text(
        subtitleString!,
        style: subtitleStyle,
      ) 
    : null;
}
