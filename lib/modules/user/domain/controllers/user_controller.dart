import 'dart:async';
import 'package:dongi/modules/auth/domain/models/user_model.dart';
import 'package:dongi/modules/user/data/di/user_di.dart';
// ignore: unused_import
import 'package:dongi/modules/user/data/source/repository/user_repository_impl.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserController extends AsyncNotifier<UserModel?> {
  late final UserRepository _userRepository;

  @override
  FutureOr<UserModel?> build() async {
    // Initialize the repository
    _userRepository = ref.read(userRepositoryProvider);

    // No user is initially loaded
    return null;
  }

  Future<void> saveUser(UserModel userModel, String authUid) async {
    state = const AsyncValue.loading();
    final result = await _userRepository.saveUserData(userModel, authUid);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {
        // Optionally update the state
        state = AsyncValue.data(userModel);
      },
    );
  }

  Future<void> fetchUser(String uid) async {
    state = const AsyncValue.loading();
    try {
      final user = await _userRepository.getUserData(uid);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchUsersList(List<String> userIds) async {
    state = const AsyncValue.loading();
    try {
      final users = await _userRepository.getUsersListData(userIds);
      // You can manage how this state reflects if needed
      // For example, keep only the current state user, or handle as a list
      state = AsyncValue.data(state.value);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    state = const AsyncValue.loading();
    final result = await _userRepository.updateUserData(userModel);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {
        // Update the state with the updated user model
        state = AsyncValue.data(userModel);
      },
    );
  }
}
