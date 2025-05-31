import 'dart:math';

import 'package:dongi/modules/expense/domain/controllers/category_controller.dart';
import 'package:dongi/modules/expense/domain/di/category_controller_di.dart';
import 'package:dongi/modules/expense/domain/di/expense_controller_di.dart';
import 'package:dongi/shared/utilities/extensions/format_with_comma.dart';
import 'package:dongi/shared/utilities/helpers/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/constants/font_config.dart';
import '../../../../shared/utilities/validation/validation.dart';
import '../../../box/domain/models/box_model.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/button/button_widget.dart';
import '../../../../shared/widgets/card/card.dart';
import '../../../../shared/widgets/card/grey_card.dart';
import '../../../../shared/widgets/list_tile/list_tile_card.dart';
import '../../../../shared/widgets/text_field/text_field.dart';
import '../../../box/domain/di/box_controller_di.dart';
import '../pages/split_page.dart';
import '../pages/advanced_split_page.dart';

final selectedDateProvider = StateProvider<DateTime?>((ref) => DateTime.now());

class CreateExpenseAmount extends ConsumerWidget {
  final TextEditingController expenseCost;
  final BoxModel boxModel;
  const CreateExpenseAmount({
    super.key,
    required this.expenseCost,
    required this.boxModel,
  });

