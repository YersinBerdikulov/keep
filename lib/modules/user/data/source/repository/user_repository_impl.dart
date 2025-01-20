import 'package:dongi/shared/types/type_defs.dart';
import 'package:dongi/modules/auth/domain/models/user_model.dart';
import 'package:dongi/modules/user/data/source/network/user_remote_data_source.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl({required UserRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<UserModel> getCurrentUserData() {
    return _remoteDataSource.getCurrentUserData();
  }

  @override
  Future<UserModel> getUserData(String uid) {
    return _remoteDataSource.getUserData(uid);
  }

  @override
  Future<List<UserModel>> getUsersListData(List<String> userIds) {
    return _remoteDataSource.getUsersListData(userIds);
  }

  @override
  FutureEitherVoid saveUserData(UserModel userModel, String uid) {
    return _remoteDataSource.saveUserData(userModel, uid);
  }

  @override
  Future<List<UserModel>> searchUserByName(String name) {
    return _remoteDataSource.searchUserByName(name);
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) {
    return _remoteDataSource.updateUserData(userModel);
  }

  @override
  FutureEitherVoid updateUsername(
      {required String userId, required String username}) {
    return _remoteDataSource.updateUsername(userId: userId, username: username);
  }
}
