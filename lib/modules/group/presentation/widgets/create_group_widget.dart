import 'dart:io';

import 'package:dongi/app/friends/controller/friend_controller.dart';
import 'package:dongi/models/user_friend_model.dart';
import 'package:dongi/modules/auth/domain/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/constants/size_config.dart';
import '../../../../core/utilities/helpers/image_picker_util.dart';
import '../../../../core/utilities/validation/validation.dart';
import '../../../../widgets/button/button.dart';
import '../../../../widgets/friends/friend.dart';
import '../../../../widgets/text_field/text_field.dart';
import '../../domain/di/group_controller_di.dart';

class CreateGroupInfoCard extends ConsumerWidget {
  final TextEditingController groupTitle;
  final TextEditingController groupDescription;
  final ValueNotifier<File?> image;
  final GlobalKey<FormState> formKey;
  const CreateGroupInfoCard({
    super.key,
    required this.groupTitle,
    required this.groupDescription,
    required this.image,
    required this.formKey,
  });

  /// * ----- add photo button
  _addPhotoButton(ValueNotifier<File?> image) {
    return InkWell(
      onTap: () async {
        image.value = await pickImage();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: ColorConfig.white,
          borderRadius: BorderRadius.circular(10),
          image: image.value != null
              ? DecorationImage(
                  image: FileImage(image.value!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: image.value == null
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
                _addPhotoButton(image),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextFieldWidget(
                      hintText: 'Group Title',
                      fillColor: ColorConfig.white,
                      controller: groupTitle,
                      validator: ref
                          .read(formValidatorProvider.notifier)
                          .validateTitle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            //Row(
            //  children: [
            //    _selectOptionButton(
            //      onTap: () {},
            //      icon: 'assets/svg/category_icon.svg',
            //      title: 'category',
            //    ),
            //    const SizedBox(width: 10),
            //    _selectOptionButton(
            //      onTap: () {},
            //      icon: 'assets/svg/currency_icon.svg',
            //      title: 'currency',
            //    ),
            //  ],
            //),
            //const SizedBox(height: 10),
            TextFieldWidget(
              hintText: 'Description',
              fillColor: ColorConfig.white,
              controller: groupDescription,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class CreateGroupButton extends ConsumerWidget {
  final ValueNotifier<File?> image;
  final TextEditingController groupTitle;
  final TextEditingController groupDescription;
  final GlobalKey<FormState> formKey;
  final ValueNotifier<Set<String>> selectedFriends;
  const CreateGroupButton({
    required this.image,
    required this.groupTitle,
    required this.groupDescription,
    required this.formKey,
    required this.selectedFriends,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
      child: ButtonWidget(
        isLoading: ref.watch(groupNotifierProvider).maybeWhen(
              loading: () => true,
              orElse: () => false,
            ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            ref.read(groupNotifierProvider.notifier).addGroup(
                  image: image,
                  groupTitle: groupTitle,
                  groupDescription: groupDescription,
                  selectedFriends: selectedFriends,
                );
          }
        },
        title: 'Create',
        textColor: ColorConfig.secondary,
      ),
    );
  }
}

class CreateGroupAddFriend extends HookConsumerWidget {
  final ValueNotifier<Set<String>> selectedFriends;

  const CreateGroupAddFriend({super.key, required this.selectedFriends});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendList = ref.watch(getFriendProvider);
    final currentUserId = ref.read(currentUserProvider)!.id;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Member',
            style: FontConfig.body1(),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
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
                          element.status == FriendRequestStatus.accepted,
                    )
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                            friend.receiveRequestUserId == currentUserId
                                ? friend.sendRequestUserId
                                : friend.receiveRequestUserId;
                        final isSelected =
                            selectedFriends.value.contains(friendIdToAdd);

                        return GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              selectedFriends.value.remove(friendIdToAdd);
                            } else {
                              selectedFriends.value.add(friendIdToAdd);
                            }

                            selectedFriends.value =
                                Set.from(selectedFriends.value);
                          },
                          child: Column(
                            children: [
                              FriendWidget(
                                image: friend.sendRequestUserId == currentUserId
                                    ? friend.receiveRequestProfilePic
                                    : friend.sendRequestProfilePic,
                                isSelected: isSelected, // Pass selection state
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    friend.sendRequestUserId == currentUserId
                                        ? friend.receiveRequestUserName
                                        : friend.sendRequestUserName,
                                    style: FontConfig.body2().copyWith(
                                      color: isSelected
                                          ? ColorConfig.secondary
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text(error.toString()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
