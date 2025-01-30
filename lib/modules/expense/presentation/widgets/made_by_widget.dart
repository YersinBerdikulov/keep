import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../shared/widgets/list_tile/list_tile_card.dart';
import '../../domain/di/expense_controller_di.dart';

class MadeByFriendListWidget extends ConsumerWidget {
  const MadeByFriendListWidget({super.key});

  cardIcon() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          //width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: ColorConfig.primarySwatch,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.read(userInBoxStoreProvider);

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
          child: ListTileCard(
            leading: cardIcon(),
            borderColor: ref.watch(expensePayerIdProvider) == users[index].id
                ? ColorConfig.primarySwatch
                : Colors.transparent,
            titleString: users[index].userName ?? users[index].email,
            onTap: () => ref.read(expensePayerIdProvider.notifier).state =
                users[index].id,
          ),
        );
      },
    );
  }
}
