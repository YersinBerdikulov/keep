import 'package:dongi/modules/auth/domain/controllers/auth_controller.dart';
import 'package:dongi/modules/auth/domain/models/user_model.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AuthController Provider
final authControllerProvider =
    AsyncNotifierProvider<AuthController, UserModel?>(
  AuthController.new,
);

final currentUserProvider = StateProvider<UserModel?>((ref) {
  return null;
});
