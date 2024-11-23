import 'package:dongi/core/di/appwrite_di.dart';
import 'package:dongi/modules/box/data/source/network/box_remote_data_source.dart';
import 'package:dongi/modules/box/data/source/repository/box_repository_impl.dart';
import 'package:dongi/modules/box/domain/repository/box_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final boxRepositoryProvider = Provider<BoxRepository>((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final remoteDataSource = BoxRemoteDataSource(db: db);

  return BoxRepositoryImpl(remoteDataSource: remoteDataSource);
});