  void _showCurrencyPicker(BuildContext context, WidgetRef ref) {
    final availableCurrencies = ref.read(expenseAvailableCurrenciesProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Currency',
                  style: FontConfig.h6(),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: availableCurrencies.length,
                  itemBuilder: (context, index) {
                    final currency = availableCurrencies[index];
                    return ListTile(
                      title: Text(currency),
                      onTap: () {
                        ref.read(expenseCurrencyProvider.notifier).state =
                            currency;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCurrency = ref.watch(expenseCurrencyProvider);

    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
            validator: ref.read(formValidatorProvider.notifier).validateCost,
            hintText: "10,000",
            fillColor: ColorConfig.white,
            controller: expenseCost,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
              TextInputFormatter.withFunction(
                (oldValue, newValue) {
                  final formattedValue = newValue.text.formatWithCommas();
                  final selectionIndex = newValue.selection.end +
                      formattedValue.length -
                      newValue.text.length;
                  return TextEditingValue(
                    text: formattedValue,
                    selection: TextSelection.collapsed(
                      offset: max(0, selectionIndex),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _showCurrencyPicker(context, ref),
          child: GreyCardWidget(
            width: 60,
            height: 50,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(selectedCurrency),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 18,
                    color: ColorConfig.midnight,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CreateExpenseTitle extends ConsumerWidget {
  final TextEditingController expenseTitle;
  const CreateExpenseTitle({super.key, required this.expenseTitle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFieldWidget(
      hintText: "Title",
      validator: ref.read(formValidatorProvider.notifier).validateTitle,
      fillColor: ColorConfig.white,
      controller: expenseTitle,
    );
  }
}

class CreateExpenseCategory extends ConsumerWidget {
  const CreateExpenseCategory({super.key});

  // Map of category icons to use
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

  void _showCategoryPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Consumer(
            builder: (context, ref, child) {
              final categoriesAsyncValue = ref.watch(categoryNotifierProvider);

              return categoriesAsyncValue.when(
                data: (categories) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Select Category',
                          style: FontConfig.h6(),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final iconMap = getCategoryIcon();
                            final icon = iconMap[category.icon.toLowerCase()] ??
                                Icons.category_outlined;

                            return ListTile(
                              leading:
                                  Icon(icon, color: ColorConfig.primarySwatch),
                              title: Text(category.name),
                              onTap: () {
                                // Update both the category model and the ID
                                ref
                                    .read(selectedCategoryProvider.notifier)
                                    .state = category;
                                ref
                                    .read(expenseCategoryIdProvider.notifier)
                                    .state = category.id;

                                // Debug prints
                                print('Selected category: ${category.name}');
                                print('Category ID: ${category.id}');

                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final iconMap = getCategoryIcon();
    final icon = selectedCategory != null
        ? iconMap[selectedCategory.icon.toLowerCase()] ??
            Icons.category_outlined
        : Icons.category_outlined;
    final categoryName = selectedCategory?.name ?? "Category";

    return Expanded(
      child: InkWell(
        onTap: () => _showCategoryPicker(context, ref),
        child: CardWidget(
          backColor: ColorConfig.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: ColorConfig.primarySwatch),
              const SizedBox(width: 5),
              Text(categoryName),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateExpenseDate extends ConsumerWidget {
  const CreateExpenseDate({super.key});

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: ref.read(selectedDateProvider) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorConfig.primarySwatch,
              onPrimary: ColorConfig.white,
              surface: ColorConfig.white,
              onSurface: ColorConfig.midnight,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      ref.read(selectedDateProvider.notifier).state = picked;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider) ?? DateTime.now();

    return Expanded(
      child: InkWell(
        onTap: () => _selectDate(context, ref),
        child: CardWidget(
          backColor: ColorConfig.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.date_range,
                color: ColorConfig.primarySwatch,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(selectedDate),
                style: FontConfig.body2(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateExpenseAction extends ConsumerWidget {
  final TextEditingController expenseCost;
  const CreateExpenseAction({super.key, required this.expenseCost});

  Widget _actionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    Color? iconColor,
    required VoidCallback? onTap,
    required bool isEnabled,
  }) {
    return CardWidget(
      onTap: isEnabled ? onTap : null,
      backColor:
          isEnabled ? ColorConfig.white : ColorConfig.white.withOpacity(0.7),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            icon,
            color: isEnabled
                ? (iconColor ?? ColorConfig.primarySwatch)
                : (iconColor ?? ColorConfig.primarySwatch).withOpacity(0.5),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontConfig.body2().copyWith(
                    color: isEnabled
                        ? ColorConfig.midnight
                        : ColorConfig.midnight.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: FontConfig.caption().copyWith(
                    color: isEnabled
                        ? ColorConfig.primarySwatch50
                        : ColorConfig.primarySwatch50.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userInBoxStoreProvider);
    final selectedPayerId = ref.watch(expensePayerIdProvider);
    final selectedSplitOption = ref.watch(selectedSplitOptionProvider);
    final advancedMethod = ref.watch(advancedSplitMethodProvider);

    // Check if amount is entered
    final hasAmount = expenseCost.text.isNotEmpty &&
        num.tryParse(expenseCost.text.replaceAll(',', '')) != null &&
        num.tryParse(expenseCost.text.replaceAll(',', ''))! > 0;

    // If users list is empty, show a loading state
    if (users.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Get split description
    String splitInfo;
    final totalAmount = num.tryParse(expenseCost.text.replaceAll(',', '')) ?? 0;

    // First check for advanced split method as it applies to both 2-user and multi-user cases
    if (advancedMethod != null && advancedMethod.isNotEmpty) {
      final splitMethod = ref.watch(splitMethodProvider);
      switch (splitMethod) {
        case SplitMethod.equal:
          final selectedUsers = ref.watch(splitUserProvider);
          if (selectedUsers.isEmpty) {
            splitInfo =
                "${(totalAmount / users.length).toStringAsFixed(2)} each";
          } else {
            // Show individual amounts for each selected user
            final selectedUserNames = users
                .where((user) => selectedUsers.contains(user.id))
                .map((user) {
              final name = user.userName?.split(' ')[0] ??
                  user.email?.split('@')[0] ??
                  "Unknown";
              return "$name: ${(totalAmount / selectedUsers.length).toStringAsFixed(2)}";
            }).join(', ');
            splitInfo = selectedUserNames;
          }
          break;
        case SplitMethod.amount:
          final customAmounts = ref.watch(customSplitAmountsProvider);
          if (customAmounts.isEmpty) {
            splitInfo = "Custom amounts";
          } else {
            final userAmounts = users.map((user) {
              final amount = customAmounts[user.id] ?? 0;
              final name = user.userName?.split(' ')[0] ??
                  user.email?.split('@')[0] ??
                  "Unknown";
              return "$name: ${amount.toStringAsFixed(2)}";
            }).join(', ');
            splitInfo = userAmounts;
          }
          break;
        case SplitMethod.percentage:
          final customPercentages = ref.watch(customSplitPercentagesProvider);
          if (customPercentages.isEmpty) {
            splitInfo = "Custom percentages";
          } else {
            final userPercentages = users.map((user) {
              final percentage = customPercentages[user.id] ?? 0;
              final amount = totalAmount * (percentage / 100);
              final name = user.userName?.split(' ')[0] ??
                  user.email?.split('@')[0] ??
                  "Unknown";
              return "$name: $percentage% (${amount.toStringAsFixed(2)})";
            }).join(', ');
            splitInfo = userPercentages;
          }
          break;
        case SplitMethod.shares:
          final userShares = ref.watch(userSharesProvider);
          final totalShares =
              userShares.values.fold(0, (sum, shares) => sum + shares);
          if (userShares.isEmpty || totalShares == 0) {
            splitInfo = "By shares";
          } else {
            final userShareInfo = users.map((user) {
              final shares = userShares[user.id] ?? 1;
              final amount = totalAmount * shares / totalShares;
              final name = user.userName?.split(' ')[0] ??
                  user.email?.split('@')[0] ??
                  "Unknown";
              return "$name: $shares shares (${amount.toStringAsFixed(2)})";
            }).join(', ');
            splitInfo = userShareInfo;
          }
          break;
      }
    }
    // Then check for basic split options for 2-user case
    else if (users.length == 2) {
      final firstUserName = users[0].userName?.split(' ')[0] ??
          users[0].email?.split('@')[0] ??
          "Unknown";
      final secondUserName = users[1].userName?.split(' ')[0] ??
          users[1].email?.split('@')[0] ??
          "Unknown";
      final halfAmount = (totalAmount / 2).toStringAsFixed(2);

      switch (selectedSplitOption) {
        case 0:
          splitInfo = "$firstUserName paid, $secondUserName owes $halfAmount";
          break;
        case 1:
          splitInfo = "$secondUserName owes $totalAmount to $firstUserName";
          break;
        case 2:
          splitInfo = "$secondUserName paid, $firstUserName owes $halfAmount";
          break;
        case 3:
          splitInfo = "$firstUserName owes $totalAmount to $secondUserName";
          break;
        default:
          splitInfo = "Not split yet";
      }
    }
    // Default case when no split method is selected
    else {
      splitInfo = "Not split yet";
    }

    // For 2-person case, only show Split between button
    if (users.length == 2) {
      return _actionButton(
        title: "Split between",
        subtitle: splitInfo,
        icon: Icons.group,
        iconColor: ColorConfig.primarySwatch,
        onTap: () => context.push(
          RouteName.expenseSplit,
          extra: {"expenseCost": expenseCost},
        ),
        isEnabled: hasAmount,
      );
    }

    // For 3+ people case
    return Column(
      children: [
        _actionButton(
          title: "Made by",
          subtitle: selectedPayerId != null
              ? users
                      .firstWhere((user) => user.id == selectedPayerId,
                          orElse: () => users.first)
                      .userName ??
                  users.first.email ??
                  "Unknown"
              : "Not selected",
          icon: Icons.person,
          iconColor: ColorConfig.secondary,
          onTap: () => context.push(RouteName.expenseMadeBy),
          isEnabled: hasAmount,
        ),
        const SizedBox(height: 10),
        _actionButton(
          title: "Split between",
          subtitle: splitInfo,
          icon: Icons.group,
          iconColor: ColorConfig.primarySwatch,
          onTap: () {
            if (users.length > 2) {
              // For 3+ users, go directly to advanced split
              context.push(
                RouteName.expenseAdvancedSplit,
                extra: {"expenseCost": expenseCost},
              );
            } else {
              // For 2 users, show basic split options
              context.push(
                RouteName.expenseSplit,
                extra: {"expenseCost": expenseCost},
              );
            }
          },
          isEnabled: hasAmount,
        ),
      ],
    );
  }
}

class CreateExpenseDescription extends ConsumerWidget {
  final TextEditingController expenseDescription;
  const CreateExpenseDescription(this.expenseDescription, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardWidget(
      padding: const EdgeInsets.all(15),
      child: TextFieldWidget(
        controller: expenseDescription,
        hintText: "Description",
        maxLines: 3,
        fillColor: ColorConfig.white,
      ),
    );
  }
}

class CreateExpenseCreateButton extends ConsumerWidget {
  final TextEditingController expenseTitle;
  final TextEditingController expenseDescription;
  final TextEditingController expenseCost;
  final GlobalKey<FormState> formKey;
  final GroupModel groupModel;
  final BoxModel boxModel;

  const CreateExpenseCreateButton({
    required this.expenseTitle,
    required this.expenseDescription,
    required this.expenseCost,
    required this.formKey,
    required this.groupModel,
    required this.boxModel,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCurrency = ref.watch(expenseCurrencyProvider);
    final hasMultipleMembers = boxModel.boxUsers.length > 1;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ButtonWidget(
          isLoading: ref.watch(expenseNotifierProvider).maybeWhen(
                loading: () => true,
                orElse: () => false,
              ),
          onPressed: !hasMultipleMembers
              ? null
              : () {
                  if (formKey.currentState!.validate()) {
                    ref.read(expenseNotifierProvider.notifier).addExpense(
                          expenseTitle: expenseTitle,
                          expenseDescription: expenseDescription,
                          expenseCost: expenseCost,
                          groupModel: groupModel,
                          boxModel:
                              boxModel.copyWith(currency: selectedCurrency),
                        );

                    // Reset the category selection
                    ref.read(selectedCategoryProvider.notifier).state = null;
                    ref.read(expenseCategoryIdProvider.notifier).state = null;
                  }
                },
          title: hasMultipleMembers
              ? "Create"
              : "Need more members to create expense",
          textColor: ColorConfig.secondary,
        ),
      ),
    );
  }
}
