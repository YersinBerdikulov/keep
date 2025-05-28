import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/friend/domain/repository/friend_repository.dart';
import 'package:dongi/modules/user/domain/di/user_usecase_di.dart';
import 'package:dongi/modules/friend/data/di/friend_di.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FriendNotifier extends AsyncNotifier<List<UserFriendModel>> {
  FriendRepository get _friendRepository => ref.read(friendRepositoryProvider);

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
      // 1. Update the friend request status to accepted
      final updatedFriendModel = userFriendModel.copyWith(
        status: FriendRequestStatus.accepted,
      );

      final res = await _friendRepository.updateFriend(updatedFriendModel);

      await res.fold(
        (l) => throw Exception(l.message),
        (r) async {
          // 2. Get both users' data
          final senderUser = await ref
              .read(getUserDataUseCaseProvider)
              .execute(userFriendModel.sendRequestUserId);
          final receiverUser = await ref
              .read(getUserDataUseCaseProvider)
              .execute(userFriendModel.receiveRequestUserId);

          if (senderUser == null || receiverUser == null) {
            throw Exception('Failed to fetch user data');
          }

          // 3. Update sender's userFriends array if not already added
          if (!senderUser.userFriends.contains(receiverUser.id)) {
            final updatedSenderUser = senderUser.copyWith(
              userFriends: [...senderUser.userFriends, receiverUser.id!],
            );
            await ref.read(userNotifierProvider.notifier).updateUser(updatedSenderUser);
          }

          // 4. Update receiver's userFriends array if not already added
          if (!receiverUser.userFriends.contains(senderUser.id)) {
            final updatedReceiverUser = receiverUser.copyWith(
              userFriends: [...receiverUser.userFriends, senderUser.id!],
            );
            await ref.read(userNotifierProvider.notifier).updateUser(updatedReceiverUser);
          }
        },
      );

      state = const AsyncData([]);
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
    try {
      // 1. Delete the friend relationship
      final res = await _friendRepository.deleteFriend(friendModel.id!);

      await res.fold(
        (l) => throw Exception(l.message),
        (r) async {
          // 2. Get both users' data
          final senderUser = await ref
              .read(getUserDataUseCaseProvider)
              .execute(friendModel.sendRequestUserId);
          final receiverUser = await ref
              .read(getUserDataUseCaseProvider)
              .execute(friendModel.receiveRequestUserId);

          if (senderUser == null || receiverUser == null) {
            throw Exception('Failed to fetch user data');
          }

          // 3. Remove from sender's userFriends array
          if (senderUser.userFriends.contains(receiverUser.id)) {
            final updatedSenderUser = senderUser.copyWith(
              userFriends: senderUser.userFriends.where((id) => id != receiverUser.id).toList(),
            );
            await ref.read(userNotifierProvider.notifier).updateUser(updatedSenderUser);
          }

          // 4. Remove from receiver's userFriends array
          if (receiverUser.userFriends.contains(senderUser.id)) {
            final updatedReceiverUser = receiverUser.copyWith(
              userFriends: receiverUser.userFriends.where((id) => id != senderUser.id).toList(),
            );
            await ref.read(userNotifierProvider.notifier).updateUser(updatedReceiverUser);
          }
        },
      );

      state = const AsyncData([]);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }

  Future<List<UserFriendModel>> getFriends() async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null || user.id == null) {
        throw Exception('User not found');
      }

      final friendList = await _friendRepository.getFriends(user.id!);
      final List<UserFriendModel> friends = [];

      // Get current user's data to ensure userFriends array is up to date
      final currentUserData = await ref.read(getUserDataUseCaseProvider).execute(user.id!);
      if (currentUserData == null) {
        throw Exception('Current user data not found');
      }

      for (var friend in friendList) {
        final friendData = friend.data;
        var friendModel = UserFriendModel.fromJson(friendData);

        // Only process accepted friend requests
        if (friendModel.status == FriendRequestStatus.accepted) {
          // If sender username is missing, fetch it
          if (friendModel.sendRequestUserName == null) {
            final senderUser = await ref
                .read(getUserDataUseCaseProvider)
                .execute(friendModel.sendRequestUserId);
            if (senderUser != null) {
              friendModel = friendModel.copyWith(
                sendRequestUserName: senderUser.userName,
                sendRequestProfilePic: senderUser.profileImage,
              );
            }
          }

          // If receiver username is missing, fetch it
          if (friendModel.receiveRequestUserName == null) {
            final receiverUser = await ref
                .read(getUserDataUseCaseProvider)
                .execute(friendModel.receiveRequestUserId);
            if (receiverUser != null) {
              friendModel = friendModel.copyWith(
                receiveRequestUserName: receiverUser.userName,
                receiveRequestProfilePic: receiverUser.profileImage,
              );
            }
          }

          // Update current user's userFriends array if needed
          String friendId = friendModel.sendRequestUserId == user.id!
              ? friendModel.receiveRequestUserId
              : friendModel.sendRequestUserId;

          if (!currentUserData.userFriends.contains(friendId)) {
            final updatedUserData = currentUserData.copyWith(
              userFriends: [...currentUserData.userFriends, friendId],
            );
            await ref.read(userNotifierProvider.notifier).updateUser(updatedUserData);
          }

          friends.add(friendModel);
        }
      }

      return friends;
    } catch (e) {
      throw Exception('Failed to load friends: ${e.toString()}');
    }
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
