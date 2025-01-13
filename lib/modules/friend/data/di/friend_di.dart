import 'package:dongi/modules/friend/data/source/network/friend_remote_data_source.dart';
import 'package:dongi/modules/friend/data/source/repository/friend_repository_impl.dart';
import 'package:dongi/modules/friend/domain/repository/friend_repository.dart';
import 'package:dongi/core/di/appwrite_di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final friendRepositoryProvider = Provider<FriendRepository>((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final remoteDataSource = FriendRemoteDataSource(db: db);

  return FriendRepositoryImpl(remoteDataSource: remoteDataSource);
});
