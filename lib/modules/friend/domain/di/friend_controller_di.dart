import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/modules/friend/domain/controllers/friend_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final friendNotifierProvider =
    AsyncNotifierProvider<FriendNotifier, List<UserFriendModel>>(
  FriendNotifier.new,
);

final getFriendProvider = FutureProvider.autoDispose((ref) {
  final friendController = ref.watch(friendNotifierProvider.notifier);
  return friendController.getFriends();
});
