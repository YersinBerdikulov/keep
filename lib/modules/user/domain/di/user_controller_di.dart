import 'package:dongi/modules/group/domain/controllers/group_controller.dart';
import 'package:dongi/modules/user/data/source/network/user_remote_data_source.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../auth/domain/models/user_model.dart';

final userNotifierProvider = AsyncNotifierProvider<UserController, UserModel>(
  GroupNotifier.new,
);

final getUserData = FutureProvider.family((ref, String uid) {
  final userDetails = ref.watch(userNotifierProvider.notifier);
  return userDetails.getUserData(uid);
});

final getUsersListData = FutureProvider.family((ref, List<String> uid) {
  final userDetails = ref.watch(userNotifierProvider.notifier);
  return userDetails.getUsersListData(uid);
});
