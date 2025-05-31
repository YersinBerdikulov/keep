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
      // Create a copy of the data for better debugging
      final data = expenseModel.toJson();

      // Log the data being sent to Appwrite
      print('Adding expense to Appwrite with data: $data');
      print('Category ID in data: ${data['categoryId']}');

      final document = await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.expenseCollection,
        documentId: customId,
        data: data,
      );

      print('Expense created with ID: ${document.$id}');
      print('Category ID in created document: ${document.data['categoryId']}');

      return right(document);
    } on AppwriteException catch (e, st) {
      print('Appwrite error creating expense: ${e.message}');
      print('Data: ${e.response}');

      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      print('General error creating expense: $e');
      return left(Failure(e.toString(), st));
    }
  }

  FutureEither<Document> updateExpense(Map updateExpenseModel) async {
    try {
      print('Updating expense in Appwrite:');
      print('Document ID: ${updateExpenseModel["\$id"]}');
      print('Update data: $updateExpenseModel');

      final document = await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.expenseCollection,
        documentId: updateExpenseModel["\$id"],
        data: updateExpenseModel,
      );

      print('Successfully updated expense:');
      print('Document ID: ${document.$id}');
      print('Updated At: ${document.$updatedAt}');
      print('Data: ${document.data}');

      return right(document);
    } on AppwriteException catch (e, st) {
      print('Appwrite error updating expense:');
      print('Error message: ${e.message}');
      print('Error code: ${e.code}');
      print('Error type: ${e.type}');
      print('Response: ${e.response}');

      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      print('General error updating expense: $e');
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
      print('Adding expense user to Appwrite:');
      print('Collection ID: ${AppwriteConfig.expenseUserCollection}');
      print('Document ID: $customId');

      // Get the model data and remove any system attributes
      final modelData = expenseUser.toJson();
      modelData.remove('\$id');
      modelData.remove('\$createdAt');
      modelData.remove('\$updatedAt');
      
      // Add required timestamps
      final now = DateTime.now().toIso8601String();
      modelData['createdAt'] = now;
      if (modelData['updatedBy'] != null && modelData['updatedAt'] == null) {
        modelData['updatedAt'] = now;
      }
      
      // Ensure all required fields are present
      final requiredFields = [
        'userId', 'groupId', 'boxId', 'expenseId', 'cost',
        'isPaid', 'createdAt', 'splitType', 'currency',
        'recipients', 'status'
      ];
      
      for (var field in requiredFields) {
        if (!modelData.containsKey(field) || modelData[field] == null) {
          throw Exception('Missing required field: $field');
        }
      }
      
      print('Data to be sent: $modelData');

      final document = await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.expenseUserCollection,
        documentId: customId,
        data: modelData,
      );

      print('Successfully created expense user document:');
      print('Document ID: ${document.$id}');
      print('Created At: ${document.$createdAt}');
      print('Data: ${document.data}');

      return right(true);
    } on AppwriteException catch (e, st) {
      print('Appwrite error creating expense user:');
      print('Error message: ${e.message}');
      print('Error code: ${e.code}');
      print('Error type: ${e.type}');
      print('Response: ${e.response}');

      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred while creating expense user',
          st,
        ),
      );
    } catch (e, st) {
      print('General error creating expense user: $e');
      print('Stack trace: $st');
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
      print('Fetching users with IDs: $userIds');

      // Fetch users one by one since we can't query multiple IDs at once
      List<Document> allUsers = [];
      for (String id in userIds) {
        try {
          final document = await _db.getDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.usersCollection,
            documentId: id,
          );
          allUsers.add(document);
        } catch (e) {
          print('Error fetching user $id: $e');
          // Continue with other users even if one fails
          continue;
        }
      }

      print('Found users: ${allUsers.map((d) => d.$id).toList()}');
      return allUsers;
    } catch (e) {
      print('Error fetching users: $e');
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

  Future<List<Document>> getExpenseUsers(String expenseId) async {
    try {
      print('Fetching expense users for expense: $expenseId');
      final document = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.expenseUserCollection,
        queries: [
          Query.equal('expenseId', expenseId),
        ],
      );
      print('Found ${document.documents.length} expense users');
      return document.documents;
    } catch (e) {
      print('Error fetching expense users: $e');
      return [];
    }
  }

  FutureEither<bool> updateExpenseUser(Map updateExpenseUserData) async {
    try {
      print('Updating expense user in Appwrite:');
      print('Document ID: ${updateExpenseUserData["\$id"]}');
      print('Update data: $updateExpenseUserData');

      final document = await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.expenseUserCollection,
        documentId: updateExpenseUserData["\$id"],
        data: updateExpenseUserData,
      );

      print('Successfully updated expense user:');
      print('Document ID: ${document.$id}');
      print('Updated At: ${document.$updatedAt}');
      print('Data: ${document.data}');

      return right(true);
    } on AppwriteException catch (e, st) {
      print('Appwrite error updating expense user:');
      print('Error message: ${e.message}');
      print('Error code: ${e.code}');
      print('Error type: ${e.type}');
      print('Response: ${e.response}');

      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      print('General error updating expense user: $e');
      return left(Failure(e.toString(), st));
    }
  }
}
