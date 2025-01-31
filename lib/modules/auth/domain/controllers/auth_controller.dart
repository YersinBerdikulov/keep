import 'dart:async';

import 'package:dongi/modules/auth/data/di/auth_di.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/auth/domain/repository/auth_repository.dart';
import 'package:dongi/modules/auth/domain/models/user_model.dart';
import 'package:dongi/modules/user/data/di/user_di.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthController extends AsyncNotifier<UserModel?> {
  late final AuthRepository authRepository;
  late final UserRepository userRepository;

  @override
  FutureOr<UserModel?> build() async {
    // Initialize dependencies
    authRepository = ref.read(authRepositoryProvider);
    userRepository = ref.read(userRepositoryProvider);

    // Return the current user if logged in
    return await currentUser();
  }

  Future<UserModel?> currentUser() async {
    final user = await authRepository.currentUserAccount();
    if (user == null) return null;

    return user.toUserModel();
  }

  /// Handles Sign-Up Logic
  Future<void> signUp({
    required String email,
    required String userName,
    required String password,
  }) async {
    // Set state to loading
    state = const AsyncValue.loading();

    // Perform sign-up operation
    final res = await authRepository.signUp(email: email, password: password);

    // Update state based on the result
    state = await res.fold(
      (l) => AsyncValue.error(l.message, l.stackTrace),
      (r) async {
        // Create UserModel
        UserModel userModel = UserModel(
          email: email,
          userName: userName,
        );

        // Save user data to backend
        final res2 = await userRepository.saveUserData(userModel, r.$id);

        // Handle result of saveUserData
        return await res2.fold(
          (l) => AsyncValue.error(l.message, l.stackTrace),
          (r) async {
            // Automatically sign in the user to create a session
            final signInRes = await authRepository.signIn(
              email: email,
              password: password,
            );

            // Handle sign-in result
            return signInRes.fold(
              (l) => AsyncValue.error(l.message, l.stackTrace),
              (r) {
                // Save user data to currentUserProvider
                ref.read(currentUserProvider.notifier).state = r.toUserModel();
                return const AsyncValue.data(null);
              },
            );
          },
        );
      },
    );
  }

  /// Handles Email/Password Sign-In
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    // Set state to loading
    state = const AsyncValue.loading();

    // Perform the sign-in operation
    final res = await authRepository.signIn(email: email, password: password);

    // Update state based on the result
    state = res.fold(
      (l) => AsyncValue.error(l.message, l.stackTrace),
      (r) {
        // Save User data to provider
        ref.read(currentUserProvider.notifier).state = r.toUserModel();
        return const AsyncValue.data(null);
      },
    );
  }

  /// Handles Google Sign-In
  Future<void> signInWithGoogle() async {
    // Set state to loading
    state = const AsyncValue.loading();

    // Perform the Google sign-in operation
    final res = await authRepository.signInWithGoogle();

    // Update state based on the result
    state = await res.fold(
      (l) => AsyncValue.error(l.message, l.stackTrace),
      (r) async {
        UserModel userModel = UserModel(
          email: r.email,
          userName: r.name,
        );

        // Save User data to provider
        ref.read(currentUserProvider.notifier).state = r.toUserModel();

        // Save/Update user data in backend
        final res2 = await userRepository.saveUserData(userModel, r.$id);
        return res2.fold(
          (l) => AsyncValue.error(l.message, l.stackTrace),
          (r) => const AsyncValue.data(null),
        );
      },
    );
  }

  /// Sends OTP for email verification and returns userId
  Future<String?> sendOTP({required String email}) async {
    // Set state to loading
    state = const AsyncValue.loading();

    final res = await authRepository.sendOTP(email: email);

    // Update state based on the result and return userId if successful
    return res.fold(
      (l) {
        state = AsyncValue.error(l.message, l.stackTrace);
        return null;
      },
      (userId) {
        state = const AsyncValue.data(null);
        return userId;
      },
    );
  }

  Future<bool> isUserSignedUp(String email) async {
    // Set state to loading just to show the loading indicator
    state = const AsyncValue.loading();

    // Check if the user exists in the repository
    final user = await userRepository.getUserDataByEmail(email);

    // Update state based on the result
    state = const AsyncValue.data(null);

    return user != null ? true : false;
  }

  Future<void> verifyOTP({required String userId, required String otp}) async {
    state = const AsyncValue.loading();

    final res = await authRepository.verifyOTP(userId: userId, otp: otp);

    // Update state based on the result
    state = await res.fold(
      (l) => AsyncValue.error(l.message, l.stackTrace),
      (r) async {
        // Check if the user is already signed up
        final user = await userRepository.getUserDataByEmail(r.email);
        if (user != null) {
          // If the user is already signed up, just get the user data

          ref.read(currentUserProvider.notifier).state = user;
          return const AsyncValue.data(null);
        } else {
          UserModel userModel = r.toUserModel();

          // Save User data to provider
          ref.read(currentUserProvider.notifier).state = userModel;

          // Save user data in backend
          final res2 =
              await userRepository.saveUserData(userModel, userModel.id!);
          return res2.fold(
            (l) => AsyncValue.error(l.message, l.stackTrace),
            (r) => const AsyncValue.data(null),
          );
        }
      },
    );
  }

  /// Sends Magic Link for login
  Future<void> sendMagicLink(String email) async {
    // Set state to loading
    state = const AsyncValue.loading();

    final res = await authRepository.sendMagicLink(email: email);

    // Update state based on the result
    state = res.fold(
      (l) => AsyncValue.error(l.message, l.stackTrace),
      (r) => const AsyncValue.data(null),
    );
  }

  void logout(BuildContext context) async {
    await authRepository.logout();
    ref.read(currentUserProvider.notifier).state = null;
    state = const AsyncValue.data(null);
  }

  // void forgetPassword(BuildContext context) async {
  //   final res = await authRepository.logout();
  //   res.fold(
  //     (l) => null,
  //     (r) {
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(

  //           builder: (context) => SignInPage(),
  //         ),
  //         (route) => false,
  //       );
  //     },
  //   );
  // }

  Future<void> setPasswordAndUsername({
    required String userId,
    required String password,
    String? username,
  }) async {
    // Set state to loading
    state = const AsyncValue.loading();

    // Update password
    final passwordRes = await authRepository.updatePassword(password: password);

    // Handle password update result
    state = await passwordRes.fold(
      (l) => AsyncValue.error(l.message, l.stackTrace),
      (r) async {
        if (username != null) {
          // Update username
          final usernameRes = await userRepository.updateUsername(
              userId: userId, username: username);

          // Handle username update result
          return usernameRes.fold(
            (l) => AsyncValue.error(l.message, l.stackTrace),
            (r) => const AsyncValue.data(null),
          );
        } else {
          return const AsyncValue.data(null);
        }
      },
    );
  }
}
