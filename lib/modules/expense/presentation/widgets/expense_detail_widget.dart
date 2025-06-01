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
import 'package:dongi/modules/expense/data/di/expense_di.dart';
import 'package:dongi/modules/user/data/di/user_di.dart';
import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';

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
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
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

  Widget userInfoCard(BuildContext context, String userId, String title,
      IconData icon, Color iconColor) {
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
  // Change to use nullable String keys
  final Map<String?, bool> _userLoadingStates = {};
  final Map<String?, bool> _userSettlementStates = {};

  @override
  void initState() {
    super.initState();
    // Initialize states on widget creation
    _refreshExpenseData();
  }

  Future<void> _refreshExpenseData() async {
    if (!mounted) return;

    // Safety check for expense ID
    final expenseId = widget.expenseModel.id;
    if (expenseId == null) {
      print('Cannot refresh: expense ID is null');
      return;
    }

    try {
      // Use the expenseNotifier to get data instead of direct repository access
      final expenseNotifier = ref.read(expenseNotifierProvider.notifier);
      final expenseModel = await expenseNotifier.getExpenseDetail(expenseId);

      if (expenseModel == null || !mounted) return;

      // Use the expenseDetailsProvider to get the expense users safely
      final expenseUsersProvider =
          getExpenseUsersForExpenseProvider(expenseModel.id!);
      final expenseUsersAsyncValue =
          await ref.read(expenseUsersProvider.future);

      if (!mounted) return;

      setState(() {
        for (var expenseUser in expenseUsersAsyncValue) {
          if (expenseUser.data == null) continue;

          try {
            final expenseUserModel =
                ExpenseUserModel.fromJson(expenseUser.data);
            final userId = expenseUserModel.userId;

            // userId can be null, which is fine for our Map with nullable keys
            _userSettlementStates[userId] = expenseUserModel.isSettled;
            _userLoadingStates[userId] = false;
          } catch (e) {
            print('Error processing expense user: $e');
            // Continue with next expense user if there's an error
          }
        }
      });
    } catch (e) {
      print('Error loading expense data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load expense data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safety check for null ID
    final expenseId = widget.expenseModel.id;
    if (expenseId == null) {
      return const Center(child: Text('Invalid expense ID'));
    }

    // Watch the expense details to get real-time updates
    final expenseDetailsAsync = ref.watch(expenseDetailsProvider(expenseId));

    // Listen for changes in expense details
    ref.listen(expenseDetailsProvider(expenseId), (previous, next) {
      // Only proceed if both values are not null and are of the right type
      if (previous != null &&
          next != null &&
          previous is AsyncData<ExpenseModel> &&
          next is AsyncData<ExpenseModel>) {
        // Only refresh if the data actually changed
        if (previous.value?.id != next.value?.id ||
            previous.value?.updatedAt != next.value?.updatedAt) {
          print('Expense details changed, refreshing data');
          _refreshExpenseData();
        }
      }
    });

    // Handle the result of the watch
    return expenseDetailsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${error.toString().split('\n')[0]}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Invalidate providers and retry
                ref.invalidate(expenseDetailsProvider(expenseId));
                ref.invalidate(getExpenseUsersForExpenseProvider(expenseId));
                _refreshExpenseData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (expenseDetails) {
        // Use the provider to fetch expense users
        final splitUsersAsync =
            ref.watch(getExpenseUsersProvider(expenseDetails.expenseUsers));

        return splitUsersAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Error fetching users: ${error.toString().split('\n')[0]}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(
                        getExpenseUsersProvider(expenseDetails.expenseUsers));
                    _refreshExpenseData();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (users) {
            // Get the first expense user to determine split type
            final expenseUsersProvider =
                getExpenseUsersForExpenseProvider(expenseDetails.id!);
            final expenseUsersAsync = ref.watch(expenseUsersProvider);

            return expenseUsersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (expenseUsers) {
                if (expenseUsers.isEmpty) {
                  return const Center(child: Text('No expense users found'));
                }

                // Get split type from the first expense user
                final firstExpenseUser =
                    ExpenseUserModel.fromJson(expenseUsers.first.data);
                final splitType = firstExpenseUser.splitType;

                // Build split type description
                String splitDescription;
                if (expenseDetails.isSettled) {
                  splitDescription = 'Expense settled';
                } else {
                  switch (splitType) {
                    case 'equal':
                      if (users.length == 1) {
                        // Get the expense user data to determine who owes
                        final expenseUser = expenseUsers.first;
                        final expenseUserModel =
                            ExpenseUserModel.fromJson(expenseUser.data);

                        // Find who paid (the creditor)
                        final creditor = users.firstWhere(
                          (u) => u.id == expenseDetails.payerId,
                          orElse: () => users.first,
                        );

                        // Find who owes (the debtor) from the expenseUsers data
                        final debtor = users.firstWhere(
                          (u) => u.id == expenseUserModel.userId,
                          orElse: () => users.first,
                        );

                        // Only show "owes full amount" if the debtor is different from the creditor
                        if (debtor.id != creditor.id) {
                          splitDescription =
                              'Full amount (Total: ${expenseDetails.cost} \$)';
                        } else {
                          // Fallback description if something is wrong with the data
                          splitDescription =
                              'Split with 1 person (Total: ${expenseDetails.cost} \$)';
                        }
                      } else {
                        splitDescription =
                            'Split equally between ${users.length} people (Total: ${expenseDetails.cost} \$)';
                      }
                      break;
                    case 'percentage':
                      final totalPercentage = expenseUsers
                          .map((eu) => ExpenseUserModel.fromJson(eu.data)
                              .sharePercentage)
                          .fold(0.0, (sum, percent) => sum + (percent ?? 0));
                      splitDescription = users.length == 1
                          ? 'Split by percentage with 1 person (Total: ${expenseDetails.cost} \$)'
                          : 'Split by percentage between ${users.length} people (Total: ${expenseDetails.cost} \$)';
                      break;
                    case 'amount':
                      final totalAmount = expenseUsers
                          .map((eu) =>
                              ExpenseUserModel.fromJson(eu.data).shareAmount)
                          .fold(0.0, (sum, amount) => sum + (amount ?? 0));
                      splitDescription = users.length == 1
                          ? 'Split by custom amount with 1 person (\$${totalAmount.toStringAsFixed(2)})'
                          : 'Split by custom amounts between ${users.length} people (\$${totalAmount.toStringAsFixed(2)})';
                      break;
                    case 'shares':
                      final totalShares = expenseUsers
                          .map(
                              (eu) => ExpenseUserModel.fromJson(eu.data).shares)
                          .fold(0.0, (sum, shares) => sum + (shares ?? 0));
                      splitDescription = users.length == 1
                          ? 'Split by shares with 1 person (${totalShares.toStringAsFixed(0)} shares)'
                          : 'Split by shares between ${users.length} people (${totalShares.toStringAsFixed(0)} shares)';
                      break;
                    default:
                      splitDescription = users.length == 1
                          ? 'Split with 1 person'
                          : 'Split between ${users.length} people';
                  }
                }

                return Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  decoration: BoxDecoration(
                    color: ColorConfig.grey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ColorConfig.primarySwatch25,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                splitDescription,
                                style: FontConfig.body2().copyWith(
                                  color: expenseDetails.isSettled
                                      ? ColorConfig.success
                                      : ColorConfig.midnight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Refreshing data...'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                                try {
                                  await _refreshExpenseData();
                                  ref.invalidate(
                                      expenseDetailsProvider(expenseId));
                                  ref.invalidate(
                                      getExpenseUsersForExpenseProvider(
                                          expenseId));
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Data refreshed'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error refreshing: $e'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.refresh, size: 16),
                              label: const Text('Refresh'),
                              style: TextButton.styleFrom(
                                foregroundColor: ColorConfig.secondary,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                minimumSize: const Size(0, 32),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            if (user.id == null) return const SizedBox.shrink();

                            final expenseUser = expenseUsers.firstWhere(
                              (eu) =>
                                  ExpenseUserModel.fromJson(eu.data).userId ==
                                  user.id,
                              orElse: () => expenseUsers.first,
                            );
                            final expenseUserModel =
                                ExpenseUserModel.fromJson(expenseUser.data);

                            String amountText;
                            switch (splitType) {
                              case 'percentage':
                                amountText =
                                    '${expenseUserModel.sharePercentage.toStringAsFixed(1)}% (${expenseUserModel.shareAmount.toStringAsFixed(2)} \$)';
                                break;
                              case 'shares':
                                amountText =
                                    '${expenseUserModel.shares} shares (${expenseUserModel.shareAmount.toStringAsFixed(2)} \$)';
                                break;
                              default:
                                amountText =
                                    '${expenseUserModel.shareAmount.toStringAsFixed(2)} \$';
                            }

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundImage: user.profileImage != null
                                        ? NetworkImage(user.profileImage!)
                                        : null,
                                    child: user.profileImage == null
                                        ? Text(
                                            user.userName?[0] ?? user.email[0],
                                            style: FontConfig.h6(),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.userName ?? user.email,
                                          style: FontConfig.body1().copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          amountText,
                                          style: FontConfig.caption().copyWith(
                                            color: ColorConfig.secondary,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!expenseDetails.isSettled)
                                    _userLoadingStates[user.id] == true
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : _userSettlementStates[user.id] == true
                                            ? TextButton.icon(
                                                onPressed: () async {
                                                  // Show confirmation dialog
                                                  final shouldCancel =
                                                      await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'Cancel Settlement'),
                                                      content: const Text(
                                                          'Are you sure you want to cancel this settlement?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                          child:
                                                              const Text('No'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true),
                                                          child:
                                                              const Text('Yes'),
                                                        ),
                                                      ],
                                                    ),
                                                  );

                                                  if (shouldCancel == true) {
                                                    // Update local state first
                                                    setState(() {
                                                      _userLoadingStates[
                                                          user.id] = true;
                                                    });

                                                    try {
                                                      final expenseController =
                                                          ref.read(
                                                              expenseNotifierProvider
                                                                  .notifier);
                                                      await expenseController
                                                          .cancelSettleUpExpenseUser(
                                                              expenseDetails
                                                                  .id!,
                                                              user.id!);

                                                      // Update local state
                                                      if (mounted) {
                                                        setState(() {
                                                          _userSettlementStates[
                                                              user.id] = false;
                                                          _userLoadingStates[
                                                              user.id] = false;
                                                        });
                                                      }

                                                      // Invalidate all relevant providers
                                                      ref.invalidate(
                                                          expenseNotifierProvider);
                                                      ref.invalidate(
                                                          expenseDetailsProvider(
                                                              expenseDetails
                                                                  .id!));
                                                      ref.invalidate(
                                                          getExpenseUsersForExpenseProvider(
                                                              expenseDetails
                                                                  .id!));
                                                    } catch (e) {
                                                      print(
                                                          'Error canceling settlement: $e');
                                                      if (mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  'Failed to cancel settlement: $e')),
                                                        );
                                                        setState(() {
                                                          _userLoadingStates[
                                                              user.id] = false;
                                                        });
                                                      }
                                                    }
                                                  }
                                                },
                                                icon: const Icon(Icons.undo,
                                                    size: 16),
                                                label: const Text(
                                                    'Cancel Settlement'),
                                                style: TextButton.styleFrom(
                                                  foregroundColor:
                                                      ColorConfig.error,
                                                ),
                                              )
                                            : ElevatedButton(
                                                onPressed: () async {
                                                  // Ensure we have a valid user ID
                                                  if (user.id == null) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Invalid user ID')),
                                                    );
                                                    return;
                                                  }

                                                  // Update local state first
                                                  setState(() {
                                                    _userLoadingStates[
                                                        user.id] = true;
                                                  });

                                                  try {
                                                    final expenseController =
                                                        ref.read(
                                                            expenseNotifierProvider
                                                                .notifier);
                                                    await expenseController
                                                        .settleUpExpenseUser(
                                                            expenseDetails.id!,
                                                            user.id!);

                                                    // Update local state
                                                    if (mounted) {
                                                      setState(() {
                                                        _userSettlementStates[
                                                            user.id] = true;
                                                        _userLoadingStates[
                                                            user.id] = false;
                                                      });
                                                    }

                                                    // Invalidate all relevant providers
                                                    ref.invalidate(
                                                        expenseNotifierProvider);
                                                    ref.invalidate(
                                                        expenseDetailsProvider(
                                                            expenseDetails
                                                                .id!));
                                                    ref.invalidate(
                                                        getExpenseUsersForExpenseProvider(
                                                            expenseDetails
                                                                .id!));
                                                  } catch (e) {
                                                    print(
                                                        'Error settling up: $e');
                                                    if (mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'Failed to settle up: $e')),
                                                      );
                                                      setState(() {
                                                        _userLoadingStates[
                                                            user.id] = false;
                                                      });
                                                    }
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      ColorConfig.primarySwatch,
                                                  foregroundColor: Colors.white,
                                                ),
                                                child: const Text('Settle'),
                                              ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
