import 'package:appwrite/models.dart';
import 'package:dongi/shared/types/type_defs.dart';
import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/modules/friend/data/source/network/friend_remote_data_source.dart';
import 'package:dongi/modules/friend/domain/repository/friend_repository.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendRemoteDataSource _remoteDataSource;

  FriendRepositoryImpl({required FriendRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  FutureEither<Document> addFriend(UserFriendModel friendModel) {
    return _remoteDataSource.addFriend(friendModel);
  }

  @override
  FutureEither<bool> deleteFriend(String id) {
    return _remoteDataSource.deleteFriend(id);
  }

  @override
  Future<Document> getFriendDetail(String uid, String friendId) {
    return _remoteDataSource.getFriendDetail(uid, friendId);
  }

  @override
  Future<List<Document>> getFriends(String uid) {
    return _remoteDataSource.getFriends(uid);
  }

  @override
  Future<List<Document>> searchFriends(String uid, String query) {
    return _remoteDataSource.searchFriends(uid, query);
  }

  @override
  FutureEither<Document> updateFriend(UserFriendModel friendModel) {
    return _remoteDataSource.updateFriend(friendModel);
  }
}
