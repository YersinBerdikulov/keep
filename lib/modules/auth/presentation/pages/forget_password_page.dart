import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../widgets/forget_password_widget.dart';

class ForgetPasswordPage extends ConsumerWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColorConfig.background,
      body: Column(
        children: [
          Expanded(child: Container()),
          Container(
            padding: const EdgeInsets.fromLTRB(50, 30, 50, 50),
            decoration: BoxDecoration(
              color: ColorConfig.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ForgetPasswordTitle(),
                ForgetPasswordForm(),
                ForgetPasswordActionButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
