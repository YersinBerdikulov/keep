import 'package:dongi/modules/expense/domain/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../box/domain/models/box_model.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../../../shared/widgets/card/card.dart';
import '../../domain/di/expense_controller_di.dart';
import '../widgets/create_expense_widget.dart';

class CreateExpensePage extends HookConsumerWidget {
  final BoxModel boxModel;
  final GroupModel groupModel;
  CreateExpensePage({
    super.key,
    required this.boxModel,
    required this.groupModel,
  });

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseTitle = useTextEditingController();
    final expenseDescription = useTextEditingController();
    final expenseCost = useTextEditingController();

    ref.listen<AsyncValue<List<ExpenseModel>>>(
      expenseNotifierProvider,
      (previous, next) {
        next.when(
          data: (_) {
            showSnackBar(context, content: "Successfully Created!!");
            context.pop();
          },
          loading: () {
            // Optionally show a loading spinner
          },
          error: (error, stackTrace) {
            showSnackBar(context, content: error.toString());
          },
        );
      },
    );

    // Calculate bottom padding to account for the create button height
    final bottomPadding = MediaQuery.of(context).padding.bottom +
        80.0; // 80.0 is approximate button height with padding

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensure the screen resizes when keyboard appears
      appBar: AppBarWidget(title: "Create Expense"),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: ListView(
                  children: [
                    CardWidget(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          CreateExpenseAmount(
                            expenseCost: expenseCost,
                            boxModel: boxModel,
                          ),
                          const SizedBox(height: 10),
                          CreateExpenseTitle(expenseTitle: expenseTitle),
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              CreateExpenseCategory(),
                              SizedBox(width: 10),
                              CreateExpenseDate()
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CreateExpenseAction(expenseCost: expenseCost),
                    const SizedBox(height: 20),
                    CreateExpenseDescription(expenseDescription),
                    // Add padding at the bottom to prevent overlap with the create button
                    SizedBox(height: bottomPadding),
                  ],
                ),
              ),
            ),
            CreateExpenseCreateButton(
              expenseTitle: expenseTitle,
              expenseDescription: expenseDescription,
              expenseCost: expenseCost,
              formKey: _formKey,
              groupModel: groupModel,
              boxModel: boxModel,
            )
          ],
        ),
      ),
    );
  }
}
