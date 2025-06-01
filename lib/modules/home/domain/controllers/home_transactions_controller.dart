import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/expense/domain/di/expense_controller_di.dart';
import 'package:dongi/modules/expense/domain/models/expense_model.dart';
import 'package:dongi/modules/expense/domain/repository/expense_repository.dart';
import 'package:dongi/modules/expense/data/di/expense_di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecentTransactionModel {
  final String id;
  final String title;
  final String? description;
  final String? categoryId;
  final String boxId;
  final String groupId;
  final String creatorId;
  final String payerId;
  final num cost;
  final bool equal;
  final List<String> expenseUsers;
  final bool isSettled;
  final String? settledAt;
  final String createdAt;

  RecentTransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.boxId,
    required this.groupId,
    required this.creatorId,
    required this.payerId,
    required this.cost,
    required this.equal,
    required this.expenseUsers,
    required this.isSettled,
    required this.settledAt,
    required this.createdAt,
  });

  factory RecentTransactionModel.fromExpense(ExpenseModel expense) {
    return RecentTransactionModel(
      id: expense.id ?? '',
      title: expense.title,
      description: expense.description,
      categoryId: expense.categoryId,
      boxId: expense.boxId,
      groupId: expense.groupId,
      creatorId: expense.creatorId,
      payerId: expense.payerId,
      cost: expense.cost,
      equal: expense.equal,
      expenseUsers: expense.expenseUsers,
      isSettled: expense.isSettled,
      settledAt: expense.settledAt,
      createdAt: expense.createdAt ?? '',
    );
  }
}

class HomeTransactionsNotifier
    extends AsyncNotifier<List<RecentTransactionModel>> {
  ExpenseRepository get _expenseRepository =>
      ref.read(expenseRepositoryProvider);

  @override
  Future<List<RecentTransactionModel>> build() async {
    // Watch current user to rebuild when user changes
    ref.watch(currentUserProvider);
    return getAllTransactions();
  }

  Future<List<RecentTransactionModel>> getAllTransactions() async {
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return [];

      // Get user's expenses with cache disabled to ensure fresh data
      final expenses = await _expenseRepository.getRecentExpenses(user.id!);

      // Convert to transaction models and sort by creation date (newest first)
      final transactions = expenses.map((expense) {
        final expenseModel = ExpenseModel.fromJson(expense.data);
        return RecentTransactionModel.fromExpense(expenseModel);
      }).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return transactions;
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  // Method to get only the most recent transactions for the home page
  List<RecentTransactionModel> getRecentTransactions() {
    final transactions = state.value;
    if (transactions == null || transactions.isEmpty) return [];

    // Return only the most recent 5 transactions
    return transactions.take(5).toList();
  }

  // Method to explicitly refresh the transactions data
  Future<void> refreshTransactions() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => getAllTransactions());
  }
}
