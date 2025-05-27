import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../core/router/router_names.dart';
import 'package:go_router/go_router.dart';
import '../../../../modules/auth/domain/di/auth_controller_di.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../widgets/home_widget.dart';
// import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeProvider = ref.watch(homeNotifierProvider);
    return homeProvider.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      data: (data) {
        return Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     String appScheme = '';
          //     String uri = '$appScheme://authentication?key=12345';
          //     await launchUrlString(uri);
          //   },
          // ),
          backgroundColor: ColorConfig.white,
          appBar: AppBarWidget(drawer: _buildDrawer(context, ref)),
          drawer: _buildDrawer(context, ref),
          body: ListView(
            children: [
              const HomeExpenseSummery(),
              const SizedBox(height: 30),
              HomeRecentGroup(data),
              const SizedBox(height: 30),
              HomeWeeklyAnalytic(),
              const SizedBox(height: 30),
              const HomeRecentTransaction(),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  Icon(Icons.account_circle, size: 48, color: ColorConfig.primarySwatch),
                  const SizedBox(width: 16),
                  Text('Menu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.people_outline, color: ColorConfig.midnight),
              title: Text('Friends List'),
              onTap: () {
                Navigator.pop(context);
                context.push(RouteName.friendList);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_outline, color: ColorConfig.midnight),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                context.push(RouteName.profile);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout_outlined, color: ColorConfig.midnight),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                ref.read(authControllerProvider.notifier).logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
