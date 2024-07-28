import 'package:dongi/app/friends/controller/friend_controller.dart';
import 'package:dongi/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/color_config.dart';
import '../../../widgets/appbar/appbar.dart';
import 'friends_list_widget.dart';

class FriendsListPage extends ConsumerWidget {
  const FriendsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendList = ref.watch(getFriendProvider);

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
      appBar: AppBarWidget(title: 'Friends List'),
      body: friendList.when(
        skipLoadingOnRefresh: false,
        //skipLoadingOnReload: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (data) => RefreshIndicator(
          child: FriendListView(data),
          onRefresh: () async => ref.refresh(getFriendProvider),
        ),
      ),
    );
  }
}
