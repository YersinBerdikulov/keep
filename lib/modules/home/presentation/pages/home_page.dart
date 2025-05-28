import 'package:dongi/core/router/router_names.dart';
import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:dongi/shared/widgets/drawer/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
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
    });
  }

  void checkUserName() async {
    final userData = await ref.read(userNotifierProvider.future);
    if (mounted && userData != null && (userData.userName == null || userData.userName!.isEmpty)) {
      context.go(RouteName.enterName);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          appBar: AppBarWidget(),
          drawer: const DrawerWidget(),
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
}
