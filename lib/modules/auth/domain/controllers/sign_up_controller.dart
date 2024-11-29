import 'dart:async';

import 'package:dongi/modules/auth/domain/controllers/auth_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/user_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/user_service.dart';

/// SignUpController Provider
final signUpControllerProvider = AsyncNotifierProvider<SignUpController, void>(
  SignUpController.new,
);

/// SignUpController Implementation
class SignUpController extends AsyncNotifier<void> {
  late final AuthAPI authAPI;
  late final UserAPI userAPI;

  @override
  FutureOr<AsyncValue<void>> build() async {
    // Initialize dependencies
    authAPI = ref.read(authAPIProvider);
    userAPI = ref.read(userAPIProvider);

    // Initial state is just AsyncData(null)
    return const AsyncValue.data(null);
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
    final res = await authAPI.signUp(email: email, password: password);

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
        final res2 = await userAPI.saveUserData(userModel, r.$id);

        // Handle result of saveUserData
        return await res2.fold(
          (l) => AsyncValue.error(l.message, l.stackTrace),
          (r) async {
            // Automatically sign in the user to create a session
            final signInRes = await authAPI.signIn(
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
}
