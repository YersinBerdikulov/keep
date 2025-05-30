import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../shared/widgets/list_tile/list_tile_card.dart';
import '../../../../shared/widgets/image/image_widget.dart';
import '../../../../shared/widgets/loading/loading.dart';
import '../../../../shared/widgets/error/error.dart';
import '../../domain/di/expense_controller_di.dart';

class MadeByFriendListWidget extends ConsumerWidget {
  const MadeByFriendListWidget({super.key});

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConfig.primarySwatch.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline,
                size: 48,
                color: ColorConfig.primarySwatch,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Members Yet',
              style: FontConfig.h6().copyWith(
                color: ColorConfig.midnight,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add members to the box to split expenses',
              textAlign: TextAlign.center,
              style: FontConfig.body2().copyWith(
                color: ColorConfig.primarySwatch50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userInBoxStoreProvider);
    final selectedPayerId = ref.watch(expensePayerIdProvider);

    if (users.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isSelected = selectedPayerId == user.id;

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
          child: ListTileCard(
            leading: Hero(
              tag: 'user_${user.id}',
              child: ImageWidget(
                imageUrl: user.profileImage,
                borderRadius: 25,
                width: 50,
                height: 50,
              ),
            ),
            borderColor:
                isSelected ? ColorConfig.primarySwatch : Colors.transparent,
            titleString: user.userName ?? user.email,
            onTap: () {
              ref.read(expensePayerIdProvider.notifier).state = user.id;
            },
          ),
        );
      },
    );
  }
}
