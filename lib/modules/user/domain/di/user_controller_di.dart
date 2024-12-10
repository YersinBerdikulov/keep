import 'package:dongi/modules/user/domain/controllers/user_controller.dart';
import 'package:dongi/modules/user/domain/di/user_usecase_di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../auth/domain/models/user_model.dart';

final userNotifierProvider = AsyncNotifierProvider<UserController, UserModel?>(
  UserController.new,
);

final getUsersListData = FutureProvider.family((ref, List<String> uid) {
  final userDetails = ref.watch(userNotifierProvider.notifier);
  return userDetails.getUsersListData(uid);
});

final getUserDataForExpenseProvider =
    FutureProvider.autoDispose.family<UserModel, String>((ref, userId) async {
  final getUserDataUseCase = ref.read(getUserDataUseCaseProvider);
  return await getUserDataUseCase.execute(userId);
});
