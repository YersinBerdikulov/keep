import 'package:appwrite/models.dart';
import 'package:dongi/core/types/type_defs.dart';
import 'package:dongi/models/expense_model.dart';
import 'package:dongi/models/expense_user_model.dart';

abstract class ExpenseRepository {
  FutureEither<Document> addExpense(ExpenseModel expenseModel,
      {required String customId});
  FutureEither<Document> updateExpense(Map updateExpenseModel);
  Future<List<Document>> getExpenses(String uid);
  Future<List<Document>> getExpensesInBox(String groupId);
  Future<Document> getExpenseDetail(String expenseId);
  Future<List<Document>> getUsersInExpense(List<String> userIds);
  Future<List<Document>> getCurrentUserExpenses(String uid);
  FutureEither<bool> deleteExpense(String id);
  FutureEither<bool> deleteAllExpense(List<String> ids);
  FutureEither<bool> addExpenseUser(ExpenseUserModel expenseUser,
      {required String customId});
  FutureEither<bool> deleteExpenseUser(String id);
}
