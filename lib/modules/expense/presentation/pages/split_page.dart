import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
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
