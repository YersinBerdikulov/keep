import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/storage/storage_service.dart';
import 'appwrite_di.dart';

final storageProvider = Provider((ref) {
  return StorageService(
    storage: ref.watch(appwriteStorageProvider),
  );
});
