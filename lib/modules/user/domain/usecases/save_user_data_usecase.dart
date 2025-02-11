import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';

import 'package:dongi/shared/types/type_defs.dart';

class SaveUserDataUseCase {
  final UserRepository repository;

  SaveUserDataUseCase(this.repository);

  FutureEither<UserModel?> execute({required String email}) async {
    final user = UserModel(email: email);
    return repository.saveUserData(user);
  }
}
