import 'package:flutter/material.dart';
import '../card/card.dart';
import 'list_tile.dart';

class ListTileCard extends StatelessWidget {
  final String titleString;
  final String? subtitleString;
  final String? headerString;
  final Widget? trailing;
  final Widget? leading;
  final VisualDensity? visualDensity;
  final void Function()? onTap;
  final Color? borderColor;
  final Color? backColor;
  final TextStyle? subtitleStyle;
  const ListTileCard({
    super.key,
    required this.titleString,
    this.subtitleString,
    this.headerString,
    this.trailing,
    this.leading,
    this.visualDensity,
    this.onTap,
    this.borderColor,
    this.backColor,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      onTap: onTap,
      backColor: backColor,
      borderColor: borderColor,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: subtitleString != null
          ? ListTileWidget(
              titleString: titleString,
              subtitleString: subtitleString!,
              headerString: headerString,
              trailing: trailing,
              leading: leading,
              visualDensity: visualDensity,
              subtitleStyle: subtitleStyle,
            )
          : ListTileWidget(
              titleString: titleString,
              trailing: trailing,
              headerString: headerString,
              leading: leading,
              visualDensity: visualDensity,
              contentPadding: const EdgeInsets.all(10),
            ),
    );
  }
}
