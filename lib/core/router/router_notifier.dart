import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../modules/auth/domain/di/auth_controller_di.dart';

class GoRouterNotifier extends ChangeNotifier {
  final Ref ref;

  GoRouterNotifier(this.ref) {
    // Listen to auth state changes and notify `go_router`
    ref.listen(currentUserProvider, (_, __) => notifyListeners());
  }
}

final goRouterNotifierProvider = Provider<GoRouterNotifier>((ref) {
  return GoRouterNotifier(ref);
});
