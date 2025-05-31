import 'package:appwrite/models.dart';
import 'package:dongi/shared/types/failure.dart';
import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:dongi/modules/group/domain/models/group_user_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class GroupRepository {
  Future<Either<Failure, Document>> addGroup(GroupModel groupModel);
  Future<Either<Failure, Document>> updateGroup(GroupModel groupModel);
  Future<Either<Failure, bool>> deleteGroup(String id);
  Future<List<Document>> getGroups(String uid);
  Future<List<Document>> getUsersInGroup(List<String> userIds);
  Future<Document> getGroupDetail(String uid, String groupId);
  Future<List<Document>> getCurrentUserLatestGroup(String uid, {int limit = 3});
  
  // Group users management
  Future<List<Document>> getGroupUsers(String groupId);
  Future<Either<Failure, Document>> addGroupUser(GroupUserModel groupUserModel);
  Future<Either<Failure, Document>> updateGroupUser(GroupUserModel groupUserModel);
  Future<Either<Failure, bool>> deleteGroupUser(String id);
}
