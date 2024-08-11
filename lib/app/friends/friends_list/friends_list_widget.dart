import 'package:dongi/app/auth/controller/auth_controller.dart';
import 'package:dongi/models/user_friend_model.dart';
import 'package:dongi/widgets/image/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/font_config.dart';
import '../../../widgets/list_tile/list_tile_card.dart';

class FriendListView extends ConsumerWidget {
  final List<UserFriendModel> userFriendModels;

  const FriendListView(this.userFriendModels, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SlidableAutoCloseBehavior(
        child: ListView(
          children: userFriendModels
              .where((element) => element.status == "accept")
              .map<Widget>((userFriend) => UserFriendListCard(userFriend))
              .toList(),
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SlidableAutoCloseBehavior(
        child: ListView(
          children: pendingFriendModels
              .where((element) =>
                  element.status == "pending" &&
                  element.sendRequestUserId == currentUser!.$id)
              .map<Widget>((pendingFriend) => UserFriendListCard(pendingFriend))
              .toList(),
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SlidableAutoCloseBehavior(
        child: ListView(
          children: incomingFriendModels
              .where((element) =>
                  element.status == "pending" &&
                  element.receiveRequestUserId == currentUser!.$id)
              .map<Widget>(
                  (incomingFriend) => UserFriendListCard(incomingFriend))
              .toList(),
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
          leading: ImageWidget(
            imageUrl: userFriendModel.receiveRequestProfilePic,
            borderRadius: 10,
            width: 50,
            height: 50,
          ),
          trailing: Text(
            '\$0',
            style: FontConfig.body2(),
          ),
          titleString: userFriendModel.receiveRequestUserName,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
