import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/appbar/sliver_appbar.dart';
import '../../../../shared/widgets/error/error.dart';
import '../../../../shared/widgets/floating_action_button/floating_action_button.dart';
import '../../../../shared/widgets/loading/loading.dart';
import '../../domain/di/group_controller_di.dart';
import '../widgets/group_detail_widget.dart';

class GroupDetailPage extends HookConsumerWidget {
  final String groupId;
  const GroupDetailPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use hook to track if we've already refreshed to prevent loops
    final hasRefreshed = useState(false);
    final isManualRefresh = useState(false);

    // Watch the group detail provider
    final groupDetail = ref.watch(groupDetailProvider(groupId));

    // One-time refresh when the page is first loaded
    useEffect(() {
      if (!hasRefreshed.value) {
        // Mark as refreshed to prevent loops
        hasRefreshed.value = true;

        // Only invalidate the cache if coming from navigation, not from a refresh
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Refresh once on load
          ref.invalidate(groupDetailProvider(groupId));
        });
      }
      return null;
    }, []);

    // Refresh function that can be called manually
    void manualRefresh() {
      if (!isManualRefresh.value) {
        isManualRefresh.value = true;

        // Show a snackbar to indicate refresh
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Refreshing data...'),
            duration: Duration(seconds: 1),
          ),
        );

        // Invalidate the cache to force a refresh
        ref.invalidate(groupDetailProvider(groupId));

        // Reset the manual refresh flag after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            isManualRefresh.value = false;
          }
        });
      }
    }

    // Listen for changes but be careful not to cause loops
    ref.listen<AsyncValue<void>>(
      groupNotifierProvider,
      (previous, next) {
        next.whenOrNull(
          data: (_) {
            if (!isManualRefresh.value) {
              showSnackBar(context, content: "Successfully Updated!");
            }
          },
          error: (error, stackTrace) {
            showSnackBar(context, content: error.toString());
          },
        );
      },
    );

    return groupDetail.when(
      loading: () => const LoadingWidget(),
      error: (error, stackTrace) => ErrorTextWidget(error),
      data: (data) {
        return Scaffold(
          body: Stack(
            children: [
              SliverAppBarWidget(
                height: 200,
                appbarTitle: GroupDetailTitle(groupName: data.title),
                image: data.image,
                child: RefreshIndicator(
                  onRefresh: () async {
                    manualRefresh();
                  },
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      GroupDetailInfo(groupModel: data),
                      GroupDetailFriendList(
                        userIds: data.groupUsers,
                        groupModel: data,
                      ),
                      GroupDetailBoxGrid(groupModel: data),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              // Refresh button in top-right corner
              Positioned(
                top: 40,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConfig.baseGrey.withOpacity(0.5),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: manualRefresh,
                    tooltip: 'Refresh data',
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FABWidget(
            title: "Box",
            onPressed: () => context.push(
              RouteName.createBox,
              extra: {"groupModel": data},
            ),
          ),
        );
      },
    );
  }
}
