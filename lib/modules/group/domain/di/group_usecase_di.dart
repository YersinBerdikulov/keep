import 'package:dongi/modules/group/data/di/group_di.dart';
import 'package:dongi/modules/group/domain/usecases/get_current_user_latest_group_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final getUserDataUseCaseProvider = Provider<GetCurrentUserLatestGroup>((ref) {
  final repository = ref.read(groupRepositoryProvider);
  return GetCurrentUserLatestGroup(repository);
});
