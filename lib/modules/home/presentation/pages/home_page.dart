import 'package:dongi/core/router/router_names.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../../../shared/widgets/drawer/drawer_widget.dart';
import '../../../group/domain/di/group_controller_di.dart';
import '../../../box/domain/di/box_controller_di.dart';
import '../widgets/home_widget.dart';
// import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // Check user name after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserName();
      // Refresh data when page loads
      refreshData();
    });
  }

  void checkUserName() async {
    final userData = await ref.read(userNotifierProvider.future);
    if (mounted &&
        userData != null &&
        (userData.userName == null || userData.userName!.isEmpty)) {
      context.go(RouteName.enterName);
    }
  }

  // Method to refresh all relevant data
  void refreshData() {
    // Invalidate and refresh providers
    ref.invalidate(homeNotifierProvider);
    ref.invalidate(userNotifierProvider);
    ref.invalidate(homeTransactionsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = ref.watch(homeNotifierProvider);
    return homeProvider.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      data: (data) {
        return Scaffold(
          backgroundColor: ColorConfig.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConfig.baseGrey,
                  ),
                  child: Icon(
                    Icons.menu,
                    color: ColorConfig.midnight,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConfig.baseGrey,
                  ),
                  child: Icon(
                    Icons.refresh,
                    color: ColorConfig.midnight,
                    size: 20,
                  ),
                ),
                onPressed: refreshData,
                tooltip: 'Refresh data',
              ),
              const SizedBox(width: 8),
            ],
          ),
          drawer: const DrawerWidget(),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return RefreshIndicator(
                onRefresh: () async {
                  // Refresh all the data
                  await Future.wait([
                    ref.refresh(homeNotifierProvider.future),
                    ref.refresh(groupNotifierProvider.future),
                    ref.refresh(boxNotifierProvider('').future),
                    ref.refresh(homeTransactionsProvider.future),
                  ]);
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const HomeExpenseSummery(),
                        const SizedBox(height: 24),
                        HomeRecentGroup(data),
                        const SizedBox(height: 24),
                        HomeWeeklyAnalytic(),
                        const SizedBox(height: 24),
                        const HomeRecentTransaction(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
