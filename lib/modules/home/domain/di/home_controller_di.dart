import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:dongi/modules/home/domain/controllers/home_controller.dart';
import 'package:dongi/modules/user/domain/di/user_usecase_di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../user/domain/models/user_model.dart';

final homeNotifierProvider =
    AsyncNotifierProvider<HomeNotifier, List<GroupModel>>(
  HomeNotifier.new,
);

final groupMembersProvider = FutureProvider.autoDispose
    .family<List<UserModel>, List<String>>((ref, userIds) async {
  final getGroupMembersUseCase = ref.read(getGroupMembersUseCaseProvider);
  return await getGroupMembersUseCase.execute(userIds);
});
