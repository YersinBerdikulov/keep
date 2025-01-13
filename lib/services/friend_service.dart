import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dongi/core/constants/appwrite_config.dart';
import 'package:dongi/models/user_friend_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../core/types/failure.dart';
import '../core/di/appwrite_di.dart';
import '../core/types/type_defs.dart';

final friendAPIProvider = Provider((ref) {
  return FriendAPI(
    db: ref.watch(appwriteDatabaseProvider),
    //functions: ref.watch(appwriteFunctionProvider),
  );
});

abstract class IFriendAPI {
  //
  //FutureEitherVoid saveUserData(UserModel userModel);
  //Future<model.Document> getUserData(String uid);
  //Future<List<model.Document>> searchUserByName(String name);
  //FutureEitherVoid updateUserData(UserModel userModel);
  //Stream<RealtimeMessage> getLatestUserProfileData();
  //FutureEitherVoid followUser(UserModel user);
}

class FriendAPI implements IFriendAPI {
  final Databases _db;
  //final Functions _functions;
  FriendAPI({
    required Databases db,
    //required Functions functions,
  }) : _db = db;
  //_functions = functions;
}
