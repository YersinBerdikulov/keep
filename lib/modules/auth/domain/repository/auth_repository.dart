import 'package:appwrite/models.dart';
import 'package:dongi/shared/types/type_defs.dart';

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

  /// Sends an OTP to the given email for verification
  FutureEitherVoid sendOTP({required String email});

  /// Verifies the OTP sent to the given email
  FutureEitherVoid verifyOTP({required String email, required String otp});

  /// Sends a Magic Link to the given email for authentication
  FutureEitherVoid sendMagicLink({required String email});

  /// update password for the given user
  FutureEitherVoid updatePassword({required String password});
}
