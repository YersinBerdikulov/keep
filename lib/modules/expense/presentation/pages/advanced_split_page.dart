import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../../../shared/widgets/button/button_widget.dart';
import '../../../../shared/widgets/card/card.dart';
import '../../../../shared/widgets/text_field/text_field.dart';
import '../../domain/di/expense_controller_di.dart';
import '../../../box/domain/di/box_controller_di.dart';
import '../widgets/split_widget.dart';

enum SplitMethod { equal, amount, percentage, shares }

class AdvancedSplitPage extends ConsumerWidget {
  final TextEditingController expenseCost;

  const AdvancedSplitPage({
    super.key,
    required this.expenseCost,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColorConfig.white,
      appBar: AppBarWidget(title: "Advanced Split"),
      body: Column(
        children: [
          _buildSplitMethodTabs(ref),
          Expanded(
            child: _buildSplitMethodContent(ref),
          ),
          _buildConfirmButton(context, ref),
        ],
      ),
    );
  }

  Widget _buildSplitMethodTabs(WidgetRef ref) {
    final selectedMethod = ref.watch(splitMethodProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          for (var method in SplitMethod.values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: CardWidget(
                  onTap: () =>
                      ref.read(splitMethodProvider.notifier).state = method,
                  backColor: selectedMethod == method
                      ? ColorConfig.primarySwatch
                      : ColorConfig.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        _getMethodName(method),
                        style: FontConfig.body2().copyWith(
                          color: selectedMethod == method
                              ? ColorConfig.white
                              : ColorConfig.midnight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSplitMethodContent(WidgetRef ref) {
    final selectedMethod = ref.watch(splitMethodProvider);
    final users = ref.watch(userInBoxStoreProvider);
    final totalAmount =
        double.tryParse(expenseCost.text.replaceAll(',', '')) ?? 0;

    switch (selectedMethod) {
      case SplitMethod.equal:
        return _buildEqualSplit(ref, users, totalAmount);
      case SplitMethod.amount:
        return _buildAmountSplit(ref, users, totalAmount);
      case SplitMethod.percentage:
        return _buildPercentageSplit(ref, users, totalAmount);
      case SplitMethod.shares:
        return _buildSharesSplit(ref, users, totalAmount);
    }
  }

  Widget _buildEqualSplit(
      WidgetRef ref, List<dynamic> users, double totalAmount) {
    final selectedUsers = ref.watch(splitUserProvider);

    // Calculate amounts based on selection
    Map<String, double> userAmounts = {};
    if (selectedUsers.isEmpty) {
      // If no one is selected, show the equal split amount but don't assign it
      for (var user in users) {
        if (user.id != null) {
          userAmounts[user.id] = totalAmount / users.length;
        }
      }
    } else {
      // Selected users split the FULL amount equally
      double amountPerSelected = totalAmount / selectedUsers.length;

      for (var user in users) {
        if (user.id != null) {
          if (selectedUsers.contains(user.id)) {
            userAmounts[user.id] = amountPerSelected;
          } else {
            userAmounts[user.id] = 0;
          }
        }
      }
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: CardWidget(
            child: ListTile(
              leading: Checkbox(
                value: selectedUsers.length == users.length && users.isNotEmpty,
                activeColor: ColorConfig.primarySwatch,
                onChanged: (bool? value) {
                  final userIds = users
                      .where((user) => user.id != null)
                      .map((user) => user.id as String)
                      .toList();
                  ref.read(splitUserProvider.notifier).toggleAll(userIds);
                },
              ),
              title: Text(
                'Select All',
                style: FontConfig.body1().copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Text(
                selectedUsers.isEmpty
                    ? '\$${(totalAmount / users.length).toStringAsFixed(2)} each'
                    : '\$${(totalAmount / selectedUsers.length).toStringAsFixed(2)} each',
                style: FontConfig.body1().copyWith(
                  color: ColorConfig.secondary,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user.id!;
              final isSelected = selectedUsers.contains(userId);
              final amount = userAmounts[userId] ?? 0.0;

              return CardWidget(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profileImage != null
                        ? NetworkImage(user.profileImage)
                        : null,
                    child: user.profileImage == null
                        ? Text(user.userName?[0] ?? user.email[0])
                        : null,
                  ),
                  title: Text(user.userName ?? user.email),
                  subtitle: Text(
                    '\$${amount.toStringAsFixed(2)}',
                    style: FontConfig.body2().copyWith(
                      color:
                          isSelected ? ColorConfig.secondary : ColorConfig.grey,
                    ),
                  ),
                  trailing: Checkbox(
                    value: isSelected,
                    activeColor: ColorConfig.primarySwatch,
                    onChanged: (bool? value) {
                      if (value == true) {
                        ref.read(splitUserProvider.notifier).add(userId);
                      } else {
                        ref.read(splitUserProvider.notifier).remove(userId);
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                style: FontConfig.body1(),
              ),
              Text(
                'Selected: ${selectedUsers.length}/${users.length}',
                style: FontConfig.body1().copyWith(
                  color: selectedUsers.isEmpty
                      ? ColorConfig.error
                      : ColorConfig.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountSplit(
      WidgetRef ref, List<dynamic> users, double totalAmount) {
    final customAmounts = ref.watch(customSplitAmountsProvider);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user.id;

              return CardWidget(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profileImage != null
                        ? NetworkImage(user.profileImage)
                        : null,
                    child: user.profileImage == null
                        ? Text(user.userName != null
                            ? user.userName![0]
                            : user.email)
                        : null,
                  ),
                  title: Text(user.userName ?? user.email),
                  trailing: SizedBox(
                    width: 100,
                    child: TextFieldWidget(
                      hintText: "0.00",
                      fillColor: ColorConfig.white,
                      onChanged: (value) {
                        final amount = double.tryParse(value ?? "") ?? 0;
                        ref.read(customSplitAmountsProvider.notifier).state = {
                          ...customAmounts,
                          userId!: amount,
                        };
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                style: FontConfig.body1(),
              ),
              Text(
                'Remaining: \$${(totalAmount - customAmounts.values.fold(0.0, (a, b) => a + b)).toStringAsFixed(2)}',
                style: FontConfig.body1().copyWith(
                  color: _isAmountSplitValid(totalAmount, customAmounts)
                      ? ColorConfig.secondary
                      : ColorConfig.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPercentageSplit(
      WidgetRef ref, List<dynamic> users, double totalAmount) {
    final customPercentages = ref.watch(customSplitPercentagesProvider);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final userId = user.id;
              final percentage = customPercentages[userId] ?? 0;
              final amount = totalAmount * (percentage / 100);

              return CardWidget(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profileImage != null
                        ? NetworkImage(user.profileImage)
                        : null,
                    child: user.profileImage == null
                        ? Text(user.userName != null
                            ? user.userName![0]
                            : user.email)
                        : null,
                  ),
                  title: Text(user.userName ?? user.email),
                  subtitle: Text('\$${amount.toStringAsFixed(2)}'),
                  trailing: SizedBox(
                    width: 80,
                    child: TextFieldWidget(
                      hintText: "0%",
                      fillColor: ColorConfig.white,
                      onChanged: (value) {
                        final percent = double.tryParse(value ?? "") ?? 0;
                        ref
                            .read(customSplitPercentagesProvider.notifier)
                            .state = {
                          ...customPercentages,
                          userId!: percent,
                        };
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${totalAmount.toStringAsFixed(2)}',
                style: FontConfig.body1(),
              ),
              Text(
                'Remaining: ${(100 - customPercentages.values.fold(0.0, (a, b) => a + b)).toStringAsFixed(1)}%',
                style: FontConfig.body1().copyWith(
                  color: _isPercentageSplitValid(customPercentages)
                      ? ColorConfig.secondary
                      : ColorConfig.error,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSharesSplit(
      WidgetRef ref, List<dynamic> users, double totalAmount) {
    final userShares = ref.watch(userSharesProvider);
    final totalShares =
        userShares.values.fold(0, (sum, shares) => sum + shares);

    // Ensure each user has at least 1 share
    if (users.isNotEmpty) {
      bool needsUpdate = false;
      final updatedShares = Map<String, int>.from(userShares);

      for (final user in users) {
        if (user.id != null && !userShares.containsKey(user.id)) {
          updatedShares[user.id!] = 1;
          needsUpdate = true;
        }
      }

      if (needsUpdate) {
        // Use addPostFrameCallback to avoid build-time state updates
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(userSharesProvider.notifier).state = updatedShares;
        });
      }
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              if (user.id == null) return const SizedBox.shrink();

              final userId = user.id!;
              final shares = userShares[userId] ?? 1;
              final currentTotalShares =
                  totalShares > 0 ? totalShares : users.length;
              final amount = totalAmount * shares / currentTotalShares;

              return CardWidget(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profileImage != null
                        ? NetworkImage(user.profileImage)
                        : null,
                    child: user.profileImage == null
                        ? Text(user.userName?[0] ?? user.email[0])
                        : null,
                  ),
                  title: Text(user.userName ?? user.email),
                  subtitle: Text('\$${amount.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline,
                            color: ColorConfig.error),
                        onPressed: shares > 1
                            ? () {
                                final updatedShares =
                                    Map<String, int>.from(userShares);
                                updatedShares[userId] = shares - 1;
                                ref.read(userSharesProvider.notifier).state =
                                    updatedShares;
                              }
                            : null,
                      ),
                      SizedBox(
                        width: 30,
                        child: Text(
                          shares.toString(),
                          textAlign: TextAlign.center,
                          style: FontConfig.body1(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline,
                            color: ColorConfig.secondary),
                        onPressed: () {
                          final updatedShares =
                              Map<String, int>.from(userShares);
                          updatedShares[userId] = shares + 1;
                          ref.read(userSharesProvider.notifier).state =
                              updatedShares;
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
                style: FontConfig.body1(),
              ),
              Text(
                'Total Shares: ${totalShares > 0 ? totalShares : users.length}',
                style: FontConfig.body1().copyWith(
                  color: ColorConfig.secondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context, WidgetRef ref) {
    final selectedMethod = ref.watch(splitMethodProvider);
    final customAmounts = ref.watch(customSplitAmountsProvider);
    final customPercentages = ref.watch(customSplitPercentagesProvider);
    final userShares = ref.watch(userSharesProvider);
    final totalAmount =
        double.tryParse(expenseCost.text.replaceAll(',', '')) ?? 0;

    bool isValid = false;
    switch (selectedMethod) {
      case SplitMethod.equal:
        isValid = true;
        break;
      case SplitMethod.amount:
        isValid = _isAmountSplitValid(totalAmount, customAmounts);
        break;
      case SplitMethod.percentage:
        isValid = _isPercentageSplitValid(customPercentages);
        break;
      case SplitMethod.shares:
        isValid = _isSharesSplitValid(userShares);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConfig.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ButtonWidget(
          onPressed: isValid
              ? () {
                  // Update the advanced split method provider
                  ref.read(advancedSplitMethodProvider.notifier).state =
                      _getMethodName(selectedMethod);
                  // Navigate back twice to return to create expense screen
                  context.pop();
                  context.pop();
                }
              : null,
          title: "Confirm Split",
          textColor: ColorConfig.secondary,
        ),
      ),
    );
  }

  String _getMethodName(SplitMethod method) {
    switch (method) {
      case SplitMethod.equal:
        return "Equal";
      case SplitMethod.amount:
        return "Amount";
      case SplitMethod.percentage:
        return "Percent";
      case SplitMethod.shares:
        return "Shares";
    }
  }

  bool _isAmountSplitValid(double totalAmount, Map<String, double> amounts) {
    final sum = amounts.values.fold(0.0, (a, b) => a + b);
    return (totalAmount - sum).abs() < 0.01; // Allow for small rounding errors
  }

  bool _isPercentageSplitValid(Map<String, double> percentages) {
    final sum = percentages.values.fold(0.0, (a, b) => a + b);
    return (100 - sum).abs() < 0.01; // Allow for small rounding errors
  }

  bool _isSharesSplitValid(Map<String, int> shares) {
    return shares.values.fold(0, (sum, count) => sum + count) > 0;
  }

  @override
  bool _isEqualSplitValid(List<String> selectedUsers) {
    return selectedUsers.isNotEmpty;
  }
}
