import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:dongi/shared/types/failure.dart';
import 'package:dongi/shared/types/type_defs.dart';
import 'package:fpdart/fpdart.dart';

class AuthRemoteDataSource {
  final Account _account;

  AuthRemoteDataSource({required Account account}) : _account = account;

  Future<User?> currentUserAccount() async {
    try {
      return await _account.get();
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  FutureEither<User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final account = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  FutureEither<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Below API will return session that we don't need in this step
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final account = await currentUserAccount();
      if (account == null) throw "account not found";

      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  FutureEither<User> signInWithGoogle() async {
    try {
      await _account.createOAuth2Session(
        provider: OAuthProvider.google,
      );
      final account = await currentUserAccount();
      if (account == null) throw "account not found";

      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  FutureEitherVoid logout() async {
    try {
      await _account.deleteSession(
        sessionId: 'current',
      );
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  FutureEitherVoid forgetPassword({required String email}) async {
    try {
      await _account.createRecovery(
          email: email, url: 'dongi://reset-password');

      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  /// Sends an OTP to the user's email for verification
  FutureEitherVoid sendOTP({required String email}) async {
    try {
      await _account.createVerification(url: 'dongi://verify-email');
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Failed to send OTP', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  /// Verifies the OTP sent to the user's email
  FutureEitherVoid verifyOTP({
    required String email,
    required String otp,
  }) async {
    try {
      await _account.updateVerification(userId: email, secret: otp);
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Failed to send OTP', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  /// Sends a Magic Link to the user's email for authentication
  FutureEitherVoid sendMagicLink({required String email}) async {
    try {
      await _account.createMagicURLToken(
        userId: ID.unique(),
        email: email,
        url: 'dongi://magic-link',
      );
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Failed to send Magic Link', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  FutureEitherVoid updatePassword({
    required String password,
  }) async {
    try {
      await _account.updatePassword(password: password);
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Failed to update password', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }
}
