import 'package:appwrite/appwrite.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dongi/core/constants/appwrite_config.dart';

/// Appwrite Client Provider
/// Provides the base client configuration for Appwrite
final appwriteClientProvider = Provider((ref) {
  Client client = Client();
  return client
      .setEndpoint(AppwriteConfig.endPoint)
      .setProject(AppwriteConfig.projectId)
      .setSelfSigned(status: true);
});

/// Account Management
final appwriteAccountProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Account(client);
});

/// Database Operations
final appwriteDatabaseProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Databases(client);
});

/// Storage Operations
final appwriteStorageProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Storage(client);
});

/// Real-time Operations
final appwriteRealtimeProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Realtime(client);
});

/// Cloud Functions
final appwriteFunctionProvider = Provider((ref) {
  final client = ref.watch(appwriteClientProvider);
  return Functions(client);
});
