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
