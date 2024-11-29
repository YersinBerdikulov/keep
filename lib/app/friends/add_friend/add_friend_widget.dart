import 'package:dongi/app/friends/controller/friend_controller.dart';
import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/modules/auth/domain/models/user_model.dart';
import 'package:dongi/widgets/dialog/dialog_widget.dart';
import 'package:dongi/widgets/image/image_widget.dart';
import 'package:dongi/widgets/list_tile/list_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddFriendList extends HookConsumerWidget {
  final List<UserModel> searchResults;
  const AddFriendList(this.searchResults, {super.key});

  cardIcon() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          //width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: ColorConfig.primarySwatch,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return searchResults.isEmpty
        ? const Center(child: Text('No results found'))
        : ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final result = searchResults[index];
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListTileCard(
                  leading: ImageWidget(
                    imageUrl: result.profileImage,
                    borderRadius: 10,
                    width: 50,
                    height: 50,
                  ),
                  titleString: result.userName,
                  subtitleString: result.email,
                  visualDensity: const VisualDensity(vertical: -2),
                  trailing: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConfig.secondary,
                    ),
                    child: Icon(
                      Icons.add,
                      color: ColorConfig.darkGrey,
                    ),
                  ),
                  onTap: () async {
                    showCustomBottomDialog(
                      context,
                      title: "Send Friend Request",
                      description:
                          "Are you sure you want to send a friend request to ${result.userName}? This user will be able to accept or decline your request.",
                      onConfirm: () => ref
                          .read(friendNotifierProvider.notifier)
                          .addFriend(result),
                    );
                  },
                ),
              );
            },
          );
  }
}
