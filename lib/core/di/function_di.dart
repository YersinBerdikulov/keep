import 'package:dongi/core/data/function/function_service.dart';
import 'package:dongi/core/di/appwrite_di.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final functionProvider = Provider((ref) {
  return FunctionService(
    function: ref.watch(appwriteFunctionProvider),
  );
});
