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

final _usersInBoxCache =
    StateProvider<Map<String, List<UserModel>>>((ref) => {});

final getUsersInBoxProvider = FutureProvider.family
    .autoDispose<List<UserModel>, UsersInBoxArgs>((ref, usersInBoxArgs) async {
  if (usersInBoxArgs.userIds.isEmpty) {
    return <UserModel>[];
  }

  // Create a cache key from the userIds and groupId
  final cacheKey =
      "${usersInBoxArgs.groupId}_${usersInBoxArgs.userIds.join('_')}";

  // Check cache first
  final cache = ref.watch(_usersInBoxCache);
  if (cache.containsKey(cacheKey)) {
    return cache[cacheKey]!;
  }

  // Keep provider alive for 5 minutes to prevent constant rebuilds
  ref.keepAlive();

  // Get users directly from controller
  final boxesController =
      ref.read(boxNotifierProvider(usersInBoxArgs.groupId).notifier);
  final users = await boxesController.getUsersInBox(usersInBoxArgs.userIds);

  // Store in cache
  ref.read(_usersInBoxCache.notifier).update((state) => {
        ...state,
        cacheKey: users,
      });

  return users;
});

final selectedMembersProvider = StateProvider<List<String>>((ref) => []);
final selectedCurrencyProvider = StateProvider<String>((ref) => 'KZT');

final userInBoxStoreProvider = StateProvider<List<UserModel>>((ref) {
  return [];
});
