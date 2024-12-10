import 'package:dongi/core/di/appwrite_di.dart';
import 'package:dongi/modules/user/data/source/network/user_remote_data_source.dart';
import 'package:dongi/modules/user/data/source/repository/user_repository_impl.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final account = ref.watch(appwriteAccountProvider);

  final remoteDataSource = UserRemoteDataSource(db: db, account: account);

  return UserRepositoryImpl(remoteDataSource: remoteDataSource);
});
