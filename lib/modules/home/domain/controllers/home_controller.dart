import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:dongi/modules/group/domain/usecases/get_current_user_latest_group_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeNotifier extends AsyncNotifier<List<GroupModel>> {
  // late final HomeRepository _homeRepository;
  late final GetCurrentUserLatestGroup _currentUserLatestGroup;

  @override
  Future<List<GroupModel>> build() async {
    // _homeRepository = ref.watch(homeAPIProvider);
    return getLatestGroupsInHome();
  }

  Future<List<GroupModel>> getLatestGroupsInHome() async {
    final user = ref.read(currentUserProvider);
    final groupList = await _currentUserLatestGroup.execute(user!.id!);
    return groupList.map((group) => GroupModel.fromJson(group.data)).toList();
  }
}
