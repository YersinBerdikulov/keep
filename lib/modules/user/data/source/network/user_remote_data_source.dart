import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:dongi/core/constants/appwrite_config.dart';
import 'package:dongi/shared/types/failure.dart';
import 'package:dongi/shared/types/type_defs.dart';
import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/user/data/source/repository/user_repository_impl.dart';
import 'package:fpdart/fpdart.dart';

class UserRemoteDataSource implements UserRepositoryImpl {
  final Databases _db;
  final Account _account;

  UserRemoteDataSource({
    required Databases db,
    required Account account,
  })  : _db = db,
        _account = account;

  @override
  Future<UserModel> getCurrentUserData() async {
    try {
      final user = await _account.get();

      // Try to get existing user document
      try {
        final document = await _db.getDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.usersCollection,
          documentId: user.$id,
        );
        return UserModel.fromJson(document.data);
      } catch (e) {
        // If document doesn't exist, create it
        final userModel = UserModel(
          id: user.$id,
          email: user.email,
          userName: user.name,
          phoneNumber: user.phone,
        );

        final document = await _db.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.usersCollection,
          documentId: user.$id,
          data: userModel.toJson(),
        );

        return UserModel.fromJson(document.data);
      }
    } on AppwriteException catch (e, st) {
      throw Failure(
        e.message ?? 'Failed to fetch current user data.',
        st,
      );
    } catch (e, st) {
      throw Failure(e.toString(), st);
    }
  }

  @override
  FutureEither<UserModel?> saveUserData(UserModel userModel) async {
    try {
      if (userModel.id == null) {
        throw Failure('User ID is required', StackTrace.current);
      }

      // First try to get the existing document
      try {
        final existingDoc = await _db.getDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.usersCollection,
          documentId: userModel.id!,
        );

        // If document exists, update it
        final updatedDoc = await _db.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.usersCollection,
          documentId: userModel.id!,
          data: userModel.toJson(),
        );

        return right(UserModel.fromJson(updatedDoc.data));
      } catch (e) {
        // If document doesn't exist, create it
        final document = await _db.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.usersCollection,
          documentId: userModel.id!,
          data: userModel.toJson(),
        );

        return right(UserModel.fromJson(document.data));
      }
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
  Future<UserModel?> getUserDataById(String uid) async {
    final document = await _db.getDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.usersCollection,
      documentId: uid,
    );

    final user = UserModel.fromJson(document.data);
    return user;
  }

  @override
  Future<UserModel?> getUserDataByEmail(String email) async {
    try {
      final document = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        queries: [
          Query.equal('email', email),
        ],
      );

      if (document.documents.isEmpty) {
        return null;
      }

      final user = UserModel.fromJson(document.documents.first.data);
      return user;
    } on AppwriteException catch (e, st) {
      throw Failure(
        e.message ?? 'Failed to fetch user data by email.',
        st,
      );
    } catch (e, st) {
      throw Failure(e.toString(), st);
    }
  }

  @override
  Future<List<UserModel>> getUsersListData(List<String> userIds) async {
    if (userIds.isEmpty) {
      return [];
    }

    try {
      // Fetch users one by one since Appwrite doesn't support querying multiple IDs with equality
      List<UserModel> users = [];
      
      for (String userId in userIds) {
        try {
          final document = await _db.getDocument(
            databaseId: AppwriteConfig.databaseId,
            collectionId: AppwriteConfig.usersCollection,
            documentId: userId,
          );
          
          users.add(UserModel.fromJson(document.data));
        } catch (e) {
          print('Error fetching user with ID $userId: $e');
          // Continue with next user
        }
      }
      
      print('Found ${users.length} users out of ${userIds.length} requested');
      return users;
    } catch (e) {
      print('Error in getUsersListData: $e');
      return [];
    }
  }

  @override
  Future<List<UserModel>> searchUserByName(String name) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.usersCollection,
      queries: [
        Query.search('name', name),
      ],
    );

    return document.documents
        .map((user) => UserModel.fromJson(user.data))
        .toList();
  }

  @override
  FutureEitherVoid updateUserData(UserModel userModel) async {
    try {
      if (userModel.id == null) {
        throw Failure('User ID is required', StackTrace.current);
      }

      // First try to get the existing document to ensure it exists
      try {
        await _db.getDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.usersCollection,
          documentId: userModel.id!,
        );
      } catch (e) {
        // If document doesn't exist, create it
        await _db.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.usersCollection,
          documentId: userModel.id!,
          data: userModel.toJson(),
        );
        return right(null);
      }

      // If document exists, update it
      await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: userModel.id!,
        data: userModel.toJson(),
      );
      return right(null);
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
  FutureEitherVoid updateUsername({
    required String userId,
    required String username,
  }) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: userId,
        data: {
          'userName': username,
        },
      );

      return right(null);
    } on AppwriteException catch (e, st) {
      print('Error updating username: $e');
      return left(Failure(e.message ?? 'Unknown error', st));
    } catch (e, st) {
      print('Unexpected error updating username: $e');
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    // Check if the user IDs might be truncated
    if (userIds.isNotEmpty && userIds.any((id) => id.length < 30)) {
      print('Detected potentially truncated IDs. Trying to find matching users...');
      return _getUsersByTruncatedIds(userIds);
    }
    
    // Reuse the getUsersListData method for full IDs
    return getUsersListData(userIds);
  }
  
  // Method to handle truncated user IDs by fetching all users and matching by prefix
  Future<List<UserModel>> _getUsersByTruncatedIds(List<String> truncatedIds) async {
    try {
      // Fetch all users (limit to 100 for performance)
      final document = await _db.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        queries: [Query.limit(100)],
      );
      
      if (document.documents.isEmpty) {
        print('No users found in database');
        return [];
      }
      
      // Convert to UserModel objects
      final allUsers = document.documents.map((doc) => UserModel.fromJson(doc.data)).toList();
      print('Found ${allUsers.length} total users in database');
      
      // Filter users whose IDs start with any of the truncated IDs
      final matchedUsers = allUsers.where((user) {
        if (user.id == null) return false;
        
        return truncatedIds.any((truncatedId) {
          final isMatch = user.id!.startsWith(truncatedId);
          if (isMatch) {
            print('Found matching user for truncated ID $truncatedId: ${user.id}');
          }
          return isMatch;
        });
      }).toList();
      
      print('Matched ${matchedUsers.length} users out of ${truncatedIds.length} truncated IDs');
      return matchedUsers;
    } catch (e) {
      print('Error in _getUsersByTruncatedIds: $e');
      return [];
    }
  }
}
