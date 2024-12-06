import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dongi/core/constants/appwrite_config.dart';
import 'package:dongi/core/types/failure.dart';
import 'package:dongi/core/types/type_defs.dart';
import 'package:dongi/modules/box/domain/models/box_model.dart';
import 'package:fpdart/fpdart.dart';

class BoxRemoteDataSource {
  final Databases _db;

  BoxRemoteDataSource({required Databases db}) : _db = db;

  FutureEither<Document> addBox(BoxModel boxModel) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.boxCollection,
        documentId: ID.unique(),
        data: boxModel.toJson(),
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

  FutureEither<Document> updateBox(BoxModel updateBoxModel) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.boxCollection,
        documentId: updateBoxModel.id!,
        data: updateBoxModel.toJson(),
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

  FutureEither<bool> deleteBox(String id) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.boxCollection,
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

  FutureEither<bool> deleteAllBox(List<String> ids) async {
    try {
      for (var id in ids) {
        try {
          await _db.deleteDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.boxCollection,
            documentId: id,
          );
        } catch (e) {
          rethrow;
        }
      }
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

  Future<List<Document>> getBoxes(String uid) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.groupCollection,
      queries: [
        Query.equal('creatorId', uid),
      ],
    );
    return document.documents;
  }

  Future<List<Document>> getBoxesInGroup(String groupId) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.boxCollection,
      queries: [
        Query.equal('groupId', groupId),
      ],
    );
    return document.documents;
  }

  Future<Document> getBoxDetail(String boxId) async {
    final document = await _db.getDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.boxCollection,
      documentId: boxId,
      //queries: [
      //  Query.equal('groupId', groupId),
      //],
    );
    return document;
  }

  Future<List<Document>> getUsersInBox(List<String> userIds) async {
    try {
      if (userIds.isEmpty) return [];
      final document = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        queries: [
          Query.equal('\$id', userIds),
        ],
      );
      return document.documents;
    } catch (e) {
      return [];
    }
  }

  Future<List<Document>> getCurrentUserBoxes(String uid) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.boxCollection,
      queries: [
        Query.equal('creatorId', uid),
      ],
    );
    return document.documents;
  }
}
