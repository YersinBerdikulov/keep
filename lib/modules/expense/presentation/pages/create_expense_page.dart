import 'package:dongi/modules/expense/domain/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/color_config.dart';
import '../../../../shared/utilities/helpers/snackbar_helper.dart';
import '../../../../shared/widgets/appbar/appbar.dart';
import '../../../../shared/widgets/card/card.dart';
import '../../../box/domain/models/box_model.dart';
import '../../../group/domain/models/group_model.dart';
import '../../../box/domain/di/box_controller_di.dart';
import '../../domain/di/expense_controller_di.dart';
import '../widgets/create_expense_widget.dart';

class CreateExpensePage extends ConsumerStatefulWidget {
  final GroupModel groupModel;
  final BoxModel boxModel;
  const CreateExpensePage({
    super.key,
    required this.groupModel,
    required this.boxModel,
  });

  @override
  ConsumerState<CreateExpensePage> createState() => _CreateExpensePageState();
}

class _CreateExpensePageState extends ConsumerState<CreateExpensePage> {
  final TextEditingController expenseTitle = TextEditingController();
  final TextEditingController expenseDescription = TextEditingController();
  final TextEditingController expenseCost = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Reset all split-related states
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        print('Initializing expense page...');
        // Reset all providers first to prevent "No element" error
        ref.read(userInBoxStoreProvider.notifier).state = [];
        ref.read(selectedSplitOptionProvider.notifier).state = -1;
        ref.read(advancedSplitMethodProvider.notifier).state = null;
        ref.read(customSplitAmountsProvider.notifier).state = {};
        ref.read(customSplitPercentagesProvider.notifier).state = {};
        ref.read(splitUserProvider.notifier).state = [];
        ref.read(userSharesProvider.notifier).state = {};
        ref.read(expensePayerIdProvider.notifier).state = null;

        // Load box members
        final boxController =
            ref.read(boxNotifierProvider(widget.groupModel.id!).notifier);
        final users =
            await boxController.getUsersInBox(widget.boxModel.boxUsers);
        
        print('Loaded box users: ${users.map((u) => u.id).toList()}');

        // Only update providers if the widget is still mounted
        if (mounted) {
          print('Setting userInBoxStoreProvider with users');
          ref.read(userInBoxStoreProvider.notifier).state = users;

          // Initialize shares with 1 for each user
          if (users.isNotEmpty) {
            final initialShares = Map<String, int>.fromEntries(users
                .where((user) => user.id != null)
                .map((user) => MapEntry(user.id!, 1)));
            print('Setting initial shares: $initialShares');
            ref.read(userSharesProvider.notifier).state = initialShares;
          }
        }
      } catch (e) {
        print('Error initializing expense page: $e');
        // Handle error appropriately
      }
    });
  }

  @override
  void dispose() {
    expenseTitle.dispose();
    expenseDescription.dispose();
    expenseCost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate bottom padding to account for the create button height
    final bottomPadding = MediaQuery.of(context).padding.bottom +
        80.0; // 80.0 is approximate button height with padding

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

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Ensure the screen resizes when keyboard appears
      appBar: AppBarWidget(title: "Create Expense"),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                children: [
                  CardWidget(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        CreateExpenseAmount(
                          expenseCost: expenseCost,
                          boxModel: widget.boxModel,
                        ),
                        const SizedBox(height: 10),
                        CreateExpenseTitle(expenseTitle: expenseTitle),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const CreateExpenseCategory(),
                            const SizedBox(width: 10),
                            const CreateExpenseDate(),
                          ],
                        ),
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
            CreateExpenseCreateButton(
              expenseTitle: expenseTitle,
              expenseDescription: expenseDescription,
              expenseCost: expenseCost,
              formKey: formKey,
              groupModel: widget.groupModel,
              boxModel: widget.boxModel,
            )
          ],
        ),
      ),
    );
  }
}
