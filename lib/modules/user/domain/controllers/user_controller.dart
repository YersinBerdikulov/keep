import 'dart:async';
import 'dart:io';
import 'package:dongi/core/data/storage/storage_service.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/user/data/di/user_di.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongi/modules/group/domain/di/group_controller_di.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:dongi/modules/box/domain/di/box_controller_di.dart';

class UserController extends AsyncNotifier<UserModel?> {
  UserRepository get _userRepository => ref.read(userRepositoryProvider);
  StorageService get _storageService => ref.read(storageServiceProvider);

  @override
  FutureOr<UserModel?> build() async {
    // Watch currentUserProvider to rebuild when auth state changes
    ref.watch(currentUserProvider);

    return await _initializeCurrentUser();
  }

  UserModel? get currentUser => state.value;

  Future<UserModel?> _initializeCurrentUser() async {
    final authUser = ref.read(currentUserProvider);
    if (authUser == null) return null;

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
          state = AsyncValue.data(userModel);
        }
      },
    );
  }

  Future<void> updateProfileImage(File imageFile) async {
    try {
      final currentUserData = state.value;
      if (currentUserData == null) throw Exception('No user data found');

      // Upload the image
      final imageUploadRes = await _storageService.uploadImage([imageFile]);

      await imageUploadRes.fold(
        (failure) => throw Exception(failure.message),
        (imageUrls) async {
          if (imageUrls.isEmpty) throw Exception('Failed to upload image');

          // Update user data with new image URL
          final updatedUser = currentUserData.copyWith(
            profileImage: imageUrls[0],
          );

          // Try to get current user document first
          try {
            await _userRepository.getUserDataById(currentUserData.id!);
          } catch (e) {
            // If user document doesn't exist, create it first
            await _userRepository.saveUserData(currentUserData);
          }

          // Update in database
          final result = await _userRepository.updateUserData(updatedUser);

          result.fold(
            (failure) => throw Exception(failure.message),
            (_) {
              // Update state
              state = AsyncValue.data(updatedUser);

              // Invalidate relevant providers to refresh UI
              ref.invalidate(groupNotifierProvider);
              ref.invalidate(homeNotifierProvider);
              ref.invalidate(boxNotifierProvider);
            },
          );
        },
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
