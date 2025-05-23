import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:dongi/modules/home/domain/di/home_controller_di.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../core/constants/size_config.dart';
import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/card/card.dart';
import '../../../../shared/widgets/error/error.dart';
import '../../../../shared/widgets/image/image_widget.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../user/domain/models/user_model.dart';

class HomeExpenseSummery extends ConsumerWidget {
  const HomeExpenseSummery({super.key});

  _totalExpenseCard() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorConfig.secondary.withOpacity(0.8),
              ColorConfig.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: ColorConfig.secondary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Expense",
                  style: FontConfig.body2().copyWith(
                    color: ColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.account_balance_wallet,
                  color: ColorConfig.white,
                  size: 24,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\$140.00",
                  style: FontConfig.h4().copyWith(
                    color: ColorConfig.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "This Month",
                  style: FontConfig.overline().copyWith(
                    color: ColorConfig.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _incomeCard() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorConfig.primarySwatch.withOpacity(0.8),
              ColorConfig.primarySwatch,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: ColorConfig.primarySwatch.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Income",
                  style: FontConfig.body2().copyWith(
                    color: ColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$140.00",
                  style: FontConfig.h6().copyWith(
                    color: ColorConfig.white,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_downward_rounded,
              color: ColorConfig.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  _outcomeCard() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorConfig.error.withOpacity(0.8),
              ColorConfig.error,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: ColorConfig.error.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Outcome",
                  style: FontConfig.body2().copyWith(
                    color: ColorConfig.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$140.00",
                  style: FontConfig.h6().copyWith(
                    color: ColorConfig.white,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_upward_rounded,
              color: ColorConfig.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(child: _totalExpenseCard()),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: Column(
                children: [
                  _incomeCard(),
                  _outcomeCard(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomeRecentGroup extends StatelessWidget {
  final List<GroupModel> groups;
  const HomeRecentGroup(this.groups, {super.key});

  @override
  Widget build(BuildContext context) {
    moreCircle() {
      return InkWell(
        onTap: () => context.push(RouteName.groupList),
        child: Container(
          width: 48,
          height: 48,
          margin: const EdgeInsets.fromLTRB(10, 0, 16, 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorConfig.secondary.withOpacity(0.8),
                ColorConfig.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: ColorConfig.secondary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            color: ColorConfig.white,
            size: 24,
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Groups",
                style: FontConfig.h6(),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorConfig.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "View All",
                  style: FontConfig.caption().copyWith(
                    color: ColorConfig.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 158,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 16),
              Row(
                children:
                    groups.map((group) => GroupCardWidget(group)).toList(),
              ),
              moreCircle(),
            ],
          ),
        ),
      ],
    );
  }
}

class GroupCardWidget extends ConsumerWidget {
  final GroupModel group;
  const GroupCardWidget(this.group, {super.key});

  Widget _buildBoxCount() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: ColorConfig.primarySwatch.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                Icons.inbox_rounded,
                color: ColorConfig.primarySwatch,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                "${group.boxIds.length} Boxes",
                style: FontConfig.caption().copyWith(
                  color: ColorConfig.primarySwatch,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemberStack(AsyncValue<List<UserModel>> groupMember) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Members",
          style: FontConfig.overline().copyWith(
            color: ColorConfig.primarySwatch50,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: groupMember.when(
                loading: () => _buildMemberAvatars(
                  group.groupUsers.asMap().entries.map((val) {
                    int index = group.groupUsers.length - val.key - 1;
                    return _buildAvatar(
                      color: Colors.grey[(800 - (index * 100))],
                      left: index == 0 ? null : index * 16.0,
                    );
                  }).toList(),
                ),
                error: (error, stackTrace) => ErrorTextWidget(error),
                data: (data) => _buildMemberAvatars(
                  data.asMap().entries.map((val) {
                    int index = data.length - val.key - 1;
                    return _buildAvatar(
                      url: val.value.profileImage,
                      left: index == 0 ? null : index * 16.0,
                    );
                  }).toList(),
                ),
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: ColorConfig.primarySwatch.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.share,
                color: ColorConfig.primarySwatch,
                size: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMemberAvatars(Iterable<Widget> avatars) {
    return Stack(children: avatars.toList());
  }

  Widget _buildAvatar({Color? color, double? left, String? url}) {
    return Positioned(
      left: left,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ColorConfig.white,
            width: 2,
          ),
        ),
        child: ImageWidget(
          color: color ?? Colors.black54.withAlpha((0.3 * 255).toInt()),
          width: 28,
          height: 28,
          imageUrl: url,
          borderEnable: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupMember = ref.watch(groupMembersProvider(group.groupUsers));

    return Container(
      width: 250,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorConfig.primarySwatch25.withOpacity(0.5),
            ColorConfig.primarySwatch25.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorConfig.primarySwatch25.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConfig.primarySwatch.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push(RouteName.groupDetail(group.id)),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ColorConfig.primarySwatch25,
                          width: 2,
                        ),
                      ),
                      child: ImageWidget(
                        width: 36,
                        height: 36,
                        imageUrl: group.image,
                        borderRadius: 6,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        group.title,
                        style: FontConfig.body2().copyWith(
                          color: ColorConfig.midnight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildBoxCount(),
                const SizedBox(height: 12),
                _buildMemberStack(groupMember),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeWeeklyAnalytic extends StatelessWidget {
  HomeWeeklyAnalytic({super.key});

  final List<ChartData> chartData = <ChartData>[
    ChartData(x: "SAT", y: 5),
    ChartData(x: "SUN", y: 2),
    ChartData(x: "MON", y: 8),
    ChartData(x: "TUE", y: 4),
    ChartData(x: "WEN", y: 7),
    ChartData(x: "THU", y: 5),
    ChartData(x: "FRI", y: 10),
  ];

  chartWidget() {
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(32, 32, 32, 16),
      plotAreaBorderWidth: 0,
      primaryYAxis: CategoryAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: MajorGridLines(
          width: 1,
          dashArray: [5],
          color: ColorConfig.primarySwatch50.withOpacity(0.3),
        ),
        opposedPosition: true,
        maximum: 10,
        interval: 5,
        edgeLabelPlacement: EdgeLabelPlacement.hide,
        axisLabelFormatter: (axisLabelRenderArgs) => ChartAxisLabel(
          "\$${axisLabelRenderArgs.text}00",
          FontConfig.overline().copyWith(
            color: ColorConfig.primarySwatch50,
          ),
        ),
      ),
      primaryXAxis: CategoryAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: FontConfig.overline().copyWith(
          color: ColorConfig.primarySwatch50,
        ),
      ),
      series: <CartesianSeries<ChartData, String>>[
        ColumnSeries<ChartData, String>(
          animationDuration: 1000,
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          name: 'Expenses',
          borderRadius: BorderRadius.circular(50),
          spacing: 0.2,
          width: 0.8,
          color: ColorConfig.secondary.withOpacity(0.3),
          onPointTap: (pointInteractionDetails) {
            // Handle bar tap
          },
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        canShowMarker: false,
        format: 'point.x : \$point.y00',
        header: '',
        textStyle: FontConfig.caption().copyWith(
          color: ColorConfig.white,
        ),
        color: ColorConfig.secondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weekly Analytics",
                style: FontConfig.h6(),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ColorConfig.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "This Week",
                  style: FontConfig.caption().copyWith(
                    color: ColorConfig.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: SizeConfig.width(context) / 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: CardWidget(
              child: chartWidget(),
            ),
          ),
        ),
      ],
    );
  }
}

class HomeRecentTransaction extends ConsumerWidget {
  const HomeRecentTransaction({super.key});

  _recentTransactionsTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 10, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Recent Transactions",
            style: FontConfig.h6(),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: ColorConfig.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  "View All",
                  style: FontConfig.caption().copyWith(
                    color: ColorConfig.secondary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: ColorConfig.secondary,
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _recentTransactionsCardList(context) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 16),
          _recentTransactionsCard(
            context,
            title: "Trip to Bali",
            amount: 150.0,
            isExpense: true,
            icon: Icons.flight_takeoff_rounded,
          ),
          _recentTransactionsCard(
            context,
            title: "Salary",
            amount: 3000.0,
            isExpense: false,
            icon: Icons.work_rounded,
          ),
          _recentTransactionsCard(
            context,
            title: "Groceries",
            amount: 85.5,
            isExpense: true,
            icon: Icons.shopping_cart_rounded,
          ),
          _recentTransactionsCard(
            context,
            title: "Freelance",
            amount: 500.0,
            isExpense: false,
            icon: Icons.computer_rounded,
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }

  _recentTransactionsCard(
    context, {
    required String title,
    required double amount,
    required bool isExpense,
    required IconData icon,
  }) {
    return SizedBox(
      width: 160,
      child: CardWidget(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: FontConfig.body2()),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isExpense
                        ? ColorConfig.error.withOpacity(0.1)
                        : ColorConfig.secondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color:
                        isExpense ? ColorConfig.error : ColorConfig.secondary,
                    size: 16,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExpense ? "You spent" : "You received",
                  style: FontConfig.overline().copyWith(
                    color: ColorConfig.midnight.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${amount.toStringAsFixed(2)}",
                  style: FontConfig.body1().copyWith(
                    color:
                        isExpense ? ColorConfig.error : ColorConfig.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _recentTransactionsTitle(),
        _recentTransactionsCardList(context),
      ],
    );
  }
}

class ChartData {
  ChartData({this.x, this.y});
  final String? x;
  final double? y;
}
