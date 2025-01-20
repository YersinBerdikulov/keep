import 'package:dongi/shared/types/type_defs.dart';
import 'package:dongi/modules/auth/domain/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getCurrentUserData();
  FutureEitherVoid saveUserData(UserModel userModel, String uid);
  Future<UserModel> getUserData(String uid);
  Future<List<UserModel>> getUsersListData(List<String> userIds);
  Future<List<UserModel>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);

  /// update username for the given user
  FutureEitherVoid updateUsername({
    required String userId,
    required String username,
  });
}
