import 'package:dongi/modules/group/data/source/repository/group_repository_impl.dart';
import 'package:dongi/core/di/appwrite_di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongi/modules/group/data/source/network/group_remote_data_source.dart';
import 'package:dongi/modules/group/domain/repository/group_repository.dart';

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final remoteDataSource = GroupRemoteDataSource(db: db);

  return GroupRepositoryImpl(remoteDataSource: remoteDataSource);
});
