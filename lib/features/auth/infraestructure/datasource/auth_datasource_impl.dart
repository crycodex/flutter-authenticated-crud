import 'package:teslo_shop/features/auth/domain/domain.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final AuthDatasource authDatasource;

  AuthDatasourceImpl({AuthDatasource? authDatasource})
      : authDatasource = authDatasource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return authDatasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return authDatasource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String name,
      List<String> roles, String token) {
    return authDatasource.register(email, password, name, roles, token);
  }
}
