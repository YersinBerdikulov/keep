import 'package:dongi/modules/auth/domain/controllers/auth_controller.dart';
import 'package:dongi/modules/auth/domain/models/auth_user_model.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AuthController Provider
final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthUserModel?>(
  AuthController.new,
);

final currentUserProvider = StateProvider<AuthUserModel?>((ref) {
  return null;
});
