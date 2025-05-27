import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/core/constants/font_config.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:dongi/shared/widgets/appbar/appbar.dart';
import 'package:dongi/shared/widgets/drawer/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userDataAsync = ref.watch(userNotifierProvider);

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
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConfig.baseGrey,
                          image: userData?.profileImage?.isNotEmpty == true
                              ? DecorationImage(
                                  image: NetworkImage(userData!.profileImage!),
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
                _buildStatTile(
                  'Total Friends',
                  userData?.userFriends.length.toString() ?? '0',
                  Icons.people_outline,
                ),
                _buildStatTile(
                  'Groups',
                  userData?.groupIds.length.toString() ?? '0',
                  Icons.group_work_outlined,
                ),
                _buildStatTile(
                  'Total Transactions',
                  userData?.transactions.length.toString() ?? '0',
                  Icons.receipt_long_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
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
