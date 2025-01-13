import 'package:dongi/models/user_friend_model.dart';
import 'package:dongi/core/utilities/helpers/snackbar_helper.dart';
import 'package:dongi/core/router/router_notifier.dart';
import 'package:dongi/modules/friend/domain/di/friend_controller_di.dart';
import 'package:dongi/widgets/floating_action_button/floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../widgets/friends_list_widget.dart';

class FriendsListPage extends HookConsumerWidget {
  const FriendsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendList = ref.watch(getFriendProvider);
    final tabController = useTabController(initialLength: 3);

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
          error: (error, _) => showSnackBar(context, error.toString()),
        );
      },
    );

    return Scaffold(
      backgroundColor: ColorConfig.white,
      floatingActionButton: FABWidget(
        title: "Add Friend",
        onPressed: () => context.push(RouteName.addFriend),
      ),
      appBar: AppBar(
        title: const Text('Friend List'),
        bottom: TabBar(
          indicatorColor: ColorConfig.baseGrey,
          controller: tabController,
          tabs: const [
            Tab(text: 'Friends'),
            Tab(text: 'Pending'),
            Tab(text: 'Incoming'),
          ],
        ),
      ),
      body: friendList.when(
        skipLoadingOnRefresh: false,
        //skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (data) => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TabBarView(
            controller: tabController,
            children: [
              FriendListView(data),
              PendingListView(data),
              IncomingListView(data),
            ],
          ),
        ),
      ),
    );
  }
}
