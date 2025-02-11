import 'dart:async';
import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/user/data/di/user_di.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UserController extends AsyncNotifier<UserModel?> {
  late final UserRepository _userRepository;

  @override
  FutureOr<UserModel?> build() async {
    _userRepository = ref.read(userRepositoryProvider);
    return await _initializeCurrentUser();
  }

  UserModel? get currentUser => state.value;

  Future<UserModel?> _initializeCurrentUser() async {
    try {
      return await _userRepository.getCurrentUserData();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      final user = await _userRepository.getUserDataById(uid);
      return user;
    } catch (e) {
      // state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> saveUser(UserModel userModel) async {
    final result = await _userRepository.saveUserData(userModel);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {
        // Update only if the saved user is current user
        if (currentUser?.id == userModel.id) {
          state = AsyncValue.data(userModel);
        }
      },
    );
  }

  Future<List<UserModel>> getUsersListData(List<String> userIds) async {
    try {
      final users = await _userRepository.getUsersListData(userIds);
      return users;
    } catch (e) {
      // state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    final result = await _userRepository.updateUserData(userModel);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
      },
      (_) {
        // Update only if the update user is current user
        if (currentUser?.id == userModel.id) {
          state = AsyncValue.data(userModel); // Update only if same user
        }
      },
    );
  }
}
