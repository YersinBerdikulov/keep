import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../../../shared/widgets/floating_action_button/floating_action_button.dart';
import '../../domain/di/group_controller_di.dart';
import '../widgets/group_list_widget.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../modules/home/domain/di/home_controller_di.dart';

class GroupListPage extends ConsumerStatefulWidget {
  const GroupListPage({super.key});

  @override
  ConsumerState<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends ConsumerState<GroupListPage> {
  @override
  void initState() {
    super.initState();
    // Refresh data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshData();
    });
  }

  void refreshData() {
    // Invalidate and refresh providers
    ref.invalidate(groupNotifierProvider);
    ref.invalidate(homeNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    final groupList = ref.watch(groupNotifierProvider);

    /// Listening to changes in the groupNotifierProvider without rebuilding the UI
    ref.listen<AsyncValue<List<GroupModel>>>(
      groupNotifierProvider,
      (_, state) {
        state.whenOrNull(
          data: (_) {
            // Data loaded successfully
          },
          error: (error, _) => showSnackBar(context, content: error.toString()),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConfig.baseGrey,
              ),
              child: Icon(
                Icons.arrow_back,
                color: ColorConfig.midnight,
                size: 20,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: Text(
          "Groups",
          style: TextStyle(
            color: ColorConfig.midnight,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorConfig.baseGrey,
              ),
              child: Icon(
                Icons.refresh,
                color: ColorConfig.midnight,
                size: 20,
              ),
            ),
            onPressed: refreshData,
            tooltip: 'Refresh data',
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FABWidget(
        title: "Group",
        onPressed: () => context.push(RouteName.createGroup),
      ),
      body: groupList.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (data) => RefreshIndicator(
          child: GroupListView(data),
          onRefresh: () async {
            refreshData();
          },
        ),
      ),
    );
  }
}
