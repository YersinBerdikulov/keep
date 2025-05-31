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

  FutureEither<User> signUpWithEmail({
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

  FutureEither<User> authWithGoogle() async {
    try {
      print("Starting Google authentication with account selection...");

      // First, try to delete the current session to ensure we're starting fresh
      try {
        await _account.deleteSession(sessionId: 'current');
      } catch (e) {
        // Ignore errors if no session exists
        print("No active session to delete: $e");
      }

      // Create the OAuth2 session with Google
      // The session should be forced to show the account selector because
      // we've deleted any existing session before this call
      await _account.createOAuth2Session(
        provider: OAuthProvider.google,
      );

      // Add a small delay to ensure the session is properly created
      await Future.delayed(const Duration(milliseconds: 500));

      // Try to get the account multiple times in case of initial delay
      User? account;
      int retries = 3;

      while (retries > 0 && account == null) {
        try {
          account = await currentUserAccount();
          if (account != null) break;
        } catch (e) {
          print("Retry error: $e");
        }

        await Future.delayed(const Duration(milliseconds: 500));
        retries--;
      }

      if (account == null) {
        throw "Failed to get account after Google authentication. Please try again.";
      }

      return right(account);
    } on AppwriteException catch (e, stackTrace) {
      print("Appwrite exception: ${e.message}");
      return left(
        Failure(e.message ?? 'Google authentication failed. Please try again.',
            stackTrace),
      );
    } catch (e, stackTrace) {
      print("General exception: $e");
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
      print("Logout error: $e");
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
  FutureEither<String?> sendOTP({required String email}) async {
    try {
      final sessionToken = await _account.createEmailToken(
        email: email,
        userId: ID.unique(),
      );

      return right(sessionToken.userId);
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
  FutureEither<User> verifyOTP({
    required String userId,
    required String otp,
  }) async {
    try {
      // Check for active session
      // final sessionList = await _account.listSessions();
      // if (sessionList.sessions.isNotEmpty) {
      //   await _account.deleteSessions();
      // }

      await _account.createSession(
        userId: userId,
        secret: otp,
      );
      final account = await currentUserAccount();
      if (account == null) throw "account not found";

      return right(account);
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
