import 'package:flutter_riverpod/legacy.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/infraestructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepostory = AuthRepositoryImpl();
  final keyValServ = KeyValueStorageServiceImpl();

  return AuthNotifier(authRepostory: authRepostory, keyValServ: keyValServ);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepostory authRepostory;
  final KeyValueStorageService keyValServ;

  AuthNotifier({required this.authRepostory, required this.keyValServ})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final user = await authRepostory.login(email, password);
      _setLoggedUser(user);
    } on WrongCredentialsError {
      logout('Credenciales incorrectas');
    } on InvalidTokenError {
      logout('Token inválido');
    } on ConnectionTimeoutError {
      logout('Tiempo de conexión agotado');
    } on CustomError {
      logout('Error al iniciar sesión');
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

  void checkAuthStatus() async {
    final token = await keyValServ.getValue<String>("token");

    if (token == null) return logout();

    try {
      final user = await authRepostory.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  _setLoggedUser(User user) async {
    //token
    await keyValServ.setKeyvalue("token", user.token);

    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }

  void logout([String? errorMessage]) async {
    //limpiar token
    await keyValServ.removeKey("token");

    state = state.copyWith(
      status: AuthStatus.notAuthenticated,
      user: null,
      authStatus: AuthStatus.notAuthenticated,
      errorMessage: errorMessage,
    );

    //ruta
    
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
