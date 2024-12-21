import 'package:appwrite/models.dart';
import 'package:dongi/modules/group/domain/repository/group_repository.dart';

class GetCurrentUserLatestGroup {
  final GroupRepository groupRepository;

  GetCurrentUserLatestGroup(this.groupRepository);

  Future<List<Document>> execute(String uid, {int limit = 3}) async {
    return await groupRepository.getCurrentUserLatestGroup(uid, limit: limit);
  }
}
