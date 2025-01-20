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
  FutureEitherVoid sendOTP({required String email}) {
    return _remoteDataSource.sendOTP(email: email);
  }

  @override
  FutureEitherVoid verifyOTP({required String email, required String otp}) {
    return _remoteDataSource.verifyOTP(email: email, otp: otp);
  }

  @override
  FutureEither<User> signInWithGoogle() {
    return _remoteDataSource.signInWithGoogle();
  }

  @override
  FutureEither<User> signUp({required String email, required String password}) {
    return _remoteDataSource.signUp(email: email, password: password);
  }

  @override
  FutureEitherVoid updatePassword({required String password}) {
    return _remoteDataSource.updatePassword(password: password);
  }
}
