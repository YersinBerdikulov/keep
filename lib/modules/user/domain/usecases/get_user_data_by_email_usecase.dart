import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';

class GetUserDataByEmailUseCase {
  final UserRepository _userRepository;

  GetUserDataByEmailUseCase(this._userRepository);

  Future<UserModel?> execute(String email) async {
    return await _userRepository.getUserDataByEmail(email);
  }
}
