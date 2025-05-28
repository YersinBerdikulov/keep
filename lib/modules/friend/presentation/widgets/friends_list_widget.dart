import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/shared/utilities/extensions/date_extension.dart';
import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/friend/domain/di/friend_controller_di.dart';
import 'package:dongi/shared/widgets/dialog/dialog_widget.dart';
import 'package:dongi/shared/widgets/image/image_widget.dart';
import 'package:dongi/shared/utilities/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/font_config.dart';
import '../../../../shared/widgets/list_tile/list_tile_card.dart';

class FriendListView extends ConsumerWidget {
  final List<UserFriendModel> userFriendModels;

  const FriendListView(this.userFriendModels, {super.key});

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConfig.primarySwatch.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline,
                size: 48,
                color: ColorConfig.primarySwatch,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Friends Yet',
              style: FontConfig.h6().copyWith(
                color: ColorConfig.midnight,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add friends to start sharing expenses together',
              textAlign: TextAlign.center,
              style: FontConfig.body2().copyWith(
                color: ColorConfig.primarySwatch50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<List<UserFriendModel>>>(
      friendNotifierProvider,
      (_, state) {
        state.whenOrNull(
          data: (_) {
            ref.refresh(getFriendProvider);
          },
          error: (error, _) => showSnackBar(context, content: error.toString()),
        );
      },
    );

    final acceptedFriends = userFriendModels
        .where((element) => element.status == FriendRequestStatus.accepted)
        .toList();

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(getFriendProvider),
      child: acceptedFriends.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SlidableAutoCloseBehavior(
                child: ListView.builder(
                  itemCount: acceptedFriends.length,
                  itemBuilder: (context, index) => UserFriendListCard(acceptedFriends[index]),
                ),
              ),
            ),
    );
  }
}

class PendingListView extends ConsumerWidget {
  final List<UserFriendModel> pendingFriendModels;

  const PendingListView(this.pendingFriendModels, {super.key});

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConfig.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.pending_outlined,
                size: 48,
                color: ColorConfig.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Pending Requests',
              style: FontConfig.h6().copyWith(
                color: ColorConfig.midnight,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Friend requests you\'ve sent will appear here',
              textAlign: TextAlign.center,
              style: FontConfig.body2().copyWith(
                color: ColorConfig.primarySwatch50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<List<UserFriendModel>>>(
      friendNotifierProvider,
      (_, state) {
        state.whenOrNull(
          data: (_) {
            ref.refresh(getFriendProvider);
          },
          error: (error, _) => showSnackBar(context, content: error.toString()),
        );
      },
    );

    final currentUser = ref.watch(currentUserProvider);
    final pendingRequests = pendingFriendModels
        .where((element) =>
            element.status == FriendRequestStatus.pending &&
            element.sendRequestUserId == currentUser!.id)
        .toList();

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(getFriendProvider),
      child: pendingRequests.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SlidableAutoCloseBehavior(
                child: ListView.builder(
                  itemCount: pendingRequests.length,
                  itemBuilder: (context, index) =>
                      PendingFriendListCard(pendingRequests[index]),
                ),
              ),
            ),
    );
  }
}

class IncomingListView extends ConsumerWidget {
  final List<UserFriendModel> incomingFriendModels;

  const IncomingListView(this.incomingFriendModels, {super.key});

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConfig.primarySwatch.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mail_outline,
                size: 48,
                color: ColorConfig.primarySwatch,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Incoming Requests',
              style: FontConfig.h6().copyWith(
                color: ColorConfig.midnight,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Friend requests sent to you will appear here',
              textAlign: TextAlign.center,
              style: FontConfig.body2().copyWith(
                color: ColorConfig.primarySwatch50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<List<UserFriendModel>>>(
      friendNotifierProvider,
      (_, state) {
        state.whenOrNull(
          data: (_) {
            ref.refresh(getFriendProvider);
          },
          error: (error, _) => showSnackBar(context, content: error.toString()),
        );
      },
    );

    final currentUser = ref.watch(currentUserProvider);
    final incomingRequests = incomingFriendModels
        .where((element) =>
            element.status == FriendRequestStatus.pending &&
            element.receiveRequestUserId == currentUser!.id)
        .toList();

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(getFriendProvider),
      child: incomingRequests.isEmpty
          ? _buildEmptyState()
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SlidableAutoCloseBehavior(
                child: ListView.builder(
                  itemCount: incomingRequests.length,
                  itemBuilder: (context, index) =>
                      IncomingFriendListCard(incomingRequests[index]),
                ),
              ),
            ),
    );
  }
}

