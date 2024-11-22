import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/storage/storage_service.dart';
import 'appwrite_di.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: ref.watch(appwriteStorageProvider),
  );
});
