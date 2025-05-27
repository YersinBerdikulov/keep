import 'dart:async';

import 'package:dongi/modules/auth/data/di/auth_di.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/auth/domain/models/auth_user_model.dart';
import 'package:dongi/modules/auth/domain/repository/auth_repository.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:dongi/modules/user/domain/di/user_usecase_di.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:dongi/modules/group/domain/di/group_controller_di.dart';
import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:dongi/modules/expense/domain/di/expense_controller_di.dart';
import 'package:dongi/modules/expense/domain/di/category_controller_di.dart';
import 'package:dongi/modules/expense/presentation/widgets/create_expense_widget.dart';
import 'package:dongi/modules/user/domain/usecases/get_user_data_by_email_usecase.dart';
import 'package:dongi/modules/user/domain/usecases/save_user_data_usecase.dart';
import 'package:dongi/core/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthController extends AsyncNotifier<AuthUserModel?> {
  late final AuthRepository authRepository;
  late final GetUserDataByEmailUseCase getUserDataByEmailUseCase;
  late final SaveUserDataUseCase saveUserDataUseCase;

  @override
  FutureOr<AuthUserModel?> build() async {
    authRepository = ref.read(authRepositoryProvider);
    getUserDataByEmailUseCase = ref.read(getUserDataByEmailUseCaseProvider);
    saveUserDataUseCase = ref.read(saveUserDataUseCaseProvider);
    return await currentUser();
  }

  Future<AuthUserModel?> currentUser() async {
    final user = await authRepository.currentUserAccount();
    if (user == null) return null;

    return user.toAuthUserModel();
  }


  Future<AuthUserModel?> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final res = await authRepository.signIn(email: email, password: password);

    return res.fold(
      (l) {
        state = AsyncValue.error(l.message, l.stackTrace);
        return null;
      },
      (r) {
        final authUserModel = r.toAuthUserModel();
        // Update auth state
        ref.read(currentUserProvider.notifier).state = authUserModel;
        // Invalidate and refresh user data
        ref.invalidate(userNotifierProvider);
        state = AsyncValue.data(authUserModel);
        return authUserModel;
      },
    );
  }

  Future<AuthUserModel?> authWithGoogle() async {
    state = const AsyncValue.loading();

    final googleAuthResult = await authRepository.authWithGoogle();

    return await googleAuthResult.fold(
      (l) {
        state = AsyncValue.error(l.message, l.stackTrace);
        return null;
      },
      (r) async {
        final existingUser = await getUserDataByEmailUseCase.execute(r.email);
        final authUserModel = r.toAuthUserModel();

        if (existingUser != null) {
          // Update auth state
          ref.read(currentUserProvider.notifier).state = authUserModel;
          // Invalidate and refresh user data
          ref.invalidate(userNotifierProvider);
          state = AsyncValue.data(authUserModel);
          return authUserModel;
        }

        final saveUserResult =
            await saveUserDataUseCase.execute(email: r.email);

        return saveUserResult.fold(
          (l) {
            state = AsyncValue.error(l.message, l.stackTrace);
            return null;
          },
          (_) {
            // Update auth state
            ref.read(currentUserProvider.notifier).state = authUserModel;
            // Invalidate and refresh user data
            ref.invalidate(userNotifierProvider);
            state = AsyncValue.data(authUserModel);
            return authUserModel;
          },
        );
      },
    );
  }

  Future<String?> sendOTP({required String email}) async {
    state = const AsyncValue.loading();

    final res = await authRepository.sendOTP(email: email);

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
    state = const AsyncValue.loading();
    final user = await getUserDataByEmailUseCase.execute(email);
    state = const AsyncValue.data(null);
    return user != null;
  }

  Future<AuthUserModel?> verifyOTP({
    required String userId,
    required String otp,
  }) async {
    state = const AsyncValue.loading();

    final res = await authRepository.verifyOTP(userId: userId, otp: otp);

    return await res.fold(
      (l) {
        state = AsyncValue.error(l.message, l.stackTrace);
        return null;
      },
      (r) async {
        final existingUser = await getUserDataByEmailUseCase.execute(r.email);
        final authUserModel = r.toAuthUserModel();

        if (existingUser != null) {
          // Update auth state
          ref.read(currentUserProvider.notifier).state = authUserModel;
          // Invalidate and refresh user data
          ref.invalidate(userNotifierProvider);
          state = AsyncValue.data(authUserModel);
          return authUserModel;
        }

        final saveUserResult =
            await saveUserDataUseCase.execute(email: r.email);

        return saveUserResult.fold(
          (l) {
            state = AsyncValue.error(l.message, l.stackTrace);
            return null;
          },
          (_) {
            // Update auth state
            ref.read(currentUserProvider.notifier).state = authUserModel;
            // Invalidate and refresh user data
            ref.invalidate(userNotifierProvider);
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
