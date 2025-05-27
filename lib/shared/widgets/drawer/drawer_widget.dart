import 'package:dongi/core/constants/color_config.dart';
import 'package:dongi/core/constants/font_config.dart';
import 'package:dongi/core/router/router_names.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:dongi/shared/widgets/image/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userDataAsync = ref.watch(userNotifierProvider);

    return Drawer(
      child: userDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (userData) => Column(
          children: [
            // User Profile Header
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: ColorConfig.primarySwatch,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: ColorConfig.white,
                child: userData?.profileImage?.isNotEmpty == true
                    ? ImageWidget(
                        imageUrl: userData!.profileImage!,
                        borderRadius: 50,
                        width: 80,
                        height: 80,
                      )
                    : Icon(
                        Icons.person,
                        size: 40,
                        color: ColorConfig.midnight,
                      ),
              ),
              accountName: Text(
                userData?.userName ?? currentUser?.name ?? 'No Name',
                style: FontConfig.body1().copyWith(
                  color: ColorConfig.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text(
                userData?.email ?? currentUser?.email ?? 'No Email',
                style: FontConfig.body2().copyWith(
                  color: ColorConfig.white.withOpacity(0.8),
                ),
              ),
            ),

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
              title: Text(
                'Friends List',
                style: FontConfig.body2().copyWith(
                  fontWeight: FontWeight.w500,
                ),
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
            const Spacer(),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConfig.error.withOpacity(0.1),
                ),
                child: Icon(
                  Icons.logout_outlined,
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
                ref.read(authControllerProvider.notifier).logout(context);
                Navigator.pop(context); // Close drawer
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
} 