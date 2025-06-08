import 'dart:io';

import 'package:dongi/modules/group/domain/models/group_model.dart';
import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/friend/domain/di/friend_controller_di.dart';
import 'package:dongi/core/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/constants/size_config.dart';
import '../../../../shared/utilities/helpers/image_picker_util.dart';
import '../../../../shared/utilities/validation/validation.dart';
import '../../../../shared/widgets/button/button_widget.dart';
import '../../../../shared/widgets/friends/friend.dart';
import '../../../../shared/widgets/text_field/text_field.dart';
import '../../domain/di/group_controller_di.dart';

class UpdateGroupInfoCard extends ConsumerWidget {
  final TextEditingController groupTitle;
  final TextEditingController groupDescription;
  final ValueNotifier<File?> newGroupImage;
  final ValueNotifier<String?> oldGroupImage;
  final GlobalKey<FormState> formKey;
  final GroupModel groupModel;

  const UpdateGroupInfoCard({
    required this.groupTitle,
    required this.groupDescription,
    required this.newGroupImage,
    required this.oldGroupImage,
    required this.formKey,
    required this.groupModel,
    super.key,
  });

  _addPhotoButton({
    required ValueNotifier<File?> newGroupImage,
    required ValueNotifier<String?> oldGroupImage,
    required bool isEnabled,
  }) {
    return InkWell(
      onTap: isEnabled
          ? () async {
              newGroupImage.value = await pickImage();
            }
          : null,
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
                  colorFilter: isEnabled
                      ? null
                      : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if current user is admin or creator
    final currentUser = ref.watch(currentUserProvider);
    final isCreator = currentUser?.id == groupModel.creatorId;
    final isAdmin = ref.watch(isCurrentUserAdminProvider(groupModel.id ?? ''));
    final canEdit = isCreator || isAdmin;

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
                  isEnabled: canEdit,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFieldWidget(
                      hintText: 'Group Title',
                      fillColor: ColorConfig.white,
                      controller: groupTitle,
                      enabled: canEdit,
                      validator: ref
                          .read(formValidatorProvider.notifier)
                          .validateTitle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFieldWidget(
              hintText: 'Description',
              fillColor: ColorConfig.white,
              controller: groupDescription,
              enabled: canEdit,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateGroupAddFriendCard extends HookConsumerWidget {
  final GroupModel groupModel;

  const UpdateGroupAddFriendCard({
    super.key,
    required this.groupModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendList = ref.watch(friendNotifierProvider);
    final currentUserId = ref.read(currentUserProvider)!.id;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Member',
                style: FontConfig.body1().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push(
                    RouteName.addGroupMember,
                    extra: groupModel,
                  );
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  backgroundColor: ColorConfig.secondary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_add,
                      size: 16,
                      color: ColorConfig.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Add Friends",
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
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            width: SizeConfig.width(context),
            decoration: BoxDecoration(
              color: ColorConfig.grey,
              borderRadius: BorderRadius.circular(15),
            ),
            child: friendList.when(
              data: (data) {
                final groupMembers = data
                    .where(
                      (element) =>
                          element.status == FriendRequestStatus.accepted &&
                          groupModel.groupUsers.contains(
                            element.receiveRequestUserId == currentUserId
                                ? element.sendRequestUserId
                                : element.receiveRequestUserId,
                          ),
                    )
                    .toList();

                if (groupMembers.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 20),
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
                          'No Members Yet',
                          style: FontConfig.h6().copyWith(
                            color: ColorConfig.midnight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Click "Add Friends" to invite members to the group',
                          textAlign: TextAlign.center,
                          style: FontConfig.body2().copyWith(
                            color: ColorConfig.primarySwatch50,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: groupMembers.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, i) {
                    final member = groupMembers[i];
                    return Column(
                      children: [
                        FriendWidget(
                          image: member.sendRequestUserId == currentUserId
                              ? member.receiveRequestProfilePic
                              : member.sendRequestProfilePic,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          member.sendRequestUserId == currentUserId
                              ? member.receiveRequestUserName ??
                                  member.receiveRequestUserId
                              : member.sendRequestUserName ??
                                  member.sendRequestUserId,
                          style: FontConfig.caption().copyWith(
                            color: ColorConfig.midnight,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Text(
                  'Error loading members',
                  style: FontConfig.body2().copyWith(
                    color: ColorConfig.error,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UpgradeGroupCreateButton extends ConsumerWidget {
  final ValueNotifier<File?> newGroupImage;
  final TextEditingController groupTitle;
  final TextEditingController groupDescription;
  final GlobalKey<FormState> formKey;
  final GroupModel groupModel;

  const UpgradeGroupCreateButton({
    required this.newGroupImage,
    required this.groupTitle,
    required this.groupDescription,
    required this.groupModel,
    required this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if current user is admin or creator
    final currentUser = ref.watch(currentUserProvider);
    final isCreator = currentUser?.id == groupModel.creatorId;
    final isAdmin = ref.watch(isCurrentUserAdminProvider(groupModel.id ?? ''));
    final canEdit = isCreator || isAdmin;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
      child: ButtonWidget(
        isLoading: ref.watch(groupNotifierProvider).maybeWhen(
              loading: () => true,
              orElse: () => false,
            ),
        onPressed: canEdit
            ? () {
                if (formKey.currentState!.validate()) {
                  ref.read(groupNotifierProvider.notifier).updateGroup(
                        image: newGroupImage,
                        groupTitle: groupTitle,
                        groupDescription: groupDescription,
                        groupModel: groupModel,
                      );
                }
              }
            : null, // Disable button if user can't edit
        title: 'Update',
        textColor: ColorConfig.secondary,
      ),
    );
  }
}
