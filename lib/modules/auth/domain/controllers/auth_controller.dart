import 'dart:async';

import 'package:dongi/app/auth/sign_in/sign_in_page.dart';
import 'package:dongi/core/router/router_notifier.dart';
import 'package:dongi/models/user_model.dart';
import 'package:dongi/services/auth_service.dart';
import 'package:dongi/services/user_service.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

/// AuthController Provider
final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserModel?>(
  AuthController.new,
);

final getUserData = FutureProvider.family((ref, String uid) {
  final userDetails = ref.watch(authControllerProvider.notifier);
  return userDetails.getUserData(uid);
});

final getUsersListData = FutureProvider.family((ref, List<String> uid) {
  final userDetails = ref.watch(authControllerProvider.notifier);
  return userDetails.getUsersListData(uid);
});

final currentUserProvider = StateProvider<UserModel?>((ref) {
  return null;
});

class AuthController extends AsyncNotifier<UserModel?> {
  late final AuthAPI authAPI;
  late final UserAPI userAPI;

  @override
  FutureOr<UserModel?> build() async {
    // Initialize dependencies
    authAPI = ref.read(authAPIProvider);
    userAPI = ref.read(userAPIProvider);

    // Return the current user if logged in
    return await currentUser();
  }

  Future<UserModel?> currentUser() async {
    final user = await authAPI.currentUserAccount();
    if (user == null) return null;

    return user.toUserModel();
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await userAPI.getUserData(uid);
    final updatedUser = UserModel.fromJson(document.data);
    return updatedUser;
  }

  Future<List<UserModel>> getUsersListData(List<String> userIds) async {
    final document = await userAPI.getUsersListData(userIds);
    return document.map((user) => UserModel.fromJson(user.data)).toList();
  }

  void logout(BuildContext context) async {
    final res = await authAPI.logout();
    res.fold(
      (l) => null,
      (r) {
        ref.read(currentUserProvider.notifier).state = null;
        context.go(RouteName.signin);
      },
    );
  }

  void forgetPassword(BuildContext context) async {
    final res = await authAPI.logout();
    res.fold(
      (l) => null,
      (r) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ),
          (route) => false,
        );
      },
    );
  }
}
