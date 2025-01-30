import 'package:dongi/modules/auth/domain/models/user_model.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';

class GetUserDataUseCase {
  final UserRepository _userRepository;

  GetUserDataUseCase(this._userRepository);

  Future<UserModel?> execute(String uid) async {
    return await _userRepository.getUserDataById(uid);
  }
}
