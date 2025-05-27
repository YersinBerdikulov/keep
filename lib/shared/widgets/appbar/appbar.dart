import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/shared/widgets/drawer/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBarWidget extends PreferredSize {
  final String? title;
  final bool showBackButton;
  
  AppBarWidget({
    super.key,
    this.title,
    this.showBackButton = false,
  }) : super(
          preferredSize: const Size.fromHeight(70),
          child: appBarChild(title, showBackButton),
        );
}

Widget appBarChild(String? title, bool showBackButton) {
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

      // If authenticated, return the full AppBar with either drawer or back button
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConfig.baseGrey,
              ),
              child: Icon(
                showBackButton ? Icons.arrow_back : Icons.menu,
                color: ColorConfig.midnight,
                size: 20,
              ),
            ),
            onPressed: () => showBackButton 
              ? Navigator.of(context).pop()
              : Scaffold.of(context).openDrawer(),
          ),
        ),
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
      );
    },
  );
}
