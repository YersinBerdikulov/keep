import 'package:dongi/core/di/appwrite_di.dart';
import 'package:dongi/modules/expense/data/source/network/category_remote_data_source.dart';
import 'package:dongi/modules/expense/data/source/repository/category_repository_impl.dart';
import 'package:dongi/modules/expense/domain/repository/category_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final remoteDataSource = CategoryRemoteDataSource(db: db);

  return CategoryRepositoryImpl(remoteDataSource: remoteDataSource);
});

