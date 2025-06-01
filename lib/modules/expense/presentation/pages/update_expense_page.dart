import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/constants/color_config.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../box/domain/models/box_model.dart';
import '../../domain/models/expense_model.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../../../shared/widgets/card/card.dart';
import '../../../../shared/widgets/text_field/text_field.dart';
import '../../domain/di/expense_controller_di.dart';
import '../widgets/update_expense_widget.dart';
import '../../../box/domain/di/box_controller_di.dart';

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

  @override
  void initState() {
    super.initState();
    
    // Initialize providers for update
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        print('Initializing update expense page...');
        // Reset all providers first to prevent "No element" error
        ref.read(userInBoxStoreProvider.notifier).state = [];
        ref.read(selectedSplitOptionProvider.notifier).state = -1;
        ref.read(advancedSplitMethodProvider.notifier).state = null;
        ref.read(customSplitAmountsProvider.notifier).state = {};
        ref.read(customSplitPercentagesProvider.notifier).state = {};
        ref.read(splitUserProvider.notifier).state = [];
        ref.read(userSharesProvider.notifier).state = {};
        
        // Set the payer ID
        ref.read(expensePayerIdProvider.notifier).state = widget.expenseModel.payerId;

        // Load box members
        final boxController = ref.read(boxNotifierProvider(widget.groupModel.id!).notifier);
        
        // Combine box users and expense users to ensure all are loaded
        final allUserIds = [...widget.boxModel.boxUsers];
        
        // Add any expense users that might not be in the box users list
        for (final userId in widget.expenseModel.expenseUsers) {
          if (!allUserIds.contains(userId)) {
            allUserIds.add(userId);
          }
        }
        
        final users = await boxController.getUsersInBox(allUserIds);
        
        print('Loaded all users for expense: ${users.map((u) => u.id).toList()}');

        if (mounted) {
          // Update the user store with all users
          ref.read(userInBoxStoreProvider.notifier).state = users;
          
          // Set the split users to match the expense users
          ref.read(splitUserProvider.notifier).state = widget.expenseModel.expenseUsers;
          
          // Initialize shares with 1 for each user
          if (users.isNotEmpty) {
            final initialShares = Map<String, int>.fromEntries(
              users.where((user) => user.id != null)
                  .map((user) => MapEntry(user.id!, 1))
            );
            ref.read(userSharesProvider.notifier).state = initialShares;
          }
        }
      } catch (e) {
        print('Error initializing update expense page: $e');
      }
    });
  }

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
            showSnackBar(context, content: "Successfully Created!!");
            context.pop();
          },
          loading: () {
            // Optionally, show a loading indicator or log the state
          },
          error: (error, stackTrace) {
            showSnackBar(context, content: error.toString());
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
