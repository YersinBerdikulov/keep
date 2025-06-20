import 'package:appwrite/models.dart';
import 'package:dongi/shared/types/type_defs.dart';
import 'package:dongi/modules/expense/domain/models/expense_model.dart';
import 'package:dongi/modules/expense/domain/models/expense_user_model.dart';

abstract class ExpenseRepository {
  FutureEither<Document> addExpense(ExpenseModel expenseModel,
      {required String customId});
  FutureEither<Document> updateExpense(Map updateExpenseModel);
  Future<List<Document>> getExpenses(String uid);
  Future<List<Document>> getExpensesInBox(String groupId);
  Future<Document> getExpenseDetail(String expenseId);
  Future<List<Document>> getUsersInExpense(List<String> userIds);
  Future<List<Document>> getCurrentUserExpenses(String uid);
  Future<List<Document>> getExpenseUsers(String expenseId);
  FutureEither<bool> deleteExpense(String id);
  FutureEither<bool> deleteAllExpense(List<String> ids);
  FutureEither<bool> addExpenseUser(ExpenseUserModel expenseUser,
      {required String customId});
  FutureEither<bool> deleteExpenseUser(String id);
  FutureEither<bool> updateExpenseUser(Map updateExpenseUserData);
  
  // Get recent expenses for a user (for home page)
  Future<List<Document>> getRecentExpenses(String uid);
  
  // Get all users from the database (for ID matching)
  Future<List<Document>> getAllUsers();
  
  // Get a user by ID to validate if it exists
  Future<Document> getUserDataById(String userId);
  
  // Add cache clearing methods
  Future<void> clearCacheForExpense(String expenseId);
  Future<void> clearCacheForExpenseUsers(String expenseId);
}
