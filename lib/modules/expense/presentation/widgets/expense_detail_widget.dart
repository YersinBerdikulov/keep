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
import 'package:dongi/modules/expense/domain/models/expense_user_model.dart';
import 'package:appwrite/models.dart';

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

  Widget userInfoCard(BuildContext context, String userId, String title, IconData icon, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConfig.grey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColorConfig.primarySwatch25,
          width: 1,
        ),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final userAsync = ref.watch(getUserDataForExpenseProvider(userId));
          
          return Padding(
            padding: const EdgeInsets.all(12),
            child: userAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
              data: (user) => Row(
                children: [
                  CircleAvatar(
                    radius: 20,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              icon,
                              color: iconColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              title,
                              style: FontConfig.caption().copyWith(
                                color: iconColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.userName ?? user?.email ?? 'Unknown',
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
          );
        },
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
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              userInfoCard(
                context,
                expenseModel.creatorId,
                "Created by",
                Icons.person_outline,
                ColorConfig.secondary,
              ),
              const SizedBox(height: 10),
              userInfoCard(
                context,
                expenseModel.payerId,
                "Made by",
                Icons.account_balance_wallet_outlined,
                ColorConfig.primarySwatch,
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

class SplitDetailsCard extends ConsumerStatefulWidget {
  final ExpenseModel expenseModel;

  const SplitDetailsCard({super.key, required this.expenseModel});

  @override
  ConsumerState<SplitDetailsCard> createState() => _SplitDetailsCardState();
}

class _SplitDetailsCardState extends ConsumerState<SplitDetailsCard> {
  @override
  Widget build(BuildContext context) {
    // Watch the expense details to get real-time updates
    final expenseDetailsAsync = ref.watch(expenseDetailsProvider(widget.expenseModel.id!));
    
    return expenseDetailsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (expenseDetails) {
        // Use the new provider to fetch expense users
        final splitUsersAsync = ref.watch(getExpenseUsersProvider(expenseDetails.expenseUsers));
        
        return splitUsersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (users) {
            if (users.isEmpty) {
              return const Center(child: Text('No users found'));
            }

            // Fetch expense users once for all users
            final expenseUsersAsync = ref.watch(getExpenseUsersForExpenseProvider(expenseDetails.id!));
            
            return expenseUsersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (expenseUserDocs) {
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
                          Text(
                            expenseDetails.isSettled
                                ? 'Expense settled'
                                : 'Split equally between ${users.length} people',
                            style: FontConfig.body2().copyWith(
                              color: expenseDetails.isSettled ? ColorConfig.success : ColorConfig.midnight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...users.map((user) {
                            final expenseUser = expenseUserDocs.firstWhere(
                              (eu) => ExpenseUserModel.fromJson(eu.data).userId == user.id,
                              orElse: () {
                                print('Could not find expense user for userId: ${user.id}');
                                return expenseUserDocs.first;
                              },
                            );
                            final expenseUserModel = ExpenseUserModel.fromJson(expenseUser.data);
                            
                            final payerUser = users.firstWhere(
                              (u) => u.id == expenseDetails.payerId,
                              orElse: () => users.first,
                            );
                            final payerName = payerUser.userName ?? payerUser.email ?? 'Unknown';
                            
                            String subtitle;
                            if (expenseUserModel.isSettled) {
                              subtitle = "Settled";
                            } else if (user.id == expenseDetails.payerId) {
                              subtitle = "Paid \$${expenseDetails.cost.toStringAsFixed(2)}";
                            } else {
                              subtitle = "Owes \$${expenseUserModel.cost.toStringAsFixed(2)} to $payerName";
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ListTileCard(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: ColorConfig.primarySwatch.withOpacity(0.1),
                                  child: user.profileImage != null
                                      ? Image.network(
                                          user.profileImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : Text(
                                          (user.userName ?? user.email ?? "?")[0].toUpperCase(),
                                          style: FontConfig.body1().copyWith(
                                            color: ColorConfig.primarySwatch,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                                titleString: user.userName ?? user.email ?? "Unknown",
                                subtitleString: subtitle,
                                subtitleStyle: TextStyle(
                                  color: expenseUserModel.isSettled
                                      ? ColorConfig.success
                                      : user.id == expenseDetails.payerId
                                          ? ColorConfig.primarySwatch
                                          : ColorConfig.error,
                                  fontWeight: FontWeight.w500,
                                ),
                                trailing: user.id != expenseDetails.payerId && !expenseUserModel.isSettled
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          final expenseController = ref.read(expenseNotifierProvider.notifier);
                                          await expenseController.settleUpExpenseUser(expenseDetails.id!, user.id!);
                                          
                                          // Force refresh of providers
                                          ref.invalidate(expenseDetailsProvider(expenseDetails.id!));
                                          ref.invalidate(getExpenseUsersForExpenseProvider(expenseDetails.id!));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorConfig.midnight,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('Settle'),
                                      )
                                    : null,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
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
