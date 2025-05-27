import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/color_config.dart';
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
          appBar: AppBarWidget(),
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
