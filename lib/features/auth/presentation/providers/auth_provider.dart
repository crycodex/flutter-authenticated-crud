import 'package:flutter_riverpod/legacy.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/infraestructure.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepostory = AuthRepositoryImpl();

  return AuthNotifier(authRepostory: authRepostory);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepostory authRepostory;
  AuthNotifier({required this.authRepostory}) : super(AuthState());

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final user = await authRepostory.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentialsError {
      logout('Credenciales incorrectas');
    } on Exception {
      logout('Error al iniciar sesión');
    } catch (e) {
      logout('Error al iniciar sesión');
    }
  }

  void registerUser(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final user = await authRepostory.register(email, password, name, [], '');
      _setLoggedUser(user);
    } on Exception {
      logout('Error al registrar usuario');
    } catch (e) {
      logout('Error al registrar usuario');
    }
  }

  void checkAuthStatus() async {}
  _setLoggedUser(User user) {
    //token
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }

  void logout([String? errorMessage]) async {
    //limpiar token
    state = state.copyWith(
      status: AuthStatus.notAuthenticated,
      user: null,
      authStatus: AuthStatus.notAuthenticated,
      errorMessage: errorMessage ?? 'Cerrando sesión...',
    );
  }
}

enum AuthStatus {
  checking,
  authenticated,
  notAuthenticated,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String errorMessage;
  final AuthStatus authStatus;
  AuthState({
    this.status = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
    this.authStatus = AuthStatus.checking,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    AuthStatus? authStatus,
  }) =>
      AuthState(
          status: status ?? this.status,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage,
          authStatus: authStatus ?? this.authStatus);
}
