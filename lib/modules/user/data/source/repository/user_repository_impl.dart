import 'package:dongi/shared/types/type_defs.dart';
import 'package:dongi/modules/user/domain/models/user_model.dart';
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
  Future<UserModel?> getUserDataById(String uid) {
    return _remoteDataSource.getUserDataById(uid);
  }

  @override
  Future<UserModel?> getUserDataByEmail(String email) {
    return _remoteDataSource.getUserDataByEmail(email);
  }

  @override
  Future<List<UserModel>> getUsersListData(List<String> userIds) {
    return _remoteDataSource.getUsersListData(userIds);
  }

  @override
  FutureEither<UserModel?> saveUserData(UserModel userModel) {
    return _remoteDataSource.saveUserData(userModel);
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

  @override
  Future<List<UserModel>> getUsersByIds(List<String> userIds) {
    return _remoteDataSource.getUsersListData(userIds);
  }
}
