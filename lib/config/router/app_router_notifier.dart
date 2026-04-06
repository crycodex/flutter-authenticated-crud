import 'package:flutter/foundation.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goRouteNotifierProvider = Provider((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return GoRouteNotifier(authNotifier);
});

class GoRouteNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;

  GoRouteNotifier(this._authNotifier) {
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
      notifyListeners();
    });
  }

  AuthStatus _authStatus = AuthStatus.checking;

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }
}
