import 'dart:io';
import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/core/constants/font_config.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:dongi/shared/utilities/helpers/image_picker_util.dart';
import 'package:dongi/shared/utilities/helpers/snackbar_helper.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:dongi/shared/widgets/drawer/drawer_widget.dart';
import 'package:dongi/shared/widgets/text_field/text_field.dart';
import 'package:dongi/shared/utilities/extensions/validation_string.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongi/modules/friend/domain/di/friend_controller_di.dart';
import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/modules/group/domain/di/group_controller_di.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userDataAsync = ref.watch(userNotifierProvider);
    final friendListAsync = ref.watch(getFriendProvider);
    final groupListAsync = ref.watch(groupNotifierProvider);
    final transactionsAsync = ref.watch(homeTransactionsProvider);

    Future<void> handleImageUpload() async {
      final file = await pickImage();
      if (file != null) {
        final userData = userDataAsync.value;
        if (userData != null) {
          try {
            await ref
                .read(userNotifierProvider.notifier)
                .updateProfileImage(file);
            showSnackBar(context,
                content: "Profile image updated successfully!");
          } catch (e) {
            showSnackBar(context,
                content: "Failed to update profile image: $e");
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: ColorConfig.white,
      appBar: AppBarWidget(
        title: "Profile",
      ),
      drawer: const DrawerWidget(),
      body: userDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (userData) => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image and Basic Info
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: handleImageUpload,
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConfig.baseGrey,
                                image:
                                    userData?.profileImage?.isNotEmpty == true
                                        ? DecorationImage(
                                            image: NetworkImage(
                                                userData!.profileImage!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                              ),
                              child: userData?.profileImage?.isNotEmpty != true
                                  ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: ColorConfig.midnight,
                                    )
                                  : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: ColorConfig.primarySwatch,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: ColorConfig.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        userData?.userName ?? currentUser?.name ?? 'No Name',
                        style: FontConfig.h5(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userData?.email ?? currentUser?.email ?? 'No Email',
                        style: FontConfig.body2().copyWith(
                          color: ColorConfig.primarySwatch50,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Account Information Section
                Text(
                  'Account Information',
                  style: FontConfig.h6(),
                ),
                const SizedBox(height: 16),
                _buildInfoTile(
                  'Email',
                  userData?.email ?? currentUser?.email ?? 'Not provided',
                  Icons.email_outlined,
                ),
                _buildInfoTile(
                  'Phone',
                  userData?.phoneNumber ?? currentUser?.phone ?? 'Not provided',
                  Icons.phone_outlined,
                  onEdit: () async {
                    final TextEditingController phoneController =
                        TextEditingController();
                    phoneController.text =
                        userData?.phoneNumber ?? currentUser?.phone ?? '';

                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(
                          'Update Phone Number',
                          style: FontConfig.h6().copyWith(
                            color: ColorConfig.midnight,
                          ),
                        ),
                        content: Container(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Enter your phone number with country code',
                                style: FontConfig.body2().copyWith(
                                  color: ColorConfig.primarySwatch50,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFieldWidget(
                                controller: phoneController,
                                hintText: '+1234567890',
                                keyboardType: TextInputType.phone,
                                fillColor: ColorConfig.baseGrey,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a phone number';
                                  }
                                  if (!value.isValidPhone) {
                                    return 'Please enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: FontConfig.body2().copyWith(
                                color: ColorConfig.primarySwatch50,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final newPhone = phoneController.text;
                              if (newPhone.isValidPhone) {
                                try {
                                  if (userData != null) {
                                    final updatedUser = userData.copyWith(
                                      phoneNumber: newPhone,
                                    );
                                    await ref
                                        .read(userNotifierProvider.notifier)
                                        .saveUser(updatedUser);
                                    if (context.mounted) {
                                      showSnackBar(context,
                                          content:
                                              "Phone number updated successfully!");
                                      Navigator.pop(context);
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    showSnackBar(context,
                                        content:
                                            "Failed to update phone number: $e");
                                    Navigator.pop(context);
                                  }
                                }
                              } else {
                                if (context.mounted) {
                                  showSnackBar(context,
                                      content:
                                          "Please enter a valid phone number");
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConfig.primarySwatch,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Update',
                              style: FontConfig.body2().copyWith(
                                color: ColorConfig.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    );
                  },
                ),
                _buildInfoTile(
                  'Member Since',
                  userData?.createdAt != null
                      ? _formatDate(userData!.createdAt!)
                      : currentUser?.registration != null
                          ? _formatDate(currentUser!.registration)
                          : 'Not available',
                  Icons.calendar_today_outlined,
                ),

                const SizedBox(height: 32),

                // Statistics Section
                Text(
                  'Statistics',
                  style: FontConfig.h6(),
                ),
                const SizedBox(height: 16),
                friendListAsync.when(
                  loading: () => _buildStatTile(
                      'Total Friends', 'Loading...', Icons.people_outline),
                  error: (_, __) => _buildStatTile(
                      'Total Friends', 'Error loading', Icons.people_outline),
                  data: (friendsList) => _buildStatTile(
                    'Total Friends',
                    friendsList
                        .where((friend) =>
                            friend.status == FriendRequestStatus.accepted)
                        .length
                        .toString(),
                    Icons.people_outline,
                  ),
                ),
                groupListAsync.when(
                  loading: () => _buildStatTile(
                      'Groups', 'Loading...', Icons.group_work_outlined),
                  error: (_, __) => _buildStatTile(
                      'Groups', 'Error loading', Icons.group_work_outlined),
                  data: (groupsList) => _buildStatTile(
                    'Groups',
                    groupsList.length.toString(),
                    Icons.group_work_outlined,
                  ),
                ),
                transactionsAsync.when(
                  loading: () => _buildStatTile('Total Transactions',
                      'Loading...', Icons.receipt_long_outlined),
                  error: (_, __) => _buildStatTile('Total Transactions',
                      'Error loading', Icons.receipt_long_outlined),
                  data: (transactionsList) => _buildStatTile(
                    'Total Transactions',
                    transactionsList.length.toString(),
                    Icons.receipt_long_outlined,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon,
      {VoidCallback? onEdit}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConfig.baseGrey,
            ),
            child: Icon(
              icon,
              size: 20,
              color: ColorConfig.midnight,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontConfig.caption().copyWith(
                    color: ColorConfig.primarySwatch50,
                  ),
                ),
                Text(
                  value,
                  style: FontConfig.body2(),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              color: ColorConfig.midnight,
            ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConfig.baseGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConfig.white,
            ),
            child: Icon(
              icon,
              size: 24,
              color: ColorConfig.midnight,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontConfig.body2(),
                ),
                Text(
                  value,
                  style: FontConfig.h5(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return '${date.day}/${date.month}/${date.year}';
  }
}
