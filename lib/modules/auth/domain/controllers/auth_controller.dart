import 'dart:async';

import 'package:dongi/modules/auth/data/di/auth_di.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/auth/domain/models/auth_user_model.dart';
import 'package:dongi/modules/auth/domain/repository/auth_repository.dart';
import 'package:dongi/modules/user/domain/di/user_usecase_di.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:dongi/modules/group/domain/di/group_controller_di.dart';
import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:dongi/modules/expense/domain/di/expense_controller_di.dart';
import 'package:dongi/modules/expense/domain/di/category_controller_di.dart';
import 'package:dongi/modules/expense/presentation/widgets/create_expense_widget.dart';
import 'package:dongi/modules/user/domain/usecases/get_user_data_by_email_usecase.dart';
import 'package:dongi/modules/user/domain/usecases/save_user_data_usecase.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthController extends AsyncNotifier<AuthUserModel?> {
  late final AuthRepository authRepository;
  late final GetUserDataByEmailUseCase getUserDataByEmailUseCase;
  late final SaveUserDataUseCase saveUserDataUseCase;
  // late final UserRepository userRepository;

  @override
  FutureOr<AuthUserModel?> build() async {
    // Initialize dependencies
    authRepository = ref.read(authRepositoryProvider);
    getUserDataByEmailUseCase = ref.read(getUserDataByEmailUseCaseProvider);
    saveUserDataUseCase = ref.read(saveUserDataUseCaseProvider);
    // userRepository = ref.read(userRepositoryProvider);

    // Return the current user if logged in
    return await currentUser();
  }

  Future<AuthUserModel?> currentUser() async {
    final user = await authRepository.currentUserAccount();
    if (user == null) return null;

    return user.toAuthUserModel();
  }

  /// Handles Sign-Up Logic
  // Future<void> signUpWithEmail({
  //   required String email,
  //   required String userName,
  //   required String password,
  // }) async {
  //   // Set state to loading
  //   state = const AsyncValue.loading();

  //   // Perform sign-up operation
  //   final res = await authRepository.signUpWithEmail(
  //     email: email,
  //     password: password,
  //   );

  //   // Update state based on the result
  //   state = await res.fold(
  //     (l) => AsyncValue.error(l.message, l.stackTrace),
  //     (r) async {
  //       // Create UserModel
  //       UserModel userModel = UserModel(
  //         email: email,
  //         userName: userName,
  //       );

  //       // In here we know that the user isn't signed up before
  //       // Save user data to backend
  //       final res2 = await userRepository.saveUserData(userModel);

  //       // Handle result of saveUserData
  //       return await res2.fold(
  //         (l) => AsyncValue.error(l.message, l.stackTrace),
  //         (r) async {
  //           // Automatically sign in the user to create a session
  //           await signIn(email: email, password: password);
  //           return const AsyncValue.data(null);
  //         },
  //       );
  //     },
  //   );
  // }

  /// Handles Email/Password Sign-In
  Future<AuthUserModel?> signIn({
    required String email,
    required String password,
  }) async {
    // Set state to loading
    state = const AsyncValue.loading();

    // Perform the sign-in operation
    final res = await authRepository.signIn(email: email, password: password);

    // Handle the result and return the user if successful
    return res.fold(
      (l) {
        state = AsyncValue.error(l.message, l.stackTrace);
        return null;
      },
      (r) {
        final authUserModel = r.toAuthUserModel();
        // Save User data to provider
        ref.read(currentUserProvider.notifier).state = authUserModel;
        state = AsyncValue.data(authUserModel);
        return authUserModel;
      },
    );
  }

  /// Handles Google Sign-In
  Future<AuthUserModel?> authWithGoogle() async {
    // Set state to loading
    state = const AsyncValue.loading();

    // Perform Google sign-in
    final googleAuthResult = await authRepository.authWithGoogle();

    return await googleAuthResult.fold(
      (l) {
        state = AsyncValue.error(l.message, l.stackTrace);
        return null;
      },
      (r) async {
        // Check if user exists in database
        final existingUser = await getUserDataByEmailUseCase.execute(r.email);
        final authUserModel = r.toAuthUserModel();

        if (existingUser != null) {
          // User already exists, update provider state and return user
          ref.read(currentUserProvider.notifier).state = authUserModel;
          state = AsyncValue.data(authUserModel);
          return authUserModel;
        }

        // If user doesn't exist, create new user

        final saveUserResult =
            await saveUserDataUseCase.execute(email: r.email);

        return saveUserResult.fold(
          (l) {
            state = AsyncValue.error(l.message, l.stackTrace);
            return null;
          },
          (_) {
            ref.read(currentUserProvider.notifier).state = authUserModel;
            state = AsyncValue.data(authUserModel);
            return authUserModel;
          },
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
    final user = await getUserDataByEmailUseCase.execute(email);

    // Update state based on the result
    // state = const AsyncValue.data(null);
    if (user != null) {
      state = const AsyncValue.data(null);
      return true;
    } else {
      state = AsyncValue.error('User already exists', StackTrace.current);
      return false;
    }
  }

  Future<AuthUserModel?> verifyOTP(
      {required String userId, required String otp}) async {
    // Set state to loading
    state = const AsyncValue.loading();

    // Verify OTP
    final res = await authRepository.verifyOTP(userId: userId, otp: otp);

    return await res.fold(
      (l) {
        state = AsyncValue.error(l.message, l.stackTrace);
        return null;
      },
      (r) async {
        // Check if the user is already in the database
        final existingUser = await getUserDataByEmailUseCase.execute(r.email);
        final authUserModel = r.toAuthUserModel();

        if (existingUser != null) {
          // User already exists, update provider state and return user
          ref.read(currentUserProvider.notifier).state = authUserModel;
          state = AsyncValue.data(authUserModel);
          return authUserModel;
        }

        // If user doesn't exist, create new user
        final saveUserResult =
            await saveUserDataUseCase.execute(email: r.email);

        return saveUserResult.fold(
          (l) {
            state = AsyncValue.error(l.message, l.stackTrace);
            return null;
          },
          (r2) {
            ref.read(currentUserProvider.notifier).state = authUserModel;
            state = AsyncValue.data(authUserModel);
            return authUserModel;
          },
        );
      },
    );
  }

  /// Sends Magic Link for login
  // Future<void> sendMagicLink(String email) async {
  //   // Set state to loading
  //   state = const AsyncValue.loading();

  //   final res = await authRepository.sendMagicLink(email: email);

  //   // Update state based on the result
  //   state = res.fold(
  //     (l) => AsyncValue.error(l.message, l.stackTrace),
  //     (r) => const AsyncValue.data(null),
  //   );
  // }

  void logout(BuildContext context) async {
    await authRepository.logout();

    // Clear all provider states
    ref.invalidate(currentUserProvider);
    ref.invalidate(homeNotifierProvider);
    ref.invalidate(groupNotifierProvider);
    ref.invalidate(boxNotifierProvider);
    ref.invalidate(expenseNotifierProvider);
    ref.invalidate(getBoxDetailProvider); // This will clear box cache
    ref.invalidate(getExpensesInBoxProvider); // This will clear expense cache
    ref.invalidate(selectedMembersProvider);
    ref.invalidate(selectedCurrencyProvider);
    ref.invalidate(expensePayerIdProvider);
    ref.invalidate(expenseCategoryIdProvider);
    ref.invalidate(splitUserProvider);
    ref.invalidate(selectedDateProvider);

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

  Future<void> setPassword({
    required String password,
  }) async {
    // Set state to loading
    state = const AsyncValue.loading();

    // Update password
    final passwordRes = await authRepository.updatePassword(password: password);

    // Handle password update result
    state = passwordRes.fold(
      (l) => AsyncValue.error(l.message, l.stackTrace),
      (r) => const AsyncValue.data(null),
    );
  }
}
