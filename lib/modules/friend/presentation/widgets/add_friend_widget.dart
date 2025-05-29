import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/friend/domain/di/friend_controller_di.dart';
import 'package:dongi/shared/widgets/dialog/dialog_widget.dart';
import 'package:dongi/shared/widgets/image/image_widget.dart';
import 'package:dongi/shared/widgets/list_tile/list_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AddFriendList extends HookConsumerWidget {
  final List<UserModel> searchResults;
  const AddFriendList(this.searchResults, {super.key});

  Widget _buildEmptyResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: ColorConfig.primarySwatch.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_search_rounded,
              size: 40,
              color: ColorConfig.primarySwatch,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: ColorConfig.midnight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with a different email or username',
            style: TextStyle(
              fontSize: 14,
              color: ColorConfig.primarySwatch50,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchResults.isEmpty) {
      return _buildEmptyResults();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final result = searchResults[index];
        return AnimatedOpacity(
          duration: Duration(milliseconds: 300 + (index * 100)),
          opacity: 1,
          curve: Curves.easeOut,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTileCard(
              leading: Hero(
                tag: 'profile_${result.id}',
                child: ImageWidget(
                  imageUrl: result.profileImage,
                  borderRadius: 12,
                  width: 56,
                  height: 56,
                ),
              ),
              titleString: result.userName ?? result.email,
              subtitleString: result.userName != null ? result.email : null,
              visualDensity: const VisualDensity(vertical: 1),
              trailing: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConfig.secondary.withOpacity(0.1),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.person_add_rounded,
                    color: ColorConfig.secondary,
                    size: 20,
                  ),
                  onPressed: () {
                    showCustomBottomDialog(
                      context,
                      title: "Send Friend Request",
                      description:
                          "Are you sure you want to send a friend request to ${result.userName ?? result.email}? This user will be able to accept or decline your request.",
                      onConfirm: () => ref
                          .read(friendNotifierProvider.notifier)
                          .addFriend(result),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
