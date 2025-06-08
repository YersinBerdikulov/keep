import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/core/constants/font_config.dart';
import 'package:dongi/core/router/router_names.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/friend/domain/di/friend_controller_di.dart';
import 'package:dongi/modules/friend/domain/models/user_friend_model.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:dongi/shared/widgets/dialog/dialog_widget.dart';
import 'package:dongi/shared/widgets/image/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userNotifierProvider);
    final friendList = ref.watch(getFriendProvider);

    // Refresh data when drawer is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(homeNotifierProvider);
    });

    return Drawer(
      backgroundColor: ColorConfig.white,
      child: SafeArea(
        child: Column(
          children: [
            // User Profile Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  currentUser.when(
                    data: (user) => ImageWidget(
                      imageUrl: user?.profileImage,
                      borderRadius: 25,
                      width: 50,
                      height: 50,
                    ),
                    loading: () => const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                    error: (_, __) => const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: currentUser.when(
                      data: (user) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.userName ?? user?.email ?? '',
                            style: FontConfig.h6().copyWith(
                              color: ColorConfig.midnight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user?.email ?? '',
                            style: FontConfig.caption().copyWith(
                              color: ColorConfig.primarySwatch50,
                            ),
                          ),
                        ],
                      ),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (_, __) => const Text('Error loading user data'),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Navigation Items
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConfig.baseGrey,
                ),
                child: Icon(
                  Icons.home_outlined,
                  color: ColorConfig.midnight,
                  size: 20,
                ),
              ),
              title: Text(
                'Home',
                style: FontConfig.body2().copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                context.go(RouteName.home);
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConfig.baseGrey,
                ),
                child: Icon(
                  Icons.people_outline,
                  color: ColorConfig.midnight,
                  size: 20,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    'Friends List',
                    style: FontConfig.body2().copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  friendList.when(
                    data: (data) {
                      final incomingRequests = data
                          .where((e) =>
                              e.status == FriendRequestStatus.pending &&
                              e.receiveRequestUserId == currentUser.value?.id)
                          .length;

                      if (incomingRequests > 0) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: ColorConfig.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            incomingRequests.toString(),
                            style: FontConfig.caption().copyWith(
                              color: ColorConfig.error,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
              onTap: () {
                context.push(RouteName.friendList);
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConfig.baseGrey,
                ),
                child: Icon(
                  Icons.person_outline,
                  color: ColorConfig.midnight,
                  size: 20,
                ),
              ),
              title: Text(
                'Profile',
                style: FontConfig.body2().copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                context.push(RouteName.profile);
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConfig.baseGrey,
                ),
                child: Icon(
                  Icons.history,
                  color: ColorConfig.midnight,
                  size: 20,
                ),
              ),
              title: Text(
                'Transaction History',
                style: FontConfig.body2().copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                context.push(RouteName.allTransactions);
                Navigator.pop(context); // Close drawer
              },
            ),
            const Spacer(),
            // Logout Button
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConfig.error.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.logout,
                  color: ColorConfig.error,
                  size: 20,
                ),
              ),
              title: Text(
                'Logout',
                style: FontConfig.body2().copyWith(
                  color: ColorConfig.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                showCustomBottomDialog(
                  context,
                  title: "Logout",
                  description: "Are you sure you want to logout?",
                  onConfirm: () =>
                      ref.read(authControllerProvider.notifier).logout(context),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
