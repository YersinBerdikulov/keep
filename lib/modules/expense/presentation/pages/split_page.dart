import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../widgets/appbar/appbar.dart';
import '../../../box/domain/controllers/box_controller.dart';
import '../widgets/split_widget.dart';

class SplitPage extends ConsumerWidget {
  final TextEditingController expenseCost;
  const SplitPage({super.key, required this.expenseCost});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsers = ref.read(userInBoxStoreProvider);

    return Scaffold(
      appBar: AppBarWidget(title: "Expense Split"),
      body: Column(
        children: [
          SplitFriendListWidget(allUsers),
          SplitActionButtonWidget(users: allUsers, expenseCost: expenseCost),
        ],
      ),
    );
  }
}
