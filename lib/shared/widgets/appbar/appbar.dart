import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBarWidget extends PreferredSize {
  final String? title;
  AppBarWidget({
    super.key,
    this.title,
  }) : super(
          preferredSize: const Size.fromHeight(70),
          child: appBarChild(title),
        );
}

Widget appBarChild(String? title) {
  return Consumer(
    builder: (context, ref, child) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: title != null ? Text(title) : null,
        // actions: [
        //   IconButton(
        //       icon: Container(
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: ColorConfig.baseGrey,
        //         ),
        //       ),
        //       onPressed: () {
        //         // context.push(RouteName.friendList);
        //         ref
        //             .read(authControllerProvider.notifier)
        //             .logout(context);
        //       })
        // ],
      );
    },
  );
}
