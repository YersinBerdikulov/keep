import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/group/domain/controllers/group_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/group_model.dart';
import '../../../user/domain/models/user_model.dart';

final groupNotifierProvider =
    AsyncNotifierProvider<GroupNotifier, List<GroupModel>>(
  GroupNotifier.new,
);

// Provider for getting group details
final groupDetailProvider =
    FutureProvider.family<GroupModel, String>((ref, groupId) async {
  // Watch the group notifier to refresh when groups are updated
  ref.watch(groupNotifierProvider);
  return ref.watch(groupNotifierProvider.notifier).getGroupDetail(groupId);
});

// Provider for getting users in a group
final usersInGroupProvider =
    FutureProvider.family<List<UserModel>, List<String>>((ref, userIds) async {
  return ref.watch(groupNotifierProvider.notifier).getUsersInGroup(userIds);
});

// Provider for getting user role in a group
class UserRoleParams {
  final String userId;
  final String groupId;
  
  UserRoleParams(this.userId, this.groupId);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          groupId == other.groupId;
  
  @override
  int get hashCode => userId.hashCode ^ groupId.hashCode;
}

final userRoleInGroupProvider = 
    FutureProvider.family<String, UserRoleParams>((ref, params) async {
  return ref.watch(groupNotifierProvider.notifier).getUserRole(params.userId, params.groupId);
});

// Provider for checking if user can delete an item
class CanDeleteItemParams {
  final String userId;
  final String groupId;
  final String creatorId;
  
  CanDeleteItemParams(this.userId, this.groupId, this.creatorId);
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CanDeleteItemParams &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          groupId == other.groupId &&
          creatorId == other.creatorId;
  
  @override
  int get hashCode => userId.hashCode ^ groupId.hashCode ^ creatorId.hashCode;
}

final canUserDeleteItemProvider = 
    FutureProvider.family<bool, CanDeleteItemParams>((ref, params) async {
  return ref.watch(groupNotifierProvider.notifier).canUserDeleteItem(
    params.userId, 
    params.groupId, 
    params.creatorId
  );
});

// UI helper provider to check if delete button should be visible
final showDeleteButtonProvider = Provider.family<bool, CanDeleteItemParams>((ref, params) {
  // Get the current user
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return false;
  
  // Get the result asynchronously
  final asyncCanDelete = ref.watch(canUserDeleteItemProvider(params));
  
  // Return the result if available, otherwise default to false
  return asyncCanDelete.maybeWhen(
    data: (canDelete) => canDelete,
    orElse: () => false,
  );
});

// UI helper provider to check if user is admin
final isUserAdminProvider = Provider.family<bool, UserRoleParams>((ref, params) {
  // Get the role asynchronously
  final asyncRole = ref.watch(userRoleInGroupProvider(params));
  
  // Return true if role is admin, otherwise false
  return asyncRole.maybeWhen(
    data: (role) => role == "admin",
    orElse: () => false,
  );
});

// Simpler helper that uses the current user automatically
final isCurrentUserAdminProvider = Provider.family<bool, String>((ref, groupId) {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null || currentUser.id == null) return false;
  
  final params = UserRoleParams(currentUser.id!, groupId);
  return ref.watch(isUserAdminProvider(params));
});
