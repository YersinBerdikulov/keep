import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../core/utilities/helpers/snackbar_helper.dart';
import '../../../box/domain/models/box_model.dart';
import '../../domain/models/expense_model.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../../widgets/appbar/appbar.dart';
import '../../../../widgets/card/card.dart';
import '../../../../widgets/text_field/text_field.dart';
import '../../domain/di/expense_controller_di.dart';
import '../widgets/update_expense_widget.dart';

class UpdateExpensePage extends StatefulHookConsumerWidget {
  final ExpenseModel expenseModel;
  final GroupModel groupModel;
  final BoxModel boxModel;

  const UpdateExpensePage({
    super.key,
    required this.expenseModel,
    required this.boxModel,
    required this.groupModel,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateExpensePageState();
}

class _UpdateExpensePageState extends ConsumerState<UpdateExpensePage> {
  final _formKey = GlobalKey<FormState>();

  //@override
  //void initState() {
  //  ref
  //      .read(splitUserProvider.notifier)
  //      .addAll(widget.expenseModel.expenseUsers);
  //  super.initState();
  //}

  @override
  Widget build(BuildContext context) {
    final expenseTitle =
        useTextEditingController(text: widget.expenseModel.title);
    final expenseDescription =
        useTextEditingController(text: widget.expenseModel.description);
    final expenseCost =
        useTextEditingController(text: widget.expenseModel.cost.toString());

    /// Using listen without rebuilding the app
    ref.listen<AsyncValue<void>>(
      expenseNotifierProvider,
      (previous, next) {
        next.when(
          data: (_) {
            showSnackBar(context, "Successfully Created!!");
            context.pop();
          },
          loading: () {
            // Optionally, show a loading indicator or log the state
          },
          error: (error, stackTrace) {
            showSnackBar(context, error.toString());
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBarWidget(title: "Update Expense"),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    CardWidget(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          UpdateExpenseAmount(expenseCost: expenseCost),
                          const SizedBox(height: 10),
                          TextFieldWidget(
                            hintText: "Title",
                            fillColor: ColorConfig.white,
                            controller: expenseTitle,
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              UpdateExpenseCategory(),
                              SizedBox(width: 10),
                              UpdateExpenseDate()
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    UpdateExpenseAction(expenseCost: expenseCost),
                    const SizedBox(height: 20),
                    UpdateExpenseDescription(expenseDescription),
                  ],
                ),
              ),
              UpdateExpenseCreateButton(
                expenseModel: widget.expenseModel,
                expenseTitle: expenseTitle,
                expenseDescription: expenseDescription,
                expenseCost: expenseCost,
                formKey: _formKey,
                groupModel: widget.groupModel,
                boxModel: widget.boxModel,
              )
            ],
          ),
        ),
      ),
    );
  }
}
