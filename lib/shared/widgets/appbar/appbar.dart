import '../../../../core/constants/color_config.dart';
import '../../../../core/router/router_names.dart';
import 'package:go_router/go_router.dart';
import '../../../../modules/auth/domain/di/auth_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBarWidget extends PreferredSize {
  final String? title;
  final Widget? drawer;
  AppBarWidget({
    super.key,
    this.title,
    this.drawer,
  }) : super(
          preferredSize: const Size.fromHeight(70),
          child: appBarChild(title, drawer),
        );
}

Widget appBarChild(String? title, Widget? drawer) {
  return Consumer(
    builder: (context, ref, child) {
      // Check if user is authenticated
      final currentUser = ref.watch(currentUserProvider);

      // If not authenticated, return an empty AppBar
      if (currentUser == null) {
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
      }

      // If authenticated, return the full AppBar with actions
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: title != null
            ? Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              )
            : null,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: ColorConfig.midnight),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      );
    },
  );
}
