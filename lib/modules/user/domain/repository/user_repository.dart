import 'package:dongi/core/types/type_defs.dart';
import 'package:dongi/modules/auth/domain/models/user_model.dart';

abstract class UserRepository {
  FutureEitherVoid saveUserData(UserModel userModel, String uid);
  Future<UserModel> getUserData(String uid);
  Future<List<UserModel>> getUsersListData(List<String> userIds);
  Future<List<UserModel>> searchUserByName(String name);
  FutureEitherVoid updateUserData(UserModel userModel);
  // Stream<RealtimeMessage> getLatestUserProfileData();
  FutureEitherVoid followUser(UserModel user);
}
