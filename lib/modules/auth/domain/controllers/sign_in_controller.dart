import 'dart:async';

import 'package:dongi/modules/auth/data/di/auth_di.dart';
import 'package:dongi/modules/auth/domain/models/user_model.dart';
import 'package:dongi/modules/auth/domain/controllers/auth_controller.dart';
import 'package:dongi/modules/auth/domain/repository/auth_repository.dart';
import 'package:dongi/services/user_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// SignInController Provider
final signInControllerProvider = AsyncNotifierProvider<SignInController, void>(
  SignInController.new,
);

/// SignInController Implementation
class SignInController extends AsyncNotifier<void> {
  late final AuthRepository authAPI;
  late final UserAPI userAPI;

  @override
  FutureOr<AsyncValue<void>> build() async {
    // Initialize dependencies
    authAPI = ref.read(authRepositoryProvider);
    userAPI = ref.read(userAPIProvider);

    // Initial state is just AsyncData(null)
    return const AsyncValue.data(null);
  }

  /// Handles Email/Password Sign-In
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    // Set state to loading
    state = const AsyncValue.loading();

    // Perform the sign-in operation
    final res = await authAPI.signIn(email: email, password: password);

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
    final res = await authAPI.signInWithGoogle();

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
        final res2 = await userAPI.saveUserData(userModel, r.$id);
        return res2.fold(
          (l) => AsyncValue.error(l.message, l.stackTrace),
          (r) => const AsyncValue.data(null),
        );
      },
    );
  }
}
