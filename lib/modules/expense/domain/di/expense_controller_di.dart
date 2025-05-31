import 'package:dongi/modules/auth/domain/di/auth_controller_di.dart';
import 'package:dongi/modules/box/domain/di/box_controller_di.dart';
import 'package:dongi/modules/expense/domain/controllers/expense_controller.dart';
import 'package:dongi/modules/user/domain/models/user_model.dart';
import 'package:dongi/modules/user/domain/di/user_controller_di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../expense/presentation/pages/advanced_split_page.dart';
import 'package:dongi/modules/expense/data/di/expense_di.dart';
import 'package:appwrite/models.dart';

import '../models/expense_model.dart';
import '../models/expense_user_model.dart';

final expenseNotifierProvider =
    AsyncNotifierProvider<ExpenseNotifier, List<ExpenseModel>>(
  ExpenseNotifier.new,
);

final getExpensesInBoxProvider =
    FutureProvider.family.autoDispose<List<ExpenseModel>, String>((ref, boxId) async {
  final expenseController = ref.watch(expenseNotifierProvider.notifier);
  return expenseController.getExpensesInBox(boxId);
});

final getExpensesDetailProvider =
    FutureProvider.family.autoDispose((ref, String expenseId) {
  final expenseController = ref.watch(expenseNotifierProvider.notifier);
  return expenseController.getExpenseDetail(expenseId);
});

// New provider for fetching expense users
final getExpenseUsersProvider = FutureProvider.family<List<UserModel>, List<String>>((ref, userIds) async {
  if (userIds.isEmpty) return [];
  
  final userController = ref.watch(userNotifierProvider.notifier);
  final users = await Future.wait(
    userIds.map((uid) => userController.getUserData(uid).catchError((e) => null)),
  );
  
  // Filter out null values (users that weren't found) and return the list
  return users.whereType<UserModel>().toList();
});

final selectedSplitOptionProvider = StateProvider<int>((ref) => -1);

final expensePayerIdProvider = StateProvider<String?>((ref) {
  final user = ref.read(currentUserProvider);
  return user?.id;
});

// Provider for advanced split method
final advancedSplitMethodProvider = StateProvider<String?>((ref) => null);

// Provider for selected split method
final splitMethodProvider =
    StateProvider<SplitMethod>((ref) => SplitMethod.equal);

// Provider for custom split amounts
final customSplitAmountsProvider =
    StateProvider<Map<String, double>>((ref) => {});

// Provider for custom split percentages
final customSplitPercentagesProvider =
    StateProvider<Map<String, double>>((ref) => {});

// Provider for user shares
final userSharesProvider = StateProvider<Map<String, int>>((ref) {
  // Get users from the box store
  final users = ref.read(userInBoxStoreProvider);
  // Initialize with 1 share for each user if there are users, otherwise return empty map
  if (users.isEmpty) return {};
  return Map<String, int>.fromEntries(
    users.where((user) => user.id != null).map((user) => MapEntry(user.id!, 1)),
  );
});

final expenseCategoryIdProvider = StateProvider<String?>((ref) => null);

final splitUserProvider =
    StateNotifierProvider<SplitUserNotifier, List<String>>((ref) {
  // Retrieve all users in the box from the provider.
  final allUsers = ref.watch(userInBoxStoreProvider);
  // Initialize SplitUserNotifier with a list of user IDs.
  return SplitUserNotifier(allUsers.map((e) => e.id!).toList());
});

// Provider for selected currency in expense
final expenseCurrencyProvider = StateProvider<String>((ref) => 'KZT');

// List of available currencies for expense
final expenseAvailableCurrenciesProvider = Provider<List<String>>((ref) => [
      'KZT',
      'USD',
      'EUR',
      'GBP',
      'RUB',
      'CNY',
      'JPY',
    ]);

final expenseDetailsProvider = FutureProvider.autoDispose.family<ExpenseModel, String>((ref, expenseId) async {
  final expenseRepository = ref.watch(expenseRepositoryProvider);
  final expenseDoc = await expenseRepository.getExpenseDetail(expenseId);
  return ExpenseModel.fromJson(expenseDoc.data);
});

final getExpenseUsersForExpenseProvider = FutureProvider.family<List<Document>, String>((ref, expenseId) async {
  final expenseRepository = ref.watch(expenseRepositoryProvider);
  final expenseUsers = await expenseRepository.getExpenseUsers(expenseId);
  return expenseUsers;
});

// Optimized provider to track a single expense user's settlement status with caching
final expenseUserSettlementStatusProvider = FutureProvider.family<bool, Map<String, String>>((ref, params) async {
  final expenseId = params['expenseId'];
  final userId = params['userId'];
  
  if (expenseId == null || userId == null) {
    throw Exception('Invalid params: expenseId and userId are required');
  }
  
  print('Checking settlement status for expense: $expenseId, user: $userId');
  
  // Use the cached expense users if available
  final allExpenseUsersAsync = ref.watch(getExpenseUsersForExpenseProvider(expenseId));
  
  // If we already have the expense users loaded, use them
  if (allExpenseUsersAsync.hasValue) {
    try {
      final expenseUsers = allExpenseUsersAsync.value!;
      final expenseUser = expenseUsers.firstWhere(
        (eu) => ExpenseUserModel.fromJson(eu.data).userId == userId,
      );
      
      final isSettled = ExpenseUserModel.fromJson(expenseUser.data).isSettled;
      print('Settlement status for user $userId: $isSettled (from cache)');
      return isSettled;
    } catch (e) {
      print('Error getting expense user from cache: $e');
      // Fall through to direct fetch if cache lookup fails
    }
  }
  
  // Direct fetch if not in cache
  final repository = ref.read(expenseRepositoryProvider);
  final expenseUsers = await repository.getExpenseUsers(expenseId);
  
  try {
    final expenseUser = expenseUsers.firstWhere(
      (eu) => ExpenseUserModel.fromJson(eu.data).userId == userId,
    );
    
    final isSettled = ExpenseUserModel.fromJson(expenseUser.data).isSettled;
    print('Settlement status for user $userId: $isSettled (direct fetch)');
    return isSettled;
  } catch (e) {
    print('Error getting expense user: $e');
    return false;
  }
});
