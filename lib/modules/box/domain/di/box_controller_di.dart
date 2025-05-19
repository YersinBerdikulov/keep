import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/box/domain/controllers/box_controller.dart';
import 'package:dongi/modules/box/domain/models/box_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final boxNotifierProvider =
    AsyncNotifierProviderFamily<BoxNotifier, List<BoxModel>, String>(
  BoxNotifier.new, // Leverage the default constructor
);

// Cache to store box details and prevent redundant fetches
final _boxDetailCache = StateProvider<Map<String, BoxModel>>((ref) => {});

final getBoxDetailProvider =
    FutureProvider.family.autoDispose((ref, BoxDetailArgs boxDetailArgs) {
  // Check if we have this box in cache
  final cache = ref.watch(_boxDetailCache);
  final cacheKey = "${boxDetailArgs.boxId}_${boxDetailArgs.groupId}";

  if (cache.containsKey(cacheKey)) {
    return cache[cacheKey]!;
  }

  // If not in cache, fetch it and store in cache
  final boxesController =
      ref.read(boxNotifierProvider(boxDetailArgs.groupId).notifier);

  // Keep provider alive for 5 minutes to prevent constant rebuilds
  ref.keepAlive();

  return boxesController.getBoxDetail(boxDetailArgs.boxId).then((boxDetail) {
    // Store the result in cache
    ref.read(_boxDetailCache.notifier).update((state) => {
          ...state,
          cacheKey: boxDetail,
        });
    return boxDetail;
  });
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
