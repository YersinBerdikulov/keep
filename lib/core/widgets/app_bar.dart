import 'package:flutter/material.dart';
import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/core/constants/font_config.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showDrawer;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  const AppBarWidget({
    Key? key,
    required this.title,
    this.showDrawer = true,
    this.automaticallyImplyLeading = false,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: FontConfig.body1().copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: ColorConfig.white,
      elevation: 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: automaticallyImplyLeading
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context),
              color: ColorConfig.midnight,
            )
          : showDrawer
              ? IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  color: ColorConfig.midnight,
                )
              : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 