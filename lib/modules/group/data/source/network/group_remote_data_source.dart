import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dongi/core/constants/appwrite_config.dart';
import 'package:dongi/shared/types/failure.dart';
import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:dongi/modules/group/domain/models/group_user_model.dart';
import 'package:fpdart/fpdart.dart';

class GroupRemoteDataSource {
  final Databases _db;

  GroupRemoteDataSource({required Databases db}) : _db = db;

  Future<Either<Failure, Document>> addGroup(GroupModel groupModel) async {
    try {
      print('Creating group with data: ${groupModel.toJson()}');

      final document = await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.groupCollection,
        documentId: ID.unique(),
        data: groupModel.toJson(),
      );

      print('Created document: ${document.toMap()}');
      print('Document ID: ${document.$id}');
      print('Document data: ${document.data}');

      return right(document);
    } on AppwriteException catch (e, st) {
      print('Error creating group: ${e.message}');
      print('Error type: ${e.type}');
      print('Error code: ${e.code}');
      return left(Failure(e.message ?? 'Unexpected error occurred', st));
    }
  }

  Future<Either<Failure, Document>> updateGroup(GroupModel groupModel) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.groupCollection,
        documentId: groupModel.id!,
        data: groupModel.toJson(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Unexpected error occurred', st));
    }
  }

  Future<Either<Failure, bool>> deleteGroup(String id) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.groupCollection,
        documentId: id,
      );
      return right(true);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Unexpected error occurred', st));
    }
  }

  Future<List<Document>> getGroups(String uid) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.groupCollection,
      queries: [Query.contains('groupUsers', uid)],
    );
    return document.documents;
  }

  Future<List<Document>> getUsersInGroup(List<String> userIds) async {
    if (userIds.isEmpty) return [];
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.usersCollection,
      queries: [Query.equal('\$id', userIds)],
    );
    return document.documents;
  }

  Future<Document> getGroupDetail(String groupId) async {
    final document = await _db.getDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.groupCollection,
      documentId: groupId,
    );
    return document;
  }

  Future<List<Document>> getCurrentUserLatestGroup(
      String uid, int limit) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.groupCollection,
      queries: [
        Query.contains('groupUsers', uid),
        Query.orderDesc('\$createdAt'),
        Query.limit(limit),
      ],
    );
    return document.documents;
  }
  
  Future<List<Document>> getGroupUsers(String groupId) async {
    try {
      final document = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.groupUserCollection,
        queries: [
          Query.equal('groupId', groupId),
        ],
      );
      return document.documents;
    } catch (e) {
      print('Error fetching group users: $e');
      return [];
    }
  }
  
  Future<Either<Failure, Document>> addGroupUser(GroupUserModel groupUserModel) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.groupUserCollection,
        documentId: ID.unique(),
        data: groupUserModel.toJson(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Unexpected error occurred', st));
    }
  }
  
  Future<Either<Failure, Document>> updateGroupUser(GroupUserModel groupUserModel) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.groupUserCollection,
        documentId: groupUserModel.id!,
        data: groupUserModel.toJson(),
      );
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Unexpected error occurred', st));
    }
  }
  
  Future<Either<Failure, bool>> deleteGroupUser(String id) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.groupUserCollection,
        documentId: id,
      );
      return right(true);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Unexpected error occurred', st));
    }
  }
}
