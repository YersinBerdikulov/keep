import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/shared/utilities/helpers/snackbar_helper.dart';
import 'package:dongi/core/router/router_names.dart';
import 'package:dongi/modules/friend/domain/di/friend_controller_di.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:dongi/shared/widgets/drawer/drawer_widget.dart';
import 'package:dongi/shared/widgets/floating_action_button/floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../widgets/friends_list_widget.dart';

class FriendsListPage extends HookConsumerWidget {
  const FriendsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendList = ref.watch(getFriendProvider);
    final tabController = useTabController(initialLength: 3);
    final currentUser = ref.watch(currentUserProvider);

    /// Listening to changes in the groupNotifierProvider without rebuilding the UI
    ref.listen<AsyncValue<List<UserFriendModel>>>(
      friendNotifierProvider,
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
      backgroundColor: ColorConfig.white,
      floatingActionButton: FABWidget(
        title: "Add Friend",
        onPressed: () => context.push(RouteName.addFriend),
      ),
      appBar: AppBarWidget(
        title: "Friends",
      ),
      drawer: const DrawerWidget(),
      body: friendList.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (data) => Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorConfig.white,
                border: Border(
                  bottom: BorderSide(
                    color: ColorConfig.baseGrey,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: tabController,
                labelColor: ColorConfig.midnight,
                unselectedLabelColor: ColorConfig.primarySwatch50,
                indicatorColor: ColorConfig.midnight,
                indicatorWeight: 3,
                labelStyle: FontConfig.body2().copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: FontConfig.body2(),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_outline, size: 20),
                        const SizedBox(width: 8),
                        const Text('Friends'),
                        if (data.where((e) => e.status == FriendRequestStatus.accepted).isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: ColorConfig.midnight.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              data.where((e) => e.status == FriendRequestStatus.accepted).length.toString(),
                              style: FontConfig.caption().copyWith(
                                color: ColorConfig.midnight,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.pending_outlined, size: 20),
                        const SizedBox(width: 8),
                        const Text('Pending'),
                        if (data.where((e) => e.status == FriendRequestStatus.pending && e.sendRequestUserId == currentUser?.id).isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: ColorConfig.midnight.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              data.where((e) => e.status == FriendRequestStatus.pending && e.sendRequestUserId == currentUser?.id).length.toString(),
                              style: FontConfig.caption().copyWith(
                                color: ColorConfig.midnight,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mail_outline, size: 20),
                        const SizedBox(width: 8),
                        const Text('Incoming'),
                        if (data.where((e) => e.status == FriendRequestStatus.pending && e.receiveRequestUserId == currentUser?.id).isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: ColorConfig.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              data.where((e) => e.status == FriendRequestStatus.pending && e.receiveRequestUserId == currentUser?.id).length.toString(),
                              style: FontConfig.caption().copyWith(
                                color: ColorConfig.error,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  FriendListView(data),
                  PendingListView(data),
                  IncomingListView(data),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
