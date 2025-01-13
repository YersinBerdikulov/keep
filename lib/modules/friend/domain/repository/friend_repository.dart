import 'package:appwrite/models.dart';
import 'package:dongi/core/types/type_defs.dart';
import 'package:dongi/models/user_friend_model.dart';

abstract class FriendRepository {
  FutureEither<Document> addFriend(UserFriendModel friendModel);
  Future<List<Document>> getFriends(String uid);
  Future<List<Document>> searchFriends(String uid, String query);
  Future<Document> getFriendDetail(String uid, String friendId);
  FutureEither<bool> deleteFriend(String id);
  FutureEither<Document> updateFriend(UserFriendModel friendModel);
}
