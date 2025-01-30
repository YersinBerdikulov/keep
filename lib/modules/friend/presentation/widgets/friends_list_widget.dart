import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/shared/utilities/extensions/date_extension.dart';
import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/friend/domain/di/friend_controller_di.dart';
import 'package:dongi/shared/widgets/dialog/dialog_widget.dart';
import 'package:dongi/shared/widgets/image/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/font_config.dart';
import '../../../../shared/widgets/list_tile/list_tile_card.dart';

class FriendListView extends ConsumerWidget {
  final List<UserFriendModel> userFriendModels;

  const FriendListView(this.userFriendModels, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(getFriendProvider),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SlidableAutoCloseBehavior(
          child: ListView(
            children: userFriendModels
                .where(
                    (element) => element.status == FriendRequestStatus.accepted)
                .map<Widget>((userFriend) => UserFriendListCard(userFriend))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class PendingListView extends ConsumerWidget {
  final List<UserFriendModel> pendingFriendModels;

  const PendingListView(this.pendingFriendModels, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(getFriendProvider),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SlidableAutoCloseBehavior(
          child: ListView(
            children: pendingFriendModels
                .where((element) =>
                    element.status == FriendRequestStatus.pending &&
                    element.sendRequestUserId == currentUser!.id)
                .map<Widget>(
                    (pendingFriend) => PendingFriendListCard(pendingFriend))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class IncomingListView extends ConsumerWidget {
  final List<UserFriendModel> incomingFriendModels;

  const IncomingListView(this.incomingFriendModels, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(getFriendProvider),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: SlidableAutoCloseBehavior(
          child: ListView(
            children: incomingFriendModels
                .where((element) =>
                    element.status == FriendRequestStatus.pending &&
                    element.receiveRequestUserId == currentUser!.id)
                .map<Widget>(
                    (incomingFriend) => IncomingFriendListCard(incomingFriend))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class UserFriendListCard extends StatelessWidget {
  final UserFriendModel userFriendModel;
  const UserFriendListCard(this.userFriendModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTileCard(
          titleString: userFriendModel.receiveRequestUserName ??
              userFriendModel.receiveRequestUserId,
          leading: ImageWidget(
            imageUrl: userFriendModel.receiveRequestProfilePic,
            borderRadius: 10,
            width: 50,
            height: 50,
          ),
          trailing: Text(
            "Friend from ${userFriendModel.createdAt!.toHumanReadableFormat()}",
            style: FontConfig.body2(),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class PendingFriendListCard extends StatelessWidget {
  final UserFriendModel userFriendModel;
  const PendingFriendListCard(this.userFriendModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTileCard(
          titleString: userFriendModel.receiveRequestUserName ??
              userFriendModel.receiveRequestUserId,
          leading: ImageWidget(
            imageUrl: userFriendModel.receiveRequestProfilePic,
            borderRadius: 10,
            width: 50,
            height: 50,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sent at',
                style: FontConfig.caption(),
              ),
              Text(
                userFriendModel.createdAt!.toHumanReadableFormat(),
                style: FontConfig.caption(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class IncomingFriendListCard extends ConsumerWidget {
  final UserFriendModel userFriendModel;
  const IncomingFriendListCard(this.userFriendModel, {super.key});

  Widget actionIcon({
    required Color color,
    required IconData icon,
    required onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(
          icon,
          color: ColorConfig.darkGrey,
          size: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTileCard(
          titleString: userFriendModel.sendRequestUserName ??
              userFriendModel.sendRequestUserId,
          leading: ImageWidget(
            imageUrl: userFriendModel.sendRequestProfilePic,
            borderRadius: 10,
            width: 50,
            height: 50,
          ),
          trailing: SizedBox(
            width: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                actionIcon(
                  color: ColorConfig.error,
                  icon: Icons.remove,
                  onTap: () {
                    showCustomBottomDialog(
                      context,
                      title: "Reject Friend Request",
                      description:
                          "Are you sure you want to reject friend request from ${userFriendModel.sendRequestUserName}?",
                      onConfirm: () => ref
                          .read(friendNotifierProvider.notifier)
                          .rejectFriendRequest(userFriendModel),
                    );
                  },
                ),
                actionIcon(
                  color: ColorConfig.secondary,
                  icon: Icons.check,
                  onTap: () {
                    showCustomBottomDialog(
                      context,
                      title: "Accept Friend Request",
                      description:
                          "Are you sure you want to accept friend request from ${userFriendModel.sendRequestUserName}?",
                      onConfirm: () => ref
                          .read(friendNotifierProvider.notifier)
                          .acceptFriendRequest(userFriendModel),
                    );
                  },
                ),
              ],
            ),
          ),

          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       'Received at',
          //       style: FontConfig.caption(),
          //     ),
          //     Text(
          //       userFriendModel.createdAt!.toHumanReadableFormat(),
          //       style: FontConfig.caption(),
          //     ),
          //   ],
          // ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
