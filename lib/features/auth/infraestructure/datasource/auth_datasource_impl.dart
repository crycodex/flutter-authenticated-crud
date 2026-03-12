import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/infraestructure/mappers/user_mapper.dart';
import 'package:teslo_shop/features/auth/infraestructure/infraestructure.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: Enviroment.apiUrl));

  final AuthDatasource authDatasource;

  AuthDatasourceImpl({AuthDatasource? authDatasource})
      : authDatasource = authDatasource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return authDatasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post("/auth/login", data: {
        "email": email,
        "password": password,
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } catch (e) {
      throw WrongCredentialsError();
    }
  }

  @override
  Future<User> register(String email, String password, String name,
      List<String> roles, String token) {
    return authDatasource.register(email, password, name, roles, token);
  }
}
