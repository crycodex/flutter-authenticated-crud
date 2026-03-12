import 'package:teslo_shop/features/auth/domain/domain.dart';
import '../infraestructure.dart';

class AuthRepositoryImpl extends AuthRepostory {
  final AuthDatasource authDatasource;

  AuthRepositoryImpl({AuthDatasource? authDatasource})
      : authDatasource = authDatasource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus() {
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) {
    throw UnimplementedError();
  }

  @override
  Future<User> register(String email, String password, String name,
      List<String> roles, String token) {
    throw UnimplementedError();
  }
}