class UserFriendListCard extends ConsumerWidget {
  final UserFriendModel userFriendModel;
  const UserFriendListCard(this.userFriendModel, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final isSender = userFriendModel.sendRequestUserId == currentUser?.id;
    
    // Show the other user's name and profile pic
    final friendName = isSender 
        ? userFriendModel.receiveRequestUserName ?? userFriendModel.receiveRequestUserId
        : userFriendModel.sendRequestUserName ?? userFriendModel.sendRequestUserId;
    final friendProfilePic = isSender
        ? userFriendModel.receiveRequestProfilePic
        : userFriendModel.sendRequestProfilePic;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                showCustomBottomDialog(
                  context,
                  title: "Delete Friend",
                  description: "Are you sure you want to remove this friend? This action cannot be undone.",
                  onConfirm: () => ref
                      .read(friendNotifierProvider.notifier)
                      .deleteFriend(userFriendModel),
                );
              },
              backgroundColor: ColorConfig.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ListTileCard(
          titleString: friendName,
          leading: Hero(
            tag: 'friend_${isSender ? userFriendModel.receiveRequestUserId : userFriendModel.sendRequestUserId}',
            child: ImageWidget(
              imageUrl: friendProfilePic,
              borderRadius: 25,
              width: 50,
              height: 50,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorConfig.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  userFriendModel.createdAt!.toHumanReadableFormat(),
                  style: FontConfig.caption().copyWith(
                    color: ColorConfig.secondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    showCustomBottomDialog(
                      context,
                      title: "Delete Friend",
                      description: "Are you sure you want to remove this friend? This action cannot be undone.",
                      onConfirm: () => ref
                          .read(friendNotifierProvider.notifier)
                          .deleteFriend(userFriendModel),
                    );
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: ColorConfig.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: ColorConfig.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Delete',
                          style: FontConfig.caption().copyWith(
                            color: ColorConfig.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PendingFriendListCard extends ConsumerWidget {
  final UserFriendModel userFriendModel;
  const PendingFriendListCard(this.userFriendModel, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTileCard(
        titleString: userFriendModel.receiveRequestUserName ??
            userFriendModel.receiveRequestUserId,
        leading: Hero(
          tag: 'pending_${userFriendModel.receiveRequestUserId}',
          child: ImageWidget(
            imageUrl: userFriendModel.receiveRequestProfilePic,
            borderRadius: 25,
            width: 50,
            height: 50,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: ColorConfig.primarySwatch.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.pending_outlined,
                    size: 16,
                    color: ColorConfig.primarySwatch,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Pending',
                    style: FontConfig.caption().copyWith(
                      color: ColorConfig.primarySwatch,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  showCustomBottomDialog(
                    context,
                    title: "Cancel Friend Request",
                    description: "Are you sure you want to cancel this friend request? This action cannot be undone.",
                    onConfirm: () => ref
                        .read(friendNotifierProvider.notifier)
                        .deleteFriend(userFriendModel),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorConfig.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.close,
                        size: 16,
                        color: ColorConfig.error,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Cancel',
                        style: FontConfig.caption().copyWith(
                          color: ColorConfig.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IncomingFriendListCard extends ConsumerWidget {
  final UserFriendModel userFriendModel;
  const IncomingFriendListCard(this.userFriendModel, {super.key});

  Widget _buildActionButton({
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: FontConfig.caption().copyWith(
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTileCard(
        titleString: userFriendModel.sendRequestUserName ??
            userFriendModel.sendRequestUserId,
        leading: Hero(
          tag: 'incoming_${userFriendModel.sendRequestUserId}',
          child: ImageWidget(
            imageUrl: userFriendModel.sendRequestProfilePic,
            borderRadius: 25,
            width: 50,
            height: 50,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(
              color: ColorConfig.error,
              icon: Icons.close,
              label: 'Decline',
              onTap: () {
                showCustomBottomDialog(
                  context,
                  title: "Decline Friend Request",
                  description:
                      "Are you sure you want to decline the friend request from ${userFriendModel.sendRequestUserName}?",
                  onConfirm: () => ref
                      .read(friendNotifierProvider.notifier)
                      .rejectFriendRequest(userFriendModel),
                );
              },
            ),
            const SizedBox(width: 8),
            _buildActionButton(
              color: ColorConfig.secondary,
              icon: Icons.check,
              label: 'Accept',
              onTap: () {
                showCustomBottomDialog(
                  context,
                  title: "Accept Friend Request",
                  description:
                      "Do you want to accept the friend request from ${userFriendModel.sendRequestUserName}?",
                  onConfirm: () => ref
                      .read(friendNotifierProvider.notifier)
                      .acceptFriendRequest(userFriendModel),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
