import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';

import 'package:dongi/shared/types/type_defs.dart';

class SaveUserDataUseCase {
  final UserRepository repository;

  SaveUserDataUseCase(this.repository);

  FutureEither<UserModel?> execute({
    required String email,
    required String id,
  }) async {
    final user = UserModel(
      id: id,
      email: email,
    );
    return repository.saveUserData(user);
  }
}
