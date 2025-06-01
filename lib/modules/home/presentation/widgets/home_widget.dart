import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:dongi/modules/home/domain/di/home_controller_di.dart';
import 'package:dongi/modules/group/domain/di/group_controller_di.dart';
import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/home/domain/controllers/home_transactions_controller.dart';

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
      mainAxisSize: MainAxisSize.min,
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
              InkWell(
                onTap: () => context.push(RouteName.groupList),
                child: Container(
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
              ),
            ],
          ),
        ),
        Container(
          height: 170,
          constraints: const BoxConstraints(maxHeight: 170),
          child: ListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 16),
              Row(
                children: groups.map((group) {
                  if (group.id != null) {
                    return GroupCardWidget(group);
                  }
                  return const SizedBox.shrink();
                }).toList(),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupMember = ref.watch(groupMembersProvider(group.groupUsers));
    final boxesInGroup = ref.watch(boxNotifierProvider(group.id!));

    // Don't render the card if the group ID is null
    if (group.id == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 150,
      height: 160, // Fixed height
      margin: const EdgeInsets.only(right: 10),
      child: CardWidget(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        padding: EdgeInsets.zero,
        backColor: ColorConfig.white,
        borderColor: ColorConfig.primarySwatch.withOpacity(0.1),
        child: InkWell(
          onTap: () {
            // Invalidate the cache to ensure we get fresh data
            ref.invalidate(groupDetailProvider(group.id!));
            ref.invalidate(boxNotifierProvider(group.id!));
            // Navigate to the group detail page
            context.push(RouteName.groupDetail(group.id!));
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Take minimum required space
              mainAxisAlignment: MainAxisAlignment.start, // Start from the top
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Group title and image row - fixed height
                SizedBox(
                  height: 36, // Fixed height for title row
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                // Boxes count
                boxesInGroup.when(
                  loading: () => _buildBoxCount("Loading..."),
                  error: (_, __) => _buildBoxCount("Error"),
                  data: (boxes) => _buildBoxCount("${boxes.length}"),
                ),
                const SizedBox(height: 8),
                // Member count
                _buildMemberCount(group.groupUsers.length),
                const Spacer(flex: 1),
                // Member stack
                _buildMemberStack(groupMember),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBoxCount(String count) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFF845EC2).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.inbox_rounded,
            size: 10,
            color: Color(0xFF845EC2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "Boxes",
          style: FontConfig.caption().copyWith(
            color: ColorConfig.primarySwatch50,
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            count,
            style: FontConfig.body2().copyWith(
              fontWeight: FontWeight.w600,
              color: ColorConfig.midnight,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCount(int count) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xFF00B8A9).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.group_outlined,
            size: 10,
            color: Color(0xFF00B8A9),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          "Members",
          style: FontConfig.caption().copyWith(
            color: ColorConfig.primarySwatch50,
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            "$count",
            style: FontConfig.body2().copyWith(
              fontWeight: FontWeight.w600,
              color: ColorConfig.midnight,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildMemberStack(AsyncValue<List<UserModel>> groupMember) {
    return groupMember.when(
      loading: () => const SizedBox(height: 28),
      error: (_, __) => const SizedBox(height: 28),
      data: (members) {
        final memberAvatars = members.asMap().entries.map((entry) {
          final index = entry.key;
          final member = entry.value;
          return _buildAvatar(
            left: index * 20.0,
            url: member.profileImage,
          );
        });

        return SizedBox(
          height: 28,
          child: _buildMemberAvatars(memberAvatars),
        );
      },
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
}

class HomeWeeklyAnalytic extends ConsumerStatefulWidget {
  HomeWeeklyAnalytic({super.key});

  @override
  ConsumerState<HomeWeeklyAnalytic> createState() => _HomeWeeklyAnalyticState();
}

class _HomeWeeklyAnalyticState extends ConsumerState<HomeWeeklyAnalytic> {
  String? selectedDay;
  List<RecentTransactionModel> dayTransactions = [];

  // Helper method to get the week day name from a date
  String _getDayName(DateTime date) {
    print(
        'Getting day name for date: ${date.toString()}, weekday: ${date.weekday}');
    switch (date.weekday) {
      case DateTime.monday:
        return "MON";
      case DateTime.tuesday:
        return "TUE";
      case DateTime.wednesday:
        return "WED";
      case DateTime.thursday:
        return "THU";
      case DateTime.friday:
        return "FRI";
      case DateTime.saturday:
        return "SAT";
      case DateTime.sunday:
        return "SUN";
      default:
        return "";
    }
  }

  // Generate chart data from transactions
  List<ChartData> _generateChartData(
      List<RecentTransactionModel> transactions) {
    // Get the current date
    final now = DateTime.now();
    print('Current date and time: ${now.toString()}');

    // Calculate start of week (Monday)
    // If today is Monday (weekday = 1), startOfWeek is today
    // Otherwise, go back to the most recent Monday
    final startOfWeek =
        DateTime(now.year, now.month, now.day - (now.weekday - 1));

    print('Generating chart data from ${transactions.length} transactions');
    print('Current date: ${now.toString()}');
    print('Start of week (Monday): ${startOfWeek.toString()}');

    // Initialize a map to hold daily totals
    final Map<String, double> dailyTotals = {};

    // Initialize with all days of the week with zero values (Monday to Sunday)
    final dayOrder = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final dayName = _getDayName(day);
      dailyTotals[dayName] = 0.0;
      print('Initialized day: $dayName for ${day.toString()}');
    }

    print('Initial daily totals: $dailyTotals');

    // Sum up transactions for each day of the current week
    for (var transaction in transactions) {
      if (transaction.createdAt.isNotEmpty) {
        try {
          final transactionDate = DateTime.parse(transaction.createdAt);
          print(
              'Transaction date: ${transactionDate.toString()}, Amount: ${transaction.cost}');

          // Calculate the transaction day without time component
          final transactionDay = DateTime(
              transactionDate.year, transactionDate.month, transactionDate.day);

          // Calculate days since start of week
          final daysSinceStartOfWeek =
              transactionDay.difference(startOfWeek).inDays;

          // Check if the transaction is from the current week (0-6 days from start of week)
          if (daysSinceStartOfWeek >= 0 && daysSinceStartOfWeek < 7) {
            final dayName = _getDayName(transactionDay);
            print(
                'Transaction day: $dayName, Days since start of week: $daysSinceStartOfWeek');
            dailyTotals[dayName] =
                (dailyTotals[dayName] ?? 0) + transaction.cost.toDouble();
            print(
                'Added to $dayName: ${transaction.cost}, new total: ${dailyTotals[dayName]}');
          } else {
            print(
                'Transaction outside current week range: $daysSinceStartOfWeek days from start of week');
          }
        } catch (e) {
          print('Error parsing date: ${transaction.createdAt}, Error: $e');
        }
      } else {
        print('Empty createdAt field in transaction');
      }
    }

    print('Final daily totals: $dailyTotals');

    // Convert to chart data format
    final chartData = dayOrder
        .map((day) => ChartData(x: day, y: dailyTotals[day] ?? 0.0))
        .toList();

    print('Chart data points: ${chartData.length}');
    for (var data in chartData) {
      print('Day: ${data.x}, Value: ${data.y}');
    }

    return chartData;
  }

  // Get transactions for a specific day
  List<RecentTransactionModel> _getTransactionsForDay(
      List<RecentTransactionModel> allTransactions, String dayName) {
    // Get the current date
    final now = DateTime.now();

    // Calculate start of week (Monday)
    final startOfWeek =
        DateTime(now.year, now.month, now.day - (now.weekday - 1));

    // Find the date for the selected day
    final dayOrder = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
    final dayIndex = dayOrder.indexOf(dayName);
    final selectedDate = startOfWeek.add(Duration(days: dayIndex));

    print('Getting transactions for $dayName (${selectedDate.toString()})');

    // Filter transactions for the selected day
    final result = allTransactions.where((transaction) {
      if (transaction.createdAt.isNotEmpty) {
        try {
          final transactionDate = DateTime.parse(transaction.createdAt);

          // Compare year, month, and day only (ignore time)
          final transactionDay = DateTime(
              transactionDate.year, transactionDate.month, transactionDate.day);

          final selectedDay =
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

          final isSameDay = transactionDay.isAtSameMomentAs(selectedDay);

          if (isSameDay) {
            print(
                'Found matching transaction: ${transaction.title}, ${transaction.cost}');
          }

          return isSameDay;
        } catch (e) {
          print('Error parsing date: ${transaction.createdAt}, Error: $e');
          return false;
        }
      }
      return false;
    }).toList();

    print('Found ${result.length} transactions for $dayName');
    return result;
  }

  chartWidget(
      List<ChartData> chartData, List<RecentTransactionModel> allTransactions) {
    // Find the maximum expense value for the Y-axis
    double maxExpense = 0;
    for (var data in chartData) {
      if (data.y > maxExpense) maxExpense = data.y;
    }
    // Round up to the nearest 10 for a cleaner Y-axis
    maxExpense = ((maxExpense / 10).ceil() * 10).toDouble();
    // Ensure minimum scale
    maxExpense = maxExpense < 10 ? 10 : maxExpense;

    print('Max expense for chart: $maxExpense');

    // Get current day name to highlight it
    final currentDayName = _getDayName(DateTime.now());
    print('Current day name: $currentDayName');

    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(32, 32, 32, 16),
      plotAreaBorderWidth: 0,
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: MajorGridLines(
          width: 1,
          dashArray: [5],
          color: ColorConfig.primarySwatch50.withOpacity(0.3),
        ),
        opposedPosition: true,
        minimum: 0,
        maximum: maxExpense,
        interval: maxExpense > 0 ? maxExpense / 2 : 5,
        labelFormat: '\${value}',
        labelStyle: FontConfig.overline().copyWith(
          color: ColorConfig.primarySwatch50,
        ),
      ),
      primaryXAxis: CategoryAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        labelStyle: FontConfig.overline().copyWith(
          color: ColorConfig.primarySwatch50,
        ),
        // Ensure the days are displayed in order from Monday to Sunday
        arrangeByIndex: true,
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
          pointColorMapper: (ChartData data, _) {
            // Highlight selected day first, then current day, then default color
            if (data.x == selectedDay) {
              return ColorConfig.primarySwatch;
            } else if (data.x == currentDayName) {
              return ColorConfig.secondary;
            } else {
              return ColorConfig.secondary.withOpacity(0.3);
            }
          },
          onPointTap: (pointInteractionDetails) {
            final pointIndex = pointInteractionDetails.pointIndex;
            if (pointIndex != null &&
                pointIndex >= 0 &&
                pointIndex < chartData.length) {
              final tappedDay = chartData[pointIndex].x;
              print('Tapped on day: $tappedDay at index $pointIndex');
              setState(() {
                // Toggle selection
                selectedDay = selectedDay == tappedDay ? null : tappedDay;
                if (selectedDay != null) {
                  dayTransactions =
                      _getTransactionsForDay(allTransactions, selectedDay!);
                  print(
                      'Selected day: $selectedDay, found ${dayTransactions.length} transactions');
                } else {
                  dayTransactions = [];
                }
              });
            }
          },
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        canShowMarker: false,
        format: 'point.x : \$point.y',
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
    // Get transactions data
    final transactionsProvider = ref.watch(homeTransactionsProvider);

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
              Row(
                children: [
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
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      // Refresh transactions data
                      ref.invalidate(homeTransactionsProvider);
                      // Clear selection
                      setState(() {
                        selectedDay = null;
                        dayTransactions = [];
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: ColorConfig.secondary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.refresh,
                        color: ColorConfig.secondary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
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
              child: transactionsProvider.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error loading analytics: $error'),
                ),
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bar_chart,
                            size: 48,
                            color: ColorConfig.secondary.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No transaction data yet",
                            style: FontConfig.body2().copyWith(
                              color: ColorConfig.midnight.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Add expenses to see your weekly analytics",
                            style: FontConfig.caption().copyWith(
                              color: ColorConfig.midnight.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final chartData = _generateChartData(transactions);
                  if (chartData.every((data) => data.y == 0)) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bar_chart,
                            size: 48,
                            color: ColorConfig.secondary.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No expenses this week",
                            style: FontConfig.body2().copyWith(
                              color: ColorConfig.midnight.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Your weekly spending chart will appear here",
                            style: FontConfig.caption().copyWith(
                              color: ColorConfig.midnight.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return chartWidget(chartData, transactions);
                },
              ),
            ),
          ),
        ),
        // Show day detail if a day is selected
        if (selectedDay != null && dayTransactions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: CardWidget(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$selectedDay Transactions",
                        style: FontConfig.body1().copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedDay = null;
                            dayTransactions = [];
                          });
                        },
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: ColorConfig.midnight.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...dayTransactions
                      .take(3)
                      .map(
                        (transaction) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: ColorConfig.secondary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet,
                                  color: ColorConfig.secondary,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  transaction.title,
                                  style: FontConfig.caption(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                "\$${transaction.cost.toStringAsFixed(2)}",
                                style: FontConfig.caption().copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: ColorConfig.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  if (dayTransactions.length > 3)
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to a filtered view of transactions for this day
                          ref.invalidate(homeTransactionsProvider);
                          context.push(RouteName.allTransactions);
                        },
                        child: Text(
                          "View all ${dayTransactions.length} transactions",
                          style: FontConfig.caption().copyWith(
                            color: ColorConfig.secondary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        transactionsProvider.when(
          loading: () => const SizedBox(),
          error: (_, __) => const SizedBox(),
          data: (transactions) {
            // Calculate weekly summary
            final now = DateTime.now();
            // Calculate start of week (Monday)
            final startOfWeek =
                DateTime(now.year, now.month, now.day - (now.weekday - 1));

            double weeklyTotal = 0;
            int transactionCount = 0;

            // Sum up transactions for the week
            for (var transaction in transactions) {
              if (transaction.createdAt.isNotEmpty) {
                try {
                  final transactionDate = DateTime.parse(transaction.createdAt);
                  final transactionDay = DateTime(transactionDate.year,
                      transactionDate.month, transactionDate.day);

                  // Calculate days since start of week
                  final daysSinceStartOfWeek =
                      transactionDay.difference(startOfWeek).inDays;

                  // Check if the transaction is from the current week (0-6 days from start of week)
                  if (daysSinceStartOfWeek >= 0 && daysSinceStartOfWeek < 7) {
                    weeklyTotal += transaction.cost.toDouble();
                    transactionCount++;
                  }
                } catch (e) {
                  print(
                      'Error parsing date in weekly summary: ${e.toString()}');
                }
              }
            }

            // Calculate average daily expense
            // Calculate how many days have passed in the current week
            final daysPassedInWeek = now.weekday; // Monday=1, Sunday=7
            final dailyAverage =
                daysPassedInWeek > 0 ? weeklyTotal / daysPassedInWeek : 0;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: CardWidget(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Weekly Total",
                            style: FontConfig.caption().copyWith(
                              color: ColorConfig.midnight.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "\$${weeklyTotal.toStringAsFixed(2)}",
                            style: FontConfig.h6().copyWith(
                              color: ColorConfig.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$transactionCount transactions",
                            style: FontConfig.overline().copyWith(
                              color: ColorConfig.midnight.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CardWidget(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daily Average",
                            style: FontConfig.caption().copyWith(
                              color: ColorConfig.midnight.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "\$${dailyAverage.toStringAsFixed(2)}",
                            style: FontConfig.h6().copyWith(
                              color: ColorConfig.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "This week",
                            style: FontConfig.overline().copyWith(
                              color: ColorConfig.midnight.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class HomeRecentTransaction extends ConsumerWidget {
  const HomeRecentTransaction({super.key});

  _recentTransactionsTitle(BuildContext context, WidgetRef ref) {
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
          InkWell(
            onTap: () {
              // Refresh transactions data before navigating
              ref.invalidate(homeTransactionsProvider);
              // Navigate to the AllTransactionsPage
              context.push(RouteName.allTransactions);
            },
            child: Container(
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
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String? categoryId) {
    // Map category IDs to appropriate icons
    // This would ideally come from a categories provider
    switch (categoryId) {
      case 'food':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_car;
      case 'entertainment':
        return Icons.movie;
      case 'shopping':
        return Icons.shopping_cart;
      case 'bills':
        return Icons.receipt;
      case 'health':
        return Icons.medical_services;
      case 'travel':
        return Icons.flight;
      case 'education':
        return Icons.school;
      default:
        return Icons.account_balance_wallet;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsProvider = ref.watch(homeTransactionsProvider);

    // Function to refresh transaction data
    void refreshTransactions() {
      ref.invalidate(homeTransactionsProvider);
    }

    return Column(
      children: [
        _recentTransactionsTitle(context, ref),
        transactionsProvider.when(
            loading: () => const Center(
                  child: SizedBox(
                    height: 120,
                    child: CircularProgressIndicator(),
                  ),
                ),
            error: (error, stack) => Center(
                  child: SizedBox(
                    height: 120,
                    child: Text('Error: $error'),
                  ),
                ),
            data: (transactions) {
              // Get only the most recent 5 transactions for the home page preview
              final recentTransactions = ref
                  .read(homeTransactionsProvider.notifier)
                  .getRecentTransactions();

              if (recentTransactions.isEmpty) {
                return const SizedBox(
                  height: 120,
                  child: Center(
                    child: Text('No recent transactions'),
                  ),
                );
              }

              return SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: recentTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = recentTransactions[index];
                    return SizedBox(
                      width: 160,
                      child: CardWidget(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            // Navigate to expense detail page when clicked
                            if (transaction.id.isNotEmpty) {
                              // Pass expense ID as an extra parameter rather than in the URL path
                              context.push(
                                RouteName.expenseDetail,
                                extra: {'expenseId': transaction.id},
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      transaction.title,
                                      style: FontConfig.body2(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: ColorConfig.secondary
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(transaction.categoryId),
                                      color: ColorConfig.secondary,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction.creatorId ==
                                            (ref
                                                    .read(currentUserProvider)
                                                    ?.id ??
                                                '')
                                        ? "You paid"
                                        : "You owe",
                                    style: FontConfig.overline().copyWith(
                                      color:
                                          ColorConfig.midnight.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "\$${transaction.cost.toStringAsFixed(2)}",
                                    style: FontConfig.body1().copyWith(
                                      color: transaction.creatorId ==
                                              (ref
                                                      .read(currentUserProvider)
                                                      ?.id ??
                                                  '')
                                          ? ColorConfig.error
                                          : ColorConfig.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
      ],
    );
  }
}

class ChartData {
  ChartData({required this.x, required this.y});
  final String x;
  final double y;

  @override
  String toString() => 'ChartData(x: $x, y: $y)';
}
