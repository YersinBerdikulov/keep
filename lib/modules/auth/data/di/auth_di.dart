import 'package:dongi/core/di/appwrite_di.dart';
import 'package:dongi/modules/auth/data/source/network/auth_remote_data_source.dart';
import 'package:dongi/modules/auth/data/source/repository/auth_repository_impl.dart';
import 'package:dongi/modules/auth/domain/repository/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final account = ref.watch(appwriteAccountProvider);
  final remoteDataSource = AuthRemoteDataSource(account: account);

  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});
