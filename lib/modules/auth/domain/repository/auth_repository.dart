import 'package:appwrite/models.dart';
import 'package:dongi/core/types/type_defs.dart';

abstract class AuthRepository {
  FutureEither<User> signUp({
    required String email,
    required String password,
  });
  FutureEither<User> signIn({
    required String email,
    required String password,
  });
  FutureEither<User> signInWithGoogle();
  FutureEitherVoid forgetPassword({
    required String email,
  });
  Future<User?> currentUserAccount();
  FutureEitherVoid logout();
}
