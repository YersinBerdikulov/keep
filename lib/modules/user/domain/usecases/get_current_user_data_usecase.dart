import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';

class GetCurrentUserDataUseCase {
  final UserRepository _userRepository;

  GetCurrentUserDataUseCase(this._userRepository);

  Future<UserModel> execute() async {
    return await _userRepository.getCurrentUserData();
  }
}
