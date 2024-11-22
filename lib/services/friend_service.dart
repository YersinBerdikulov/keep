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
  FutureEither<Document> addFriend(UserFriendModel friendModel);
  Future<List<Document>> getFriends(String uid);
  Future<List<Document>> searchFriends(String uid, String query);
  Future<Document> getFriendDetail(String uid, String friendId);
  FutureEither<bool> deleteFriend(String id);
  FutureEither<Document> updateFriend(UserFriendModel friendModel);
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

  @override
  FutureEither<Document> addFriend(UserFriendModel friendModel) async {
    try {
      // Query the collection to check if a request already exists
      final List<Document> existingRequests = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.userFriendCollection,
        queries: [
          Query.equal('sendRequestUserId', friendModel.sendRequestUserId),
          Query.equal('receiveRequestUserId', friendModel.receiveRequestUserId),
        ],
      ).then((response) => response.documents);

      // If there's already an existing request, return an error
      if (existingRequests.isNotEmpty) {
        return left(
          Failure('Friend request already exists', StackTrace.current),
        );
      }

      // If no request exists, create the new friend request
      final document = await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.userFriendCollection,
        documentId: ID.unique(),
        data: friendModel.toJson(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<bool> deleteFriend(String id) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.userFriendCollection,
        documentId: id,
      );
      return right(true);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> getFriends(String uid) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.userFriendCollection,
      queries: [
        Query.or([
          Query.equal('sendRequestUserId', uid),
          Query.equal('receiveRequestUserId', uid),
        ]),
      ],
    );
    return document.documents;
  }

  @override
  Future<List<Document>> searchFriends(String uid, String query) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.usersCollection,
      queries: [
        Query.notEqual('\$id', uid),
        Query.limit(25),
        Query.or([
          Query.search('email', query),
          Query.search('userName', query),
        ])
      ],
    );
    return document.documents;
  }

  @override
  Future<Document> getFriendDetail(String uid, String friendId) async {
    final document = await _db.getDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.userFriendCollection,
      documentId: friendId,
    );
    return document;
  }

  @override
  FutureEither<Document> updateFriend(UserFriendModel friendModel) async {
    try {
      // If no request exists, create the new friend request
      final document = await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.userFriendCollection,
        documentId: friendModel.id!,
        data: friendModel.toJson(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}
