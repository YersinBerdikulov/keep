import 'package:appwrite/models.dart';
import 'package:dongi/core/types/failure.dart';
import 'package:dongi/modules/group/data/source/network/group_remote_data_source.dart';
import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:dongi/modules/group/domain/repository/group_repository.dart';
import 'package:fpdart/fpdart.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource _remoteDataSource;

  GroupRepositoryImpl({required GroupRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, Document>> addGroup(GroupModel groupModel) {
    return _remoteDataSource.addGroup(groupModel);
  }

  @override
  Future<Either<Failure, Document>> updateGroup(Map updateGroupModel) {
    return _remoteDataSource.updateGroup(updateGroupModel);
  }

  @override
  Future<Either<Failure, bool>> deleteGroup(String id) {
    return _remoteDataSource.deleteGroup(id);
  }

  @override
  Future<List<Document>> getGroups(String uid) {
    return _remoteDataSource.getGroups(uid);
  }

  @override
  Future<List<Document>> getUsersInGroup(List<String> userIds) {
    return _remoteDataSource.getUsersInGroup(userIds);
  }

  @override
  Future<Document> getGroupDetail(String uid, String groupId) {
    return _remoteDataSource.getGroupDetail(groupId);
  }
}
