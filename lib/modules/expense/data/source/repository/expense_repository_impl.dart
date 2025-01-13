import 'package:appwrite/models.dart';
import 'package:dongi/shared/types/type_defs.dart';
import 'package:dongi/modules/expense/domain/models/expense_model.dart';
import 'package:dongi/modules/expense/domain/models/expense_user_model.dart';
import 'package:dongi/modules/expense/data/source/network/expense_remote_data_source.dart';
import 'package:dongi/modules/expense/domain/repository/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource _remoteDataSource;

  ExpenseRepositoryImpl({required ExpenseRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  FutureEither<Document> addExpense(ExpenseModel expenseModel,
      {required String customId}) {
    return _remoteDataSource.addExpense(expenseModel, customId: customId);
  }

  @override
  FutureEither<bool> addExpenseUser(ExpenseUserModel expenseUser,
      {required String customId}) {
    return _remoteDataSource.addExpenseUser(expenseUser, customId: customId);
  }

  @override
  FutureEither<bool> deleteAllExpense(List<String> ids) {
    return _remoteDataSource.deleteAllExpense(ids);
  }

  @override
  FutureEither<bool> deleteExpense(String id) {
    return _remoteDataSource.deleteExpense(id);
  }

  @override
  FutureEither<bool> deleteExpenseUser(String id) {
    return _remoteDataSource.deleteExpenseUser(id);
  }

  @override
  Future<List<Document>> getCurrentUserExpenses(String uid) {
    return _remoteDataSource.getCurrentUserExpenses(uid);
  }

  @override
  Future<Document> getExpenseDetail(String expenseId) {
    return _remoteDataSource.getExpenseDetail(expenseId);
  }

  @override
  Future<List<Document>> getExpenses(String uid) {
    return _remoteDataSource.getExpenses(uid);
  }

  @override
  Future<List<Document>> getExpensesInBox(String boxId) {
    return _remoteDataSource.getExpensesInBox(boxId);
  }

  @override
  Future<List<Document>> getUsersInExpense(List<String> userIds) {
    return _remoteDataSource.getUsersInExpense(userIds);
  }

  @override
  FutureEither<Document> updateExpense(Map updateExpenseModel) {
    return _remoteDataSource.updateExpense(updateExpenseModel);
  }
}
