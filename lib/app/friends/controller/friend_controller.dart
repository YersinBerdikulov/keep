import 'package:dongi/models/user_friend_model.dart';
import 'package:dongi/modules/auth/domain/models/user_model.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../services/friend_service.dart';
part 'friend_controller.freezed.dart';

final friendNotifierProvider =
    StateNotifierProvider<FriendNotifier, FriendState>(
  (ref) {
    return FriendNotifier(
      ref: ref,
      friendAPI: ref.watch(friendAPIProvider),
    );
  },
);

@freezed
class FriendState with _$FriendState {
  const factory FriendState.init() = FriendInitState;
  const factory FriendState.loading() = FriendLoadingState;
  const factory FriendState.loaded() = FriendLoadedState;
  const factory FriendState.error(String message) = FriendErrorState;
}

final getFriendProvider = FutureProvider.autoDispose((ref) {
  final friendController = ref.watch(friendNotifierProvider.notifier);
  return friendController.getFriends();
});

final getFriendDetailProvider =
    FutureProvider.family.autoDispose((ref, String friendId) {
  final friendController = ref.watch(friendNotifierProvider.notifier);
  return friendController.getFriendDetail(friendId);
});

class FriendNotifier extends StateNotifier<FriendState> {
  FriendNotifier({
    required this.ref,
    required this.friendAPI,
  }) : super(const FriendState.init());

  final Ref ref;
  final FriendAPI friendAPI;

  Future<void> addFriend(UserModel userModel) async {
    state = const FriendState.loading();
    final currentUser = ref.read(currentUserProvider);
    final currentUserModel = await ref
        .read(authControllerProvider.notifier)
        .getUserData(currentUser!.id!);

    UserFriendModel friendModel = UserFriendModel(
      sendRequestUserId: currentUserModel.id!,
      sendRequestUserName: currentUserModel.userName,
      sendRequestProfilePic: currentUserModel.profileImage,
      receiveRequestUserId: userModel.id!,
      receiveRequestUserName: userModel.userName,
      receiveRequestProfilePic: userModel.profileImage,
    );

    final res = await friendAPI.addFriend(friendModel);
    state = res.fold(
      (l) => FriendState.error(l.message),
      (r) => const FriendState.loaded(),
    );
  }

  Future<void> acceptFriendRequest(UserFriendModel userFriendModel) async {
    state = const FriendState.loading();
    // final currentUser = ref.read(currentUserProvider);

    try {
      // Update the friend request status to "accepted"
      final updatedFriendModel = userFriendModel.copyWith(
        status: FriendRequestStatus.accepted,
      );

      final res = await friendAPI.updateFriend(updatedFriendModel);

      state = res.fold(
        (l) => FriendState.error(l.message),
        (r) {
          return const FriendState.loaded();
        },
      );
    } catch (e) {
      state = FriendState.error(e.toString());
    }
  }

  Future<void> rejectFriendRequest(UserFriendModel userFriendModel) async {
    state = const FriendState.loading();
    // final currentUser = ref.read(currentUserProvider);

    try {
      // Update the friend request status to "rejected" or delete the request
      final updatedFriendModel = userFriendModel.copyWith(
        status: FriendRequestStatus.rejected,
      );

      final res = await friendAPI.updateFriend(updatedFriendModel);

      state = res.fold(
        (l) => FriendState.error(l.message),
        (r) {
          return const FriendState.loaded();
        },
      );
    } catch (e) {
      state = FriendState.error(e.toString());
    }
  }

  Future<void> deleteFriend(UserFriendModel friendModel) async {
    state = const FriendState.loading();
    //remove friend from server
    final res = await friendAPI.deleteFriend(friendModel.id!);

    state = res.fold(
      (l) => FriendState.error(l.message),
      (r) => const FriendState.loaded(),
    );
  }

  Future<List<UserFriendModel>> getFriends() async {
    final user = ref.read(currentUserProvider);
    final friendList = await friendAPI.getFriends(user!.id!);
    return friendList
        .map((friend) => UserFriendModel.fromJson(friend.data))
        .toList();
  }

  Future<List<UserModel>> searchFriends(String query) async {
    final user = ref.read(currentUserProvider);
    final friendList = await friendAPI.searchFriends(user!.id!, query);
    return friendList.map((friend) => UserModel.fromJson(friend.data)).toList();
  }

  Future<UserFriendModel> getFriendDetail(String friendId) async {
    final user = ref.read(currentUserProvider);
    final friend = await friendAPI.getFriendDetail(user!.id!, friendId);
    return UserFriendModel.fromJson(friend.data);
  }
}
