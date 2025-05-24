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

final selectedDateProvider = StateProvider<DateTime?>((ref) => DateTime.now());

class CreateExpenseAmount extends ConsumerWidget {
  final TextEditingController expenseCost;
  final BoxModel boxModel;
  const CreateExpenseAmount({
    super.key,
    required this.expenseCost,
    required this.boxModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        GreyCardWidget(
          width: 50,
          height: 50,
          child: Center(
            child: Text(boxModel.currency),
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

  _actionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Function()? onTap,
  }) {
    return CardWidget(
      onTap: onTap,
      backColor: ColorConfig.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FontConfig.caption().copyWith(
                    color: ColorConfig.primarySwatch50,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: FontConfig.body2().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: ColorConfig.primarySwatch50,
            size: 16,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _actionButton(
          title: "Made by",
          subtitle: "You",
          icon: Icons.person,
          iconColor: ColorConfig.secondary,
          onTap: () => showSnackBar(context, content: "Coming soon!"),
        ),
        const SizedBox(height: 10),
        _actionButton(
          title: "Split between",
          subtitle: "Equal split · 4 people",
          icon: Icons.group,
          iconColor: ColorConfig.primarySwatch,
          onTap: () => showSnackBar(context, content: "Coming soon!"),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ButtonWidget(
          isLoading: ref.watch(expenseNotifierProvider).maybeWhen(
                loading: () => true,
                orElse: () => false,
              ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              ref.read(expenseNotifierProvider.notifier).addExpense(
                    expenseTitle: expenseTitle,
                    expenseDescription: expenseDescription,
                    expenseCost: expenseCost,
                    groupModel: groupModel,
                    boxModel: boxModel,
                  );

              // Reset the category selection
              ref.read(selectedCategoryProvider.notifier).state = null;
              ref.read(expenseCategoryIdProvider.notifier).state = null;
            }
          },
          title: "Create",
          textColor: ColorConfig.secondary,
        ),
      ),
    );
  }
}
