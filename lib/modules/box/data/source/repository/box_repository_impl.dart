import 'package:appwrite/models.dart';
import 'package:dongi/core/types/type_defs.dart';
import 'package:dongi/modules/box/data/source/network/box_remote_data_source.dart';
import 'package:dongi/modules/box/domain/models/box_model.dart';
import 'package:dongi/modules/box/domain/repository/box_repository.dart';

class BoxRepositoryImpl implements BoxRepository {
  final BoxRemoteDataSource _remoteDataSource;

  BoxRepositoryImpl({required BoxRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  FutureEither<Document> addBox(BoxModel boxModel) {
    return _remoteDataSource.addBox(boxModel);
  }

  @override
  FutureEither<bool> deleteAllBox(List<String> ids) {
    return _remoteDataSource.deleteAllBox(ids);
  }

  @override
  FutureEither<bool> deleteBox(String id) {
    return _remoteDataSource.deleteBox(id);
  }

  @override
  Future<Document> getBoxDetail(String boxId) {
    return _remoteDataSource.getBoxDetail(boxId);
  }

  @override
  Future<List<Document>> getBoxes(String uid) {
    return _remoteDataSource.getBoxes(uid);
  }

  @override
  Future<List<Document>> getBoxesInGroup(String groupId) {
    return _remoteDataSource.getBoxesInGroup(groupId);
  }

  @override
  Future<List<Document>> getCurrentUserBoxes(String uid) {
    return _remoteDataSource.getCurrentUserBoxes(uid);
  }

  @override
  Future<List<Document>> getUsersInBox(List<String> userIds) {
    return _remoteDataSource.getUsersInBox(userIds);
  }

  @override
  FutureEither<Document> updateBox(BoxModel updateBoxModel) {
    return _remoteDataSource.updateBox(updateBoxModel);
  }
}
