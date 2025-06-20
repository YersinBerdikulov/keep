import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/constants/size_config.dart';
import '../../../../shared/widgets/appbar/sliver_appbar.dart';
import '../widgets/statistic_widget.dart';

class StatisticPage extends ConsumerWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColorConfig.primarySwatch,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '',
          style: FontConfig.h6().copyWith(color: ColorConfig.pureWhite),
        ),
      ),
      body: SliverAppBarWidget(
        height: SizeConfig.height(context) / 3.2,
        appbarTitle: const SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FiltersWidget(),
              ChartsWidget(),
            ],
          ),
        ),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            CategoriesWidget(),
            ExpensesListWidget(),
          ],
        ),
      ),
    );
  }
}
