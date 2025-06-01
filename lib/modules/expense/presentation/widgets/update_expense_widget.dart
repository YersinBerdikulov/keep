import 'dart:math';

import 'package:dongi/shared/utilities/extensions/format_with_comma.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../box/domain/models/box_model.dart';
import '../../domain/models/expense_model.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../../core/router/router_names.dart';
import '../../../../shared/widgets/button/button_widget.dart';
import '../../../../shared/widgets/card/card.dart';
import '../../../../shared/widgets/card/grey_card.dart';
import '../../../../shared/widgets/list_tile/list_tile_card.dart';
import '../../../../shared/widgets/text_field/text_field.dart';
import '../../domain/di/expense_controller_di.dart';
import '../../../box/domain/di/box_controller_di.dart';
import '../pages/advanced_split_page.dart';

class UpdateExpenseAmount extends ConsumerWidget {
  final TextEditingController expenseCost;
  const UpdateExpenseAmount({super.key, required this.expenseCost});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: TextFieldWidget(
            hintText: "10,000",
            fillColor: ColorConfig.white,
            controller: expenseCost,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              //LengthLimitingTextInputFormatter(10),
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
        const GreyCardWidget(
          width: 50,
          height: 50,
          child: Center(
            child: Text("USD"),
          ),
        ),
      ],
    );
  }
}

class UpdateExpenseCategory extends ConsumerWidget {
  const UpdateExpenseCategory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: CardWidget(
        backColor: ColorConfig.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, color: ColorConfig.primarySwatch),
            const SizedBox(width: 5),
            const Text("Category"),
          ],
        ),
      ),
    );
  }
}

class UpdateExpenseDate extends ConsumerWidget {
  const UpdateExpenseDate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: CardWidget(
        backColor: ColorConfig.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.date_range,
              color: ColorConfig.primarySwatch,
            ),
            const SizedBox(width: 5),
            const Text("20 Nov, 2020"),
          ],
        ),
      ),
    );
  }
}

class UpdateExpenseAction extends ConsumerWidget {
  final TextEditingController expenseCost;
  const UpdateExpenseAction({super.key, required this.expenseCost});

  Widget _actionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Function()? onTap,
  }) {
    return ListTileCard(
      onTap: onTap,
      backColor: ColorConfig.white,
      titleString: title,
      subtitleString: subtitle,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ColorConfig.pureWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userInBoxStoreProvider);
    final selectedPayerId = ref.watch(expensePayerIdProvider);

    return CardWidget(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _actionButton(
            title: "made by",
            subtitle: selectedPayerId != null
                ? users
                        .firstWhere((user) => user.id == selectedPayerId,
                            orElse: () => users.first)
                        .userName ??
                    users.first.email ??
                    "Unknown"
                : "Not selected",
            icon: Icons.account_box,
            onTap: () => context.push(RouteName.expenseMadeBy),
          ),
          const SizedBox(height: 10),
          _actionButton(
            title: "split between",
            subtitle: "Splitting method",
            icon: Icons.call_split,
            onTap: () {
              // Check the number of users to decide which split page to navigate to
              if (users.length == 2) {
                // For 2 users, show basic split options
                context.push(
                  RouteName.expenseSplit,
                  extra: {"expenseCost": expenseCost},
                );
              } else {
                // For 3+ users, go directly to advanced split
                context.push(
                  RouteName.expenseAdvancedSplit,
                  extra: {"expenseCost": expenseCost},
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class UpdateExpenseDescription extends ConsumerWidget {
  final TextEditingController expenseDescription;
  const UpdateExpenseDescription(this.expenseDescription, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardWidget(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          CardWidget(
            backColor: ColorConfig.white,
            child: SizedBox(
              width: 75,
              height: 75,
              child: Icon(
                Icons.description_outlined,
                color: ColorConfig.primarySwatch,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFieldWidget(
              controller: expenseDescription,
              hintText: "Description",
              maxLines: 3,
              fillColor: ColorConfig.white,
            ),
          ),
        ],
      ),
    );
  }
}

class UpdateExpenseCreateButton extends ConsumerWidget {
  final ExpenseModel expenseModel;
  final TextEditingController expenseTitle;
  final TextEditingController expenseDescription;
  final TextEditingController expenseCost;
  final GlobalKey<FormState> formKey;
  final GroupModel groupModel;
  final BoxModel boxModel;

  const UpdateExpenseCreateButton({
    required this.expenseModel,
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
              ref.read(expenseNotifierProvider.notifier).updateExpense(
                    expenseModel: expenseModel,
                    expenseTitle: expenseTitle,
                    expenseDescription: expenseDescription,
                    expenseCost: expenseCost,
                    groupModel: groupModel,
                    boxModel: boxModel,
                  );
            }
          },
          title: "Update",
          textColor: ColorConfig.secondary,
        ),
      ),
    );
  }
}
