import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../../core/router/router_notifier.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../../../shared/widgets/floating_action_button/floating_action_button.dart';
import '../../domain/di/group_controller_di.dart';
import '../widgets/group_list_widget.dart';

class GroupListPage extends ConsumerWidget {
  const GroupListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final controller = useState<PanelController>(PanelController());
    final groupList = ref.watch(groupNotifierProvider);

    /// Listening to changes in the groupNotifierProvider without rebuilding the UI
    ref.listen<AsyncValue<List<GroupModel>>>(
      groupNotifierProvider,
      (_, state) {
        state.whenOrNull(
          data: (_) {
            // if (/* condition to refresh */) {
            //   ref.invalidate(getGroupsProvider);
            // }
          },
          error: (error, _) => showSnackBar(context, content: error.toString()),
        );
      },
    );

    return Scaffold(
      appBar: AppBarWidget(title: "Groups"),
      floatingActionButton: FABWidget(
        title: "Group",
        onPressed: () => context.push(RouteName.createGroup),
        //onPressed: () => controller.value.open(),
      ),
      body: groupList.when(
        skipLoadingOnRefresh: false,
        //skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (data) => RefreshIndicator(
          child: GroupListView(data),
          onRefresh: () async => ref.refresh(groupNotifierProvider),
        ),
      ),
    );
    //return Stack(
    //  children: [
    //    Scaffold(
    //      appBar: AppBarWidget(title: "Groups"),
    //      floatingActionButton: FABWidget(
    //        title: "Group",
    //        onPressed: () => controller.value.open(),
    //      ),
    //      body: groupList.when(
    //        skipLoadingOnRefresh: false,
    //        //skipLoadingOnReload: true,
    //        loading: () => const Center(child: CircularProgressIndicator()),
    //        error: (error, stackTrace) => Center(child: Text(error.toString())),
    //        data: (data) => RefreshIndicator(
    //          onRefresh: () async => ref.refresh(getGroupsProvider),
    //          child: GroupListView(data),
    //        ),
    //      ),
    //    ),
    //    SlidingUpPanel(
    //      backdropEnabled: true,
    //      controller: controller.value,
    //      panelSnapping: false,
    //      minHeight: 0,
    //      maxHeight: 700,
    //      borderRadius: const BorderRadius.only(
    //        topLeft: Radius.circular(16),
    //        topRight: Radius.circular(16),
    //      ),
    //      panel: CreateGroupPage(),
    //    ),
    //  ],
    //);
  }
}
