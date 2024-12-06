import 'package:dongi/modules/auth/domain/controllers/auth_controller.dart';
import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:dongi/modules/expense/domain/controllers/expense_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/expense_model.dart';

final expenseNotifierProvider =
    AsyncNotifierProvider<ExpenseNotifier, List<ExpenseModel>>(
  ExpenseNotifier.new,
);

final getExpensesInBoxProvider =
    FutureProvider.family.autoDispose((ref, String boxId) {
  final expenseController = ref.watch(expenseNotifierProvider.notifier);
  return expenseController.getExpensesInBox(boxId);
});

final getExpensesDetailProvider =
    FutureProvider.family.autoDispose((ref, String expenseId) {
  final expenseController = ref.watch(expenseNotifierProvider.notifier);
  return expenseController.getExpenseDetail(expenseId);
});

final expensePayerIdProvider = StateProvider<String?>((ref) {
  final user = ref.read(currentUserProvider);
  return user?.id;
});

final splitUserProvider =
    StateNotifierProvider<SplitUserNotifier, List<String>>((ref) {
  // Retrieve all users in the box from the provider.
  final allUsers = ref.watch(userInBoxStoreProvider);
  // Initialize SplitUserNotifier with a list of user IDs.
  return SplitUserNotifier(allUsers.map((e) => e.id!).toList());
});
