import 'package:dongi/app/friends/controller/friend_controller.dart';
import 'package:dongi/core/utils.dart';
import 'package:dongi/router/router_notifier.dart';
import 'package:dongi/widgets/floating_action_button/floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/color_config.dart';
import 'friends_list_widget.dart';

class FriendsListPage extends HookConsumerWidget {
  const FriendsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendList = ref.watch(getFriendProvider);
    final tabController = useTabController(initialLength: 3);

    /// by using listen we are not gonna rebuild our app
    ref.listen<FriendState>(
      friendNotifierProvider,
      (previous, next) {
        next.whenOrNull(
          loaded: () => ref.refresh(getFriendProvider),
          error: (message) {
            showSnackBar(context, message);
          },
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
        data: (data) => RefreshIndicator(
          onRefresh: () async => ref.refresh(getFriendProvider),
          child: Padding(
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
      ),
    );
  }
}
