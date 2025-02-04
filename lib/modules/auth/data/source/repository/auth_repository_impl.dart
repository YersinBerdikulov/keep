import 'package:appwrite/models.dart';
import 'package:dongi/shared/types/type_defs.dart';
import 'package:dongi/modules/auth/data/source/network/auth_remote_data_source.dart';
import 'package:dongi/modules/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<User?> currentUserAccount() {
    return _remoteDataSource.currentUserAccount();
  }

  @override
  FutureEitherVoid forgetPassword({required String email}) {
    return _remoteDataSource.forgetPassword(email: email);
  }

  @override
  FutureEitherVoid logout() {
    return _remoteDataSource.logout();
  }

  @override
  FutureEither<User> signIn({required String email, required String password}) {
    return _remoteDataSource.signIn(email: email, password: password);
  }

  @override
  FutureEitherVoid sendMagicLink({required String email}) {
    return _remoteDataSource.sendMagicLink(email: email);
  }

  @override
  FutureEither<String?> sendOTP({required String email}) {
    return _remoteDataSource.sendOTP(email: email);
  }

  @override
  FutureEither<User> verifyOTP({required String userId, required String otp}) {
    return _remoteDataSource.verifyOTP(userId: userId, otp: otp);
  }

  @override
  FutureEither<User> authWithGoogle() {
    return _remoteDataSource.authWithGoogle();
  }

  @override
  FutureEither<User> signUpWithEmail(
      {required String email, required String password}) {
    return _remoteDataSource.signUpWithEmail(email: email, password: password);
  }

  @override
  FutureEitherVoid updatePassword({required String password}) {
    return _remoteDataSource.updatePassword(password: password);
  }
}
