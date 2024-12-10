import 'package:dongi/modules/user/data/di/user_di.dart';
import 'package:dongi/modules/user/domain/usecases/get_user_data_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getUserDataUseCaseProvider = Provider<GetUserDataUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUserDataUseCase(repository);
});
