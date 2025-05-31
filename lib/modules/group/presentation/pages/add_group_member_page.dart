import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/friend/domain/di/friend_controller_di.dart';
import 'package:dongi/modules/group/domain/di/group_controller_di.dart';
import 'package:dongi/shared/utilities/helpers/snackbar_helper.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:dongi/shared/widgets/button/button_widget.dart';
import 'package:dongi/shared/widgets/friends/friend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/constants/size_config.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';

class AddGroupMemberPage extends HookConsumerWidget {
  final GroupModel groupModel;

  const AddGroupMemberPage({super.key, required this.groupModel});

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
              size: 32,
              color: ColorConfig.primarySwatch,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No Friends Available',
            style: FontConfig.h6().copyWith(
              color: ColorConfig.midnight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add friends first before inviting them to the group',
            textAlign: TextAlign.center,
            style: FontConfig.body2().copyWith(
              color: ColorConfig.primarySwatch50,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFriends = useState<Set<String>>({});
    final friendList = ref.watch(friendNotifierProvider);
    final currentUserId = ref.read(currentUserProvider)!.id;

    // Refresh friend list when page is loaded
    useEffect(() {
      ref.refresh(friendNotifierProvider);
      return null;
    }, []);

    ref.listen<AsyncValue<List<GroupModel>>>(
      groupNotifierProvider,
      (_, state) {
        state.whenOrNull(
          data: (_) {
            showSnackBar(context, content: "Members added successfully!");
            // Refresh home data when members are added
            ref.invalidate(homeNotifierProvider);
            context.pop();
          },
          error: (error, _) => showSnackBar(context, content: error.toString()),
        );
      },
    );

    return Scaffold(
      appBar: AppBarWidget(
        title: "Add Member",
        showDrawer: false,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select Friends',
                            style: FontConfig.body1().copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: ColorConfig.secondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.people,
                                  size: 16,
                                  color: ColorConfig.secondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Selected: ${selectedFriends.value.length}",
                                  style: FontConfig.caption().copyWith(
                                    color: ColorConfig.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: SizeConfig.width(context),
                        decoration: BoxDecoration(
                          color: ColorConfig.grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: friendList.when(
                          data: (data) {
                            final approvedFriends = data
                                .where(
                                  (element) =>
                                      element.status ==
                                          FriendRequestStatus.accepted &&
                                      !groupModel.groupUsers.contains(
                                        element.receiveRequestUserId ==
                                                currentUserId
                                            ? element.sendRequestUserId
                                            : element.receiveRequestUserId,
                                      ),
                                )
                                .toList();

                            if (approvedFriends.isEmpty) {
                              return _buildEmptyState();
                            }

                            return Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: approvedFriends.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.9,
                                    ),
                                    itemBuilder: (context, i) {
                                      final friend = approvedFriends[i];
                                      final friendIdToAdd =
                                          friend.receiveRequestUserId ==
                                                  currentUserId
                                              ? friend.sendRequestUserId
                                              : friend.receiveRequestUserId;
                                      final isSelected = selectedFriends.value
                                          .contains(friendIdToAdd);

                                      return GestureDetector(
                                        onTap: () {
                                          if (isSelected) {
                                            selectedFriends.value
                                                .remove(friendIdToAdd);
                                          } else {
                                            selectedFriends.value
                                                .add(friendIdToAdd);
                                          }
                                          selectedFriends.value =
                                              Set.from(selectedFriends.value);
                                        },
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                FriendWidget(
                                                  image: friend
                                                              .sendRequestUserId ==
                                                          currentUserId
                                                      ? friend
                                                          .receiveRequestProfilePic
                                                      : friend
                                                          .sendRequestProfilePic,
                                                  isSelected: isSelected,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              friend.sendRequestUserId ==
                                                      currentUserId
                                                  ? friend.receiveRequestUserName ??
                                                      friend
                                                          .receiveRequestUserId
                                                  : friend.sendRequestUserName ??
                                                      friend.sendRequestUserId,
                                              style:
                                                  FontConfig.caption().copyWith(
                                                color: isSelected
                                                    ? ColorConfig.secondary
                                                    : ColorConfig.midnight,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          loading: () => const Padding(
                            padding: EdgeInsets.all(30),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          error: (error, stackTrace) => Padding(
                            padding: const EdgeInsets.all(30),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: ColorConfig.error,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Failed to load friends',
                                    style: FontConfig.body1().copyWith(
                                      color: ColorConfig.error,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    error.toString(),
                                    style: FontConfig.caption().copyWith(
                                      color: ColorConfig.primarySwatch50,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ButtonWidget(
                                    onPressed: () {
                                      ref.refresh(friendNotifierProvider);
                                    },
                                    title: 'Retry',
                                    textColor: ColorConfig.secondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorConfig.white,
                boxShadow: [
                  BoxShadow(
                    color: ColorConfig.primarySwatch.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: ButtonWidget(
                isLoading: ref.watch(groupNotifierProvider).maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    ),
                onPressed: () {
                  if (selectedFriends.value.isNotEmpty) {
                    ref.read(groupNotifierProvider.notifier).addMembers(
                          groupModel: groupModel,
                          newMemberIds: selectedFriends.value.toList(),
                        );
                  }
                },
                title: 'Add Members',
                textColor: ColorConfig.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
