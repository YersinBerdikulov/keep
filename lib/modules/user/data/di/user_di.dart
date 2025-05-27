import 'package:appwrite/appwrite.dart';
import 'package:dongi/core/data/storage/storage_service.dart';
import 'package:dongi/modules/user/data/source/network/user_remote_data_source.dart';
import 'package:dongi/modules/user/data/source/repository/user_repository_impl.dart';
import 'package:dongi/modules/user/domain/repository/user_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/di/appwrite_di.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  final account = ref.watch(appwriteAccountProvider);
  final userRemoteDataSource =
      UserRemoteDataSource(db: databases, account: account);
  return UserRepositoryImpl(remoteDataSource: userRemoteDataSource);
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final storage = ref.watch(appwriteStorageProvider);
  return StorageService(storage: storage);
});
