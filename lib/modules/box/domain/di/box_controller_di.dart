import 'package:dongi/modules/auth/domain/models/user_model.dart';
import 'package:dongi/modules/box/domain/controllers/box_controller.dart';
import 'package:dongi/modules/box/domain/models/box_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final boxNotifierProvider =
    AsyncNotifierProviderFamily<BoxNotifier, List<BoxModel>, String>(
  BoxNotifier.new, // Leverage the default constructor
);

final getBoxDetailProvider =
    FutureProvider.family.autoDispose((ref, BoxDetailArgs boxDetailArgs) {
  final boxesController =
      ref.read(boxNotifierProvider(boxDetailArgs.groupId).notifier);
  return boxesController.getBoxDetail(boxDetailArgs.boxId);
});

final getUsersInBoxProvider = FutureProvider.family
    .autoDispose((ref, UsersInBoxArgs usersInBoxArgs) async {
  //TODO: Think about it, not the best way
  final boxesController =
      ref.read(boxNotifierProvider(usersInBoxArgs.groupId).notifier);
  final usersInBox =
      await boxesController.getUsersInBox(usersInBoxArgs.userIds);
  ref.read(userInBoxStoreProvider.notifier).state = usersInBox;
  return usersInBox;
});

final userInBoxStoreProvider = StateProvider<List<UserModel>>((ref) {
  return [];
});
