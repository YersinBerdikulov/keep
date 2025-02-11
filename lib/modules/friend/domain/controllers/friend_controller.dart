import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/friend/domain/repository/friend_repository.dart';
import 'package:dongi/modules/user/domain/di/user_usecase_di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FriendNotifier extends AsyncNotifier<List<UserFriendModel>> {
  late final FriendRepository _friendRepository;

  @override
  Future<List<UserFriendModel>> build() async {
    return getFriends();
  }

  Future<void> addFriend(UserModel userModel) async {
    state = const AsyncLoading();
    final currentUser = ref.read(currentUserProvider);
    final currentUserModel =
        await ref.read(getUserDataUseCaseProvider).execute(currentUser!.id!);

    UserFriendModel friendModel = UserFriendModel(
      sendRequestUserId: currentUserModel!.id!,
      sendRequestUserName: currentUserModel.userName,
      sendRequestProfilePic: currentUserModel.profileImage,
      receiveRequestUserId: userModel.id!,
      receiveRequestUserName: userModel.userName,
      receiveRequestProfilePic: userModel.profileImage,
    );

    final res = await _friendRepository.addFriend(friendModel);
    state = res.fold(
      (l) => AsyncError(l.message, StackTrace.current),
      (r) => const AsyncData([]),
    );
  }

  Future<void> acceptFriendRequest(UserFriendModel userFriendModel) async {
    state = const AsyncLoading();
    try {
      final updatedFriendModel = userFriendModel.copyWith(
        status: FriendRequestStatus.accepted,
      );

      final res = await _friendRepository.updateFriend(updatedFriendModel);

      state = res.fold(
        (l) => AsyncError(l.message, StackTrace.current),
        (r) => const AsyncData([]),
      );
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> rejectFriendRequest(UserFriendModel userFriendModel) async {
    state = const AsyncLoading();
    try {
      final updatedFriendModel = userFriendModel.copyWith(
        status: FriendRequestStatus.rejected,
      );

      final res = await _friendRepository.updateFriend(updatedFriendModel);

      state = res.fold(
        (l) => AsyncError(l.message, StackTrace.current),
        (r) => const AsyncData([]),
      );
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<void> deleteFriend(UserFriendModel friendModel) async {
    state = const AsyncLoading();
    final res = await _friendRepository.deleteFriend(friendModel.id!);

    state = res.fold(
      (l) => AsyncError(l.message, StackTrace.current),
      (r) => const AsyncData([]),
    );
  }

  Future<List<UserFriendModel>> getFriends() async {
    final user = ref.read(currentUserProvider);
    final friendList = await _friendRepository.getFriends(user!.id!);
    return friendList
        .map((friend) => UserFriendModel.fromJson(friend.data))
        .toList();
  }

  Future<List<UserModel>> searchFriends(String query) async {
    final user = ref.read(currentUserProvider);
    final friendList = await _friendRepository.searchFriends(user!.id!, query);
    return friendList.map((friend) => UserModel.fromJson(friend.data)).toList();
  }

  Future<UserFriendModel> getFriendDetail(String friendId) async {
    final user = ref.read(currentUserProvider);
    final friend = await _friendRepository.getFriendDetail(user!.id!, friendId);
    return UserFriendModel.fromJson(friend.data);
  }
}
