import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:dongi/core/constants/appwrite_config.dart';
import 'package:dongi/shared/types/failure.dart';
import 'package:dongi/shared/types/type_defs.dart';
import 'package:dongi/modules/auth/domain/models/user_model.dart';
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
      return UserModel.fromJson(user.toMap());
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
  FutureEitherVoid saveUserData(UserModel userModel, String authUid) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: authUid,
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
  Future<UserModel> getUserData(String uid) async {
    final document = await _db.getDocument(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.usersCollection,
      documentId: uid,
    );

    final updatedUser = UserModel.fromJson(document.data);
    return updatedUser;
  }

  @override
  Future<List<UserModel>> getUsersListData(List<String> userIds) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.usersCollection,
      queries: [
        Query.equal('\$id', userIds),
      ],
    );

    return document.documents
        .map((user) => UserModel.fromJson(user.data))
        .toList();
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
  FutureEitherVoid updateUsername(
      {required String userId, required String username}) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollection,
        documentId: userId,
        data: {'username': username},
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
}
