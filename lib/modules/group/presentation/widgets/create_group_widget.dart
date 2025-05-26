import 'dart:io';
import 'dart:math';

import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/friend/domain/di/friend_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/constants/size_config.dart';
import '../../../../shared/utilities/helpers/image_picker_util.dart';
import '../../../../shared/utilities/validation/validation.dart';
import '../../../../shared/widgets/button/button_widget.dart';
import '../../../../shared/widgets/friends/friend.dart';
import '../../../../shared/widgets/text_field/text_field.dart';
import '../../../../shared/widgets/image/image_widget.dart';
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

  String _getRandomImageUrl() {
    final styles = [
      'initials',
      'shapes',
      'pixel-art',
      'rings',
      'sunset',
      'marble'
    ];
    final random = Random();
    final style = styles[random.nextInt(styles.length)];
    final seed = DateTime.now().millisecondsSinceEpoch.toString();
    return 'https://api.dicebear.com/7.x/$style/svg?seed=$seed&backgroundColor=ffffff';
  }

  /// * ----- add photo button
  Widget _addPhotoButton(ValueNotifier<File?> image, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConfig.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorConfig.primarySwatch25,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: ColorConfig.white,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Choose Image Source',
                        style: FontConfig.body1()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _imageOptionButton(
                            icon: Icons.photo_library,
                            label: 'Gallery',
                            onTap: () async {
                              Navigator.pop(context);
                              image.value = await pickImage();
                            },
                          ),
                          _imageOptionButton(
                            icon: Icons.auto_awesome,
                            label: 'Random',
                            onTap: () {
                              Navigator.pop(context);
                              image.value = null;
                              groupTitle.addListener(() {
                                if (image.value == null) {
                                  image.value = null;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: image.value != null || groupTitle.text.isNotEmpty
                    ? ColorConfig.white
                    : ColorConfig.primarySwatch.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConfig.primarySwatch25,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: image.value != null
                    ? Image.file(
                        image.value!,
                        fit: BoxFit.cover,
                      )
                    : groupTitle.text.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 32,
                                color: ColorConfig.primarySwatch,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add Cover',
                                style: FontConfig.caption().copyWith(
                                  color: ColorConfig.primarySwatch,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : ImageWidget(
                            imageUrl: _getRandomImageUrl(),
                            borderRadius: 11,
                          ),
              ),
            ),
          ),
          if (image.value != null || groupTitle.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Tap to change',
                style: FontConfig.caption().copyWith(
                  color: ColorConfig.primarySwatch50,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _imageOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorConfig.primarySwatch.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: ColorConfig.primarySwatch,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: FontConfig.caption(),
          ),
        ],
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
            _addPhotoButton(image, context),
            const SizedBox(height: 16),
            TextFieldWidget(
              hintText: 'Group Title',
              fillColor: ColorConfig.white,
              controller: groupTitle,
              validator: ref.read(formValidatorProvider.notifier).validateTitle,
            ),
            const SizedBox(height: 16),
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
            'No Friends Yet',
            style: FontConfig.h6().copyWith(
              color: ColorConfig.midnight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add friends to create groups and share expenses together',
            textAlign: TextAlign.center,
            style: FontConfig.body2().copyWith(
              color: ColorConfig.primarySwatch50,
            ),
          ),
          // const SizedBox(height: 20),
          // TextButton.icon(
          //   onPressed: () {
          //     // Navigate to add friends page
          //     // You can implement the navigation later
          //   },
          //   icon: Icon(
          //     Icons.person_add_outlined,
          //     color: ColorConfig.secondary,
          //     size: 20,
          //   ),
          //   label: Text(
          //     'Add Friends',
          //     style: FontConfig.button().copyWith(
          //       color: ColorConfig.secondary,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendList = ref.watch(friendNotifierProvider);
    final currentUserId = ref.read(currentUserProvider)!.id;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 30, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Members',
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
                final approvedFriends = data
                    .where(
                      (element) =>
                          element.status == FriendRequestStatus.accepted,
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
                                Stack(
                                  children: [
                                    FriendWidget(
                                      image: friend.sendRequestUserId ==
                                              currentUserId
                                          ? friend.receiveRequestProfilePic
                                          : friend.sendRequestProfilePic,
                                      isSelected: isSelected,
                                    ),
                                    if (isSelected)
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: ColorConfig.secondary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            size: 12,
                                            color: ColorConfig.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  friend.sendRequestUserId == currentUserId
                                      ? friend.receiveRequestUserName ??
                                          friend.receiveRequestUserId
                                      : friend.sendRequestUserName ??
                                          friend.sendRequestUserId,
                                  style: FontConfig.caption().copyWith(
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
                    ],
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
