import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../../../shared/widgets/button/button_widget.dart';
import '../widgets/made_by_widget.dart';

class MadeByPage extends ConsumerWidget {
  const MadeByPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBarWidget(title: "Expense made by"),
      body: Column(
        children: [
          const Expanded(child: MadeByFriendListWidget()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ButtonWidget(
                onPressed: () => context.pop(),
                title: "Confirm",
                textColor: ColorConfig.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
