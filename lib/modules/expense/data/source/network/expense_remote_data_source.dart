import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:dongi/core/constants/appwrite_config.dart';
import 'package:dongi/shared/types/failure.dart';
import 'package:dongi/shared/types/type_defs.dart';
import 'package:dongi/modules/expense/domain/models/expense_model.dart';
import 'package:dongi/modules/expense/domain/models/expense_user_model.dart';
import 'package:fpdart/fpdart.dart';

class ExpenseRemoteDataSource {
  final Databases _db;

  ExpenseRemoteDataSource({required Databases db}) : _db = db;

  FutureEither<Document> addExpense(
    ExpenseModel expenseModel, {
    required String customId,
  }) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.expenseCollection,
        documentId: customId,
        data: expenseModel.toJson(),
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

  FutureEither<Document> updateExpense(Map updateExpenseModel) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.expenseCollection,
        documentId: updateExpenseModel["\$id"],
        data: updateExpenseModel,
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

  FutureEither<bool> deleteExpense(String id) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.expenseCollection,
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

  FutureEither<bool> deleteAllExpense(List<String> ids) async {
    try {
      for (var id in ids) {
        try {
          await _db.deleteDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.expenseCollection,
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

  FutureEither<bool> addExpenseUser(
    ExpenseUserModel expenseUser, {
    required String customId,
  }) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.expenseUserCollection,
        documentId: customId,
        data: expenseUser.toJson(),
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

  FutureEither<bool> deleteExpenseUser(String id) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.expenseUserCollection,
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

  Future<List<Document>> getExpenses(String uid) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.groupCollection,
      queries: [
        Query.equal('creatorId', uid),
      ],
    );
    return document.documents;
  }

  Future<List<Document>> getExpensesInBox(String boxId) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.expenseCollection,
      queries: [
        // Show the new expense on top
        Query.orderDesc('\$createdAt'),
        Query.equal('boxId', boxId),
      ],
    );
    return document.documents;
  }

  Future<Document> getExpenseDetail(String expenseId) async {
    final document = await _db.getDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.expenseCollection,
      documentId: expenseId,
      //queries: [
      //  Query.equal('\$id', expenseId),
      //],
    );
    return document;
  }

  Future<List<Document>> getUsersInExpense(List<String> userIds) async {
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

  Future<List<Document>> getCurrentUserExpenses(String uid) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.expenseCollection,
      queries: [
        Query.equal('creatorId', uid),
      ],
    );
    return document.documents;
  }
}
