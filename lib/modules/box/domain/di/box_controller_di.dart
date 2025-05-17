import 'package:dongi/modules/user/domain/models/user_model.dart';
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
  if (usersInBoxArgs.userIds.isEmpty) {
    return <UserModel>[];
  }
  final boxesController =
      ref.read(boxNotifierProvider(usersInBoxArgs.groupId).notifier);
  return boxesController.getUsersInBox(usersInBoxArgs.userIds);
});

final selectedMembersProvider = StateProvider<List<String>>((ref) => []);
final selectedCurrencyProvider = StateProvider<String>((ref) => 'KZT');

final userInBoxStoreProvider = StateProvider<List<UserModel>>((ref) {
  return [];
});
