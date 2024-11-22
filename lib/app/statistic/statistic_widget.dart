import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../core/constants/color_config.dart';
import '../../core/constants/font_config.dart';
import '../../widgets/card/category_card.dart';
import '../../widgets/list_tile/list_tile_card.dart';

class FiltersWidget extends StatelessWidget {
  const FiltersWidget({super.key});

  Expanded filterCardItem({required String title}) {
    return Expanded(
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: ColorConfig.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            title,
            style: FontConfig.button(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        filterCardItem(title: 'day'),
        const SizedBox(width: 10),
        filterCardItem(title: 'week'),
        const SizedBox(width: 10),
        filterCardItem(title: 'month'),
        const SizedBox(width: 10),
        filterCardItem(title: 'year'),
      ],
    );
  }
}

class ChartsWidget extends StatelessWidget {
  const ChartsWidget({super.key});

  static final TooltipBehavior _tooltipBehavior =
      TooltipBehavior(enable: true, header: '', canShowMarker: false);

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = <ChartData>[
      ChartData(title: "SAT", y: 5, x: 1),
      ChartData(title: "SUN", y: 2, x: 2),
      ChartData(title: "MON", y: 8, x: 3),
      ChartData(title: "TUE", y: 4, x: 4),
      ChartData(title: "WEN", y: 7, x: 5),
      ChartData(title: "THU", y: 5, x: 6),
    ];

    ChartAxisLabel labelFormat(AxisLabelRenderDetails axisLabelRenderArgs) {
      return ChartAxisLabel(
        chartData[int.parse(axisLabelRenderArgs.text) - 1].title,
        FontConfig.overline().copyWith(color: ColorConfig.white),
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      height: 125,
      child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0,
        primaryYAxis: CategoryAxis(isVisible: false),
        primaryXAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          interval: 1,
          labelPosition: ChartDataLabelPosition.outside,
          majorTickLines: const MajorTickLines(width: 0),
          majorGridLines: MajorGridLines(
            width: 1,
            color: ColorConfig.white.withOpacity(0.1),
          ),
          axisLabelFormatter: labelFormat,
        ),
        // series: <ChartSeries<ChartData, double>>[
        //   SplineSeries<ChartData, double>(
        //     animationDuration: 1000,
        //     dataSource: chartData,
        //     xValueMapper: (ChartData data, _) => data.x!,
        //     yValueMapper: (ChartData data, _) => data.y!,
        //     name: 'Unit Sold',
        //     color: ColorConfig.primarySwatch25,
        //   ),
        // ],
        tooltipBehavior: _tooltipBehavior,
      ),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Categories',
                style: FontConfig.body1(),
              ),
              const Spacer(),
              Text(
                'show more',
                style: FontConfig.overline().copyWith(
                  color: ColorConfig.primarySwatch.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 115,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(width: 16),
              ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const Row(
                    children: [
                      CategoryCardWidget(
                        name: 'category name',
                        balance: '\$ 210,000',
                      ),
                      SizedBox(width: 10),
                    ],
                  );
                },
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class ExpensesListWidget extends StatelessWidget {
  const ExpensesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expenses',
            style: FontConfig.body1(),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 15,
            itemBuilder: (context, i) {
              return Column(
                children: [
                  ListTileCard(
                    leading: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: ColorConfig.primarySwatch,
                        shape: BoxShape.circle,
                      ),
                    ),
                    titleString: 'expense title',
                    trailing: const Text("\$53"),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData({this.x, this.y, required this.title});
  final String title;
  final double? x;
  final double? y;
}
