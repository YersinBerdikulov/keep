import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/group/domain/di/group_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Wrapper widget that only shows its child if the current user can delete the item
class DeleteButtonWrapper extends ConsumerWidget {
  final String groupId;
  final String creatorId;
  final Widget child;

  const DeleteButtonWrapper({
    Key? key,
    required this.groupId,
    required this.creatorId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null || currentUser.id == null) return const SizedBox.shrink();

    final canDeleteAsync = ref.watch(
      canUserDeleteItemProvider(
        CanDeleteItemParams(currentUser.id!, groupId, creatorId),
      ),
    );

    return canDeleteAsync.when(
      data: (canDelete) {
        if (canDelete) {
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

/// Wrapper widget that only shows its child if the current user is an admin
class AdminOnlyWidget extends ConsumerWidget {
  final String groupId;
  final Widget child;

  const AdminOnlyWidget({
    Key? key,
    required this.groupId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null || currentUser.id == null) return const SizedBox.shrink();

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

/// Wrapper widget that only shows its child if the current user is the creator or an admin
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