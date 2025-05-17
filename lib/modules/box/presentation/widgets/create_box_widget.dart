import 'dart:io';

import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/constants/size_config.dart';
import '../../../../shared/utilities/helpers/image_picker_util.dart';
import '../../../../shared/utilities/validation/validation.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../../shared/widgets/button/button_widget.dart';
import '../../../../shared/widgets/friends/friend.dart';
import '../../../../shared/widgets/text_field/text_field.dart';
import '../../../../shared/widgets/loading/loading.dart';
import '../../../../shared/widgets/error/error.dart';
import '../../domain/models/box_model.dart';
import '../../domain/controllers/box_controller.dart';

final selectedCurrencyProvider = StateProvider<String>((ref) => 'KZT');
final selectedMembersProvider = StateProvider<List<String>>((ref) => []);

class CreateBoxInfoCard extends ConsumerWidget {
  final TextEditingController boxTitle;
  final TextEditingController boxDescription;
  final ValueNotifier<File?> image;
  final GlobalKey<FormState> formKey;

  const CreateBoxInfoCard({
    super.key,
    required this.boxTitle,
    required this.boxDescription,
    required this.image,
    required this.formKey,
  });

  void _showCurrencyDialog(BuildContext context, WidgetRef ref) {
    final currencies = [
      {'code': 'KZT', 'name': 'Tenge'},
      {'code': 'USD', 'name': 'US Dollar'},
      {'code': 'EUR', 'name': 'Euro'},
      {'code': 'RUB', 'name': 'Russian Ruble'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Currency', style: FontConfig.body1()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies
              .map((currency) => ListTile(
                    title: Text('${currency['name']} (${currency['code']})',
                        style: FontConfig.body2()),
                    onTap: () {
                      ref.read(selectedCurrencyProvider.notifier).state =
                          currency['code']!;
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

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
    final selectedCurrency = ref.watch(selectedCurrencyProvider);

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
              onTap: () => _showCurrencyDialog(context, ref),
              icon: 'assets/svg/currency_icon.svg',
              title: 'Currency ($selectedCurrency)',
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

class CreateBoxSelectFriends extends ConsumerWidget {
  final GroupModel groupModel;
  const CreateBoxSelectFriends({super.key, required this.groupModel});

  Widget _buildEmptyMembersMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorConfig.grey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.group_add_outlined,
              size: 48,
              color: ColorConfig.primarySwatch,
            ),
            const SizedBox(height: 16),
            Text(
              'No Members Available',
              style: FontConfig.body1(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Invite friends to your group first before creating a box with them.',
              style: FontConfig.body2().copyWith(color: ColorConfig.secondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter out the creator from the group users
    final currentUser = ref.watch(currentUserProvider);
    final otherGroupUsers = groupModel.groupUsers
        .where((userId) => userId != currentUser?.id)
        .toList();

    if (otherGroupUsers.isEmpty) {
      return _buildEmptyMembersMessage();
    }

    final selectedMembers = ref.watch(selectedMembersProvider);
    final users = ref.watch(getUsersInBoxProvider(
      UsersInBoxArgs(userIds: otherGroupUsers, groupId: groupModel.id!),
    ));

    return users.when(
      loading: () => const LoadingWidget(),
      error: (error, stackTrace) => ErrorTextWidget(error),
      data: (users) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Members',
              style: FontConfig.body1(),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              width: SizeConfig.width(context),
              decoration: BoxDecoration(
                color: ColorConfig.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, i) {
                      final user = users[i];
                      final isSelected = selectedMembers.contains(user.id);
                      return GestureDetector(
                        onTap: () {
                          if (isSelected) {
                            ref.read(selectedMembersProvider.notifier).state =
                                selectedMembers
                                    .where((id) => id != user.id)
                                    .toList();
                          } else {
                            ref.read(selectedMembersProvider.notifier).state = [
                              ...selectedMembers,
                              user.id!
                            ];
                          }
                        },
                        child: FriendWidget(
                          image: user.profileImage,
                          backgroundColor: isSelected
                              ? ColorConfig.primarySwatch
                              : ColorConfig.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateBoxButton extends ConsumerWidget {
  final ValueNotifier<File?> image;
  final TextEditingController boxTitle;
  final TextEditingController boxDescription;
  final GlobalKey<FormState> formKey;
  final GroupModel groupModel;

  const CreateBoxButton({
    super.key,
    required this.image,
    required this.boxTitle,
    required this.boxDescription,
    required this.formKey,
    required this.groupModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCurrency = ref.watch(selectedCurrencyProvider);
    final selectedMembers = ref.watch(selectedMembersProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
      child: ButtonWidget(
        isLoading: ref.watch(boxNotifierProvider(groupModel.id!)).maybeWhen(
              loading: () => true,
              orElse: () => false,
            ),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            await ref.read(boxNotifierProvider(groupModel.id!).notifier).addBox(
                  image: image,
                  boxTitle: boxTitle,
                  boxDescription: boxDescription,
                  groupModel: groupModel,
                  currency: selectedCurrency,
                  selectedMembers: selectedMembers,
                );

            // Reset selected members and currency after successful creation
            ref.read(selectedMembersProvider.notifier).state = [];
            ref.read(selectedCurrencyProvider.notifier).state = 'KZT';
          }
        },
        title: 'Create Box',
        textColor: ColorConfig.secondary,
      ),
    );
  }
}
