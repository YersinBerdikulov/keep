import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:dongi/core/constants/appwrite_config.dart';
import 'package:dongi/core/types/failure.dart';
import 'package:dongi/core/types/type_defs.dart';
import 'package:dongi/modules/user/data/source/repository/user_repository_impl.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../auth/domain/models/user_model.dart';

class UserRemoteDataSource implements UserRepositoryImpl {
  final Databases _db;
  // final Realtime _realtime;
  UserRemoteDataSource({
    required Databases db,
    // required Realtime realtime,
  }) :
        //  _realtime = realtime,
        _db = db;

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

  // @override
  // Stream<RealtimeMessage> getLatestUserProfileData() {
  //   return _realtime.subscribe([
  //     'databases.${AppwriteConfig.databaseId}.collections.${AppwriteConfig.usersCollection}.documents'
  //   ]).stream;
  // }

  @override
  FutureEitherVoid followUser(UserModel user) {
    throw UnimplementedError();
  }
}
