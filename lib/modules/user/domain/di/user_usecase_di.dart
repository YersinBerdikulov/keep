import 'package:dongi/modules/user/data/di/user_di.dart';
import 'package:dongi/modules/user/domain/usecases/get_group_member_usecase.dart';
import 'package:dongi/modules/user/domain/usecases/get_user_data_by_email_usecase.dart';
import 'package:dongi/modules/user/domain/usecases/get_user_data_usecase.dart';
import 'package:dongi/modules/user/domain/usecases/save_user_data_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getUserDataUseCaseProvider = Provider<GetUserDataUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUserDataUseCase(repository);
});

final getGroupMembersUseCaseProvider = Provider<GetGroupMembersUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return GetGroupMembersUseCase(userRepository);
});

final getUserDataByEmailUseCaseProvider =
    Provider<GetUserDataByEmailUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUserDataByEmailUseCase(repository);
});

final saveUserDataUseCaseProvider = Provider<SaveUserDataUseCase>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return SaveUserDataUseCase(repository);
});
