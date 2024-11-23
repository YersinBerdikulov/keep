import 'package:appwrite/models.dart';
import 'package:dongi/core/types/type_defs.dart';
import 'package:dongi/modules/box/domain/models/box_model.dart';

abstract class BoxRepository {
  FutureEither<Document> addBox(BoxModel boxModel);
  FutureEither<Document> updateBox(Map<String, dynamic> updateBoxModel);
  Future<List<Document>> getBoxes(String uid);
  Future<List<Document>> getBoxesInGroup(String groupId);
  Future<Document> getBoxDetail(String boxId);
  Future<List<Document>> getUsersInBox(List<String> userIds);
  Future<List<Document>> getCurrentUserBoxes(String uid);
  FutureEither<bool> deleteBox(String id);
  FutureEither<bool> deleteAllBox(List<String> ids);
}
