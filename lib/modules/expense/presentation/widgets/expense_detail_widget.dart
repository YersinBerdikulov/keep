import 'package:dongi/shared/utilities/extensions/date_extension.dart';
import 'package:dongi/modules/expense/domain/models/expense_model.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:dongi/modules/expense/domain/di/expense_controller_di.dart';
import 'package:dongi/shared/widgets/card/grey_card.dart';
import 'package:dongi/shared/widgets/list_tile/list_tile.dart';
import 'package:dongi/shared/widgets/list_tile/list_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:dongi/modules/box/domain/controllers/box_controller.dart';
import 'package:dongi/modules/user/domain/models/user_model.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../shared/widgets/error/error.dart';
import '../../../../shared/widgets/friends/friend.dart';
import '../../../../shared/widgets/loading/loading.dart';

class UserInfoExpenseDetail extends ConsumerWidget {
  final String creatorId;
  const UserInfoExpenseDetail({super.key, required this.creatorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creator = ref.watch(getUserDataForExpenseProvider(creatorId));

    return creator.when(
      loading: () => const LoadingWidget(),
      error: (error, _) => ErrorTextWidget(error),
      data: (user) => Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorConfig.primarySwatch.withOpacity(0.1),
            backgroundImage: user?.profileImage != null
                ? NetworkImage(user!.profileImage!)
                : null,
            child: user?.profileImage == null
                ? Text(
                    user?.userName?.isNotEmpty == true
                        ? user!.userName![0].toUpperCase()
                        : '?',
                    style: FontConfig.body1().copyWith(
                      color: ColorConfig.primarySwatch,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Created By',
                style: FontConfig.caption().copyWith(
                  color: ColorConfig.primarySwatch50,
                ),
              ),
              Text(
                user?.userName ?? user?.email ?? 'Unknown',
                style: FontConfig.body1().copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//class BoxReviewExpenseDetail extends ConsumerWidget {
//  final List<Widget> children;
//  const BoxReviewExpenseDetail(this.children, {super.key});
//  @override
//  Widget build(BuildContext context, WidgetRef ref) {
//    return Expanded(
//      flex: 3,
//      child: Container(
//        decoration: BoxDecoration(
//          color: ColorConfig.white,
//          borderRadius: const BorderRadius.only(
//            topLeft: Radius.circular(15),
//            topRight: Radius.circular(15),
//          ),
//        ),
//        child: ListView(
//          children: [
//            Column(children: children),
//          ],
//        ),
//      ),
//    );
//  }
//}

class InfoExpenseDetail extends ConsumerWidget {
  final ExpenseModel expenseModel;

  const InfoExpenseDetail({super.key, required this.expenseModel});

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Unknown date';
    try {
      final date = DateTime.parse(dateStr);
      final month = _getMonthName(date.month).toLowerCase();
      return '${date.day} $month ${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Widget infoCard(String title, String content,
      {required IconData icon, Color? iconColor, bool isDate = false}) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: ColorConfig.grey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorConfig.primarySwatch25,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: iconColor ?? ColorConfig.secondary,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    title,
                    style: FontConfig.caption().copyWith(
                      color: ColorConfig.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      content,
                      style: FontConfig.h6().copyWith(
                        color: ColorConfig.midnight,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: [
              infoCard(
                "Amount",
                _formatCurrency(expenseModel.cost),
                icon: Icons.account_balance_wallet,
                iconColor: ColorConfig.secondary,
              ),
              const SizedBox(width: 10),
              infoCard(
                "Date",
                _formatDate(expenseModel.createdAt),
                icon: Icons.calendar_today,
                iconColor: ColorConfig.primarySwatch,
                isDate: true,
              ),
              const SizedBox(width: 10),
              infoCard(
                "Split By",
                "${expenseModel.expenseUsers.length} people",
                icon: Icons.group,
                iconColor: ColorConfig.error,
              ),
            ],
          ),
        ),
        if (expenseModel.categoryId != null) ...[
          const SizedBox(height: 16),
          CategoryInfoCard(categoryId: expenseModel.categoryId!),
        ],
      ],
    );
  }

  String _formatCurrency(num amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}

class SplitDetailsCard extends ConsumerWidget {
  final ExpenseModel expenseModel;

  const SplitDetailsCard({super.key, required this.expenseModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Building SplitDetailsCard for expense: ${expenseModel.id}');
    print('Expense users: ${expenseModel.expenseUsers}');
    
    // Use the new provider to fetch expense users
    final splitUsersAsync = ref.watch(getExpenseUsersProvider(expenseModel.expenseUsers));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConfig.grey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorConfig.primarySwatch25,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: ColorConfig.secondary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Split Details',
                        style: FontConfig.caption().copyWith(
                          color: ColorConfig.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement settle up functionality
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Settle Up',
                            style: FontConfig.h6().copyWith(
                              color: ColorConfig.midnight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          content: Text(
                            'This feature is coming soon!',
                            style: FontConfig.body2().copyWith(
                              color: ColorConfig.primarySwatch50,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'OK',
                                style: FontConfig.button().copyWith(
                                  color: ColorConfig.primarySwatch,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: ColorConfig.white,
                      size: 16,
                    ),
                    label: Text(
                      'Settle Up',
                      style: FontConfig.button().copyWith(
                        color: ColorConfig.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConfig.primarySwatch,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              splitUsersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) {
                  print('Error loading split users: $error');
                  print('Stack trace: $stack');
                  return Center(
                    child: Text('Error: $error'),
                  );
                },
                data: (users) {
                  print('Loaded users: ${users.map((u) => u.id).toList()}');
                  if (users.isEmpty) {
                    return const Center(
                      child: Text('No users found'),
                    );
                  }

                  final perPersonAmount = expenseModel.cost / users.length;
                  final payer = users.firstWhere(
                    (u) => u.id == expenseModel.payerId,
                    orElse: () => users.first,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Split equally between ${users.length} people',
                        style: FontConfig.body2().copyWith(
                          color: ColorConfig.midnight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...users.map((user) {
                        final isOwing = user.id != expenseModel.payerId;
                        final subtitle = isOwing 
                          ? "Owes ${payer.userName ?? payer.email ?? 'Unknown'} \$${perPersonAmount.toStringAsFixed(2)}"
                          : "Paid \$${expenseModel.cost.toStringAsFixed(2)}";

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ListTileCard(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: ColorConfig.primarySwatch25,
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: user.profileImage != null
                                    ? Image.network(
                                        user.profileImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: ColorConfig.primarySwatch.withOpacity(0.1),
                                        child: Center(
                                          child: Text(
                                            (user.userName ?? user.email ?? "?")[0].toUpperCase(),
                                            style: FontConfig.body1().copyWith(
                                              color: ColorConfig.primarySwatch,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            titleString: user.userName ?? user.email ?? "Unknown",
                            subtitleString: subtitle,
                            subtitleStyle: TextStyle(
                              color: isOwing ? ColorConfig.error : ColorConfig.primarySwatch,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryInfoCard extends ConsumerWidget {
  final String categoryId;

  const CategoryInfoCard({super.key, required this.categoryId});

  Map<String, IconData> getCategoryIcon() {
    return {
      'food': Icons.restaurant,
      'transportation': Icons.directions_car,
      'entertainment': Icons.movie,
      'shopping': Icons.shopping_bag,
      'bills': Icons.receipt,
      'health': Icons.medical_services,
      'travel': Icons.flight,
      'education': Icons.school,
      'others': Icons.category_outlined,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConfig.grey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorConfig.primarySwatch25,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorConfig.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.category,
                  color: ColorConfig.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Category",
                      style: FontConfig.overline().copyWith(
                        color: ColorConfig.primarySwatch50,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categoryId,
                      style: FontConfig.body1().copyWith(
                        fontWeight: FontWeight.w600,
                        color: ColorConfig.midnight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MemberListExpenseDetail extends ConsumerWidget {
  final List<String> members;
  const MemberListExpenseDetail({super.key, required this.members});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Handle empty members list
    if (members.isEmpty) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 25, 16, 25),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: ColorConfig.grey,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorConfig.primarySwatch25,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorConfig.primarySwatch.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.group_off_outlined,
                size: 32,
                color: ColorConfig.primarySwatch,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No Members Yet",
              style: FontConfig.h6().copyWith(
                color: ColorConfig.midnight,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "This expense hasn't been split with anyone",
              textAlign: TextAlign.center,
              style: FontConfig.body2().copyWith(
                color: ColorConfig.primarySwatch50,
              ),
            ),
          ],
        ),
      );
    }

    final expenseMember = ref.watch(getUsersListData(members));

    return expenseMember.when(
      loading: () => const LoadingWidget(),
      error: (error, stackTrace) => ErrorTextWidget(error),
      data: (data) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 25),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTileCard(
                  titleString: data[index].userName ?? data[index].email,
                  trailing: const Text("\$53"),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: ColorConfig.primarySwatch,
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
