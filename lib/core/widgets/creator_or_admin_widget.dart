import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/group/domain/di/group_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreatorOrAdminWidget extends ConsumerWidget {
  final String groupId;
  final String creatorId;
  final Widget child;

  const CreatorOrAdminWidget({
    Key? key,
    required this.groupId,
    required this.creatorId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null || currentUser.id == null) return const SizedBox.shrink();

    // Check if user is creator
    final isCreator = currentUser.id == creatorId;
    
    // If creator, show directly without async check
    if (isCreator) return child;
    
    // Otherwise check if admin
    final isAdminAsync = ref.watch(
      userRoleInGroupProvider(
        UserRoleParams(currentUser.id!, groupId),
      ),
    );

    return isAdminAsync.when(
      data: (role) {
        if (role == "admin") {
          return child;
        } else {
          return const SizedBox.shrink();
        }
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
} 