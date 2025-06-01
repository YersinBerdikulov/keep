import 'dart:io';
import 'package:dongi/shared/utilities/helpers/image_picker_util.dart';
import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:dongi/modules/friend/domain/di/friend_controller_di.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/group/domain/di/group_controller_di.dart';
import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/constants/size_config.dart';
import '../../../../shared/utilities/validation/validation.dart';
import '../../domain/models/box_model.dart';
import '../../../../shared/widgets/button/button_widget.dart';
import '../../../../shared/widgets/friends/friend.dart';
import '../../../../shared/widgets/text_field/text_field.dart';

class UpdateBoxInfoCard extends ConsumerWidget {
  final TextEditingController boxTitle;
  final TextEditingController boxDescription;
  final ValueNotifier<File?> newGroupImage;
  final ValueNotifier<String?> oldGroupImage;
  final GlobalKey<FormState> formKey;

  const UpdateBoxInfoCard({
    super.key,
    required this.boxTitle,
    required this.boxDescription,
    required this.newGroupImage,
    required this.oldGroupImage,
    required this.formKey,
  });

  /// * ----- select option button
  selectOptionButton({
    required Function onTap,
    required String icon,
    required String title,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        decoration: BoxDecoration(
          color: ColorConfig.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon),
            const SizedBox(width: 10),
            Text(
              title,
              style: FontConfig.body2(),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: ColorConfig.primarySwatch,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  /// * ----- add photo button
  _addPhotoButton({
    required ValueNotifier<File?> newGroupImage,
    required ValueNotifier<String?> oldGroupImage,
  }) {
    return InkWell(
      onTap: () async {
        newGroupImage.value = await pickImage();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: ColorConfig.white,
          borderRadius: BorderRadius.circular(10),
          image: newGroupImage.value != null
              //This will show selected image from file
              ? DecorationImage(
                  image: FileImage(newGroupImage.value!),
                  fit: BoxFit.cover,
                )
              : oldGroupImage.value != null
                  //this will show the image which uploaded before
                  ? DecorationImage(
                      image: NetworkImage(oldGroupImage.value!),
                      fit: BoxFit.cover,
                    )
                  : null,
        ),
        child: newGroupImage.value == null && oldGroupImage.value == null
            ? Center(
                child: SvgPicture.asset(
                  'assets/svg/add_photo_icon.svg',
                  height: 14,
                ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: formKey,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        padding: const EdgeInsets.all(15),
        width: SizeConfig.width(context),
        decoration: BoxDecoration(
          color: ColorConfig.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _addPhotoButton(
                  newGroupImage: newGroupImage,
                  oldGroupImage: oldGroupImage,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFieldWidget(
                    hintText: 'Box Name',
                    fillColor: ColorConfig.white,
                    controller: boxTitle,
                    validator:
                        ref.read(formValidatorProvider.notifier).validateTitle,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            selectOptionButton(
              onTap: () {},
              icon: 'assets/svg/currency_icon.svg',
              title: 'currency',
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              maxLines: 2,
              hintText: 'Description',
              fillColor: ColorConfig.white,
              controller: boxDescription,
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateBoxSelectFriends extends HookConsumerWidget {
  final BoxModel boxModel;
  final void Function(Set<String>) onMembersSelected;
  const UpdateBoxSelectFriends({
    super.key,
    required this.boxModel,
    required this.onMembersSelected,
  });

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
            'No Available Members',
            style: FontConfig.h6().copyWith(
              color: ColorConfig.midnight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All group members are already in this box',
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
    final groupState = ref.watch(groupNotifierProvider);

    // Call onMembersSelected whenever selection changes
    useEffect(() {
      onMembersSelected(selectedFriends.value);
      return null;
    }, [selectedFriends.value]);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Member',
                style: FontConfig.body1().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                // Get the current group
                final currentGroup = groupState.whenOrNull(
                  data: (groups) => groups.firstWhere(
                    (group) => group.id == boxModel.groupId,
                  ),
                );

                if (currentGroup == null) {
                  return _buildEmptyState();
                }

                final approvedFriends = data
                    .where(
                      (element) =>
                          element.status == FriendRequestStatus.accepted &&
                          !boxModel.boxUsers.contains(
                            element.receiveRequestUserId == currentUserId
                                ? element.sendRequestUserId
                                : element.receiveRequestUserId,
                          ) &&
                          currentGroup.groupUsers.contains(
                            element.receiveRequestUserId == currentUserId
                                ? element.sendRequestUserId
                                : element.receiveRequestUserId,
                          ),
                    )
                    .toList();

                if (approvedFriends.isEmpty) {
                  return _buildEmptyState();
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(15),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: approvedFriends.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, i) {
                    final friend = approvedFriends[i];
                    final friendIdToAdd =
                        friend.receiveRequestUserId == currentUserId
                            ? friend.sendRequestUserId
                            : friend.receiveRequestUserId;
                    final isSelected =
                        selectedFriends.value.contains(friendIdToAdd);

                    // Get the friend's name and profile pic
                    final friendName = friend.sendRequestUserId == currentUserId
                        ? friend.receiveRequestUserName ??
                            friend.receiveRequestUserId
                        : friend.sendRequestUserName ??
                            friend.sendRequestUserId;

                    final friendProfilePic =
                        friend.sendRequestUserId == currentUserId
                            ? friend.receiveRequestProfilePic
                            : friend.sendRequestProfilePic;

                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          selectedFriends.value.remove(friendIdToAdd);
                        } else {
                          selectedFriends.value.add(friendIdToAdd);
                        }
                        selectedFriends.value = Set.from(selectedFriends.value);
                      },
                      child: Column(
                        children: [
                          FriendWidget(
                            image: friendProfilePic,
                            isSelected: isSelected,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Text(
                              friendName,
                              style: FontConfig.caption().copyWith(
                                color: ColorConfig.secondary,
                                fontSize: 10,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  error.toString(),
                  style: FontConfig.body2().copyWith(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateBoxButton extends ConsumerWidget {
  final ValueNotifier<File?> newBoxImage;
  final TextEditingController boxTitle;
  final TextEditingController boxDescription;
  final GlobalKey<FormState> formKey;
  final BoxModel boxModel;
  final Set<String> selectedMembers;

  const UpdateBoxButton({
    super.key,
    required this.newBoxImage,
    required this.boxTitle,
    required this.boxDescription,
    required this.formKey,
    required this.boxModel,
    required this.selectedMembers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
      child: ButtonWidget(
        isLoading: ref.watch(boxNotifierProvider(boxModel.groupId)).maybeWhen(
              loading: () => true,
              orElse: () => false,
            ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // Create a set to handle duplicates automatically
            final Set<String> uniqueMembers = {...boxModel.boxUsers};
            uniqueMembers.addAll(selectedMembers);

            // Convert back to list for the API
            final List<String> updatedMembers = uniqueMembers.toList();

            print('Existing members: ${boxModel.boxUsers}');
            print('Selected new members: $selectedMembers');
            print('Final combined members: $updatedMembers');

            ref.read(boxNotifierProvider(boxModel.groupId).notifier).updateBox(
                  boxId: boxModel.id!,
                  boxTitle: boxTitle,
                  boxDescription: boxDescription,
                  image: newBoxImage,
                  boxUsers: updatedMembers,
                );
          }
        },
        title: 'Update',
        textColor: ColorConfig.secondary,
      ),
    );
  }
}
