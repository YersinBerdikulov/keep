import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dongi/core/constants/appwrite_config.dart';
import 'package:dongi/shared/types/failure.dart';
import 'package:dongi/shared/types/type_defs.dart';
import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:fpdart/fpdart.dart';

class FriendRemoteDataSource {
  final Databases _db;

  FriendRemoteDataSource({required Databases db}) : _db = db;

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

  Future<Document> getFriendDetail(String uid, String friendId) async {
    final document = await _db.getDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.userFriendCollection,
      documentId: friendId,
    );
    return document;
  }

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
