import 'package:dongi/modules/expense/data/source/network/expense_remote_data_source.dart';
import 'package:dongi/modules/expense/data/source/repository/expense_repository_impl.dart';
import 'package:dongi/modules/expense/domain/repository/expense_repository.dart';
import 'package:dongi/core/di/appwrite_di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final remoteDataSource = ExpenseRemoteDataSource(db: db);

  return ExpenseRepositoryImpl(remoteDataSource: remoteDataSource);
});
