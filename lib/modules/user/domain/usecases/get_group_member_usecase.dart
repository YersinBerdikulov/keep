import 'package:dongi/modules/auth/domain/models/user_model.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';

class GetGroupMembersUseCase {
  final UserRepository userRepository;

  GetGroupMembersUseCase(this.userRepository);

  Future<List<UserModel>> execute(List<String> userIds) async {
    // Fetch the user data based on user IDs
    return await userRepository.getUsersListData(userIds);
  }
}
