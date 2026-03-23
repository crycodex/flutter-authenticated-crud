import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/infraestructure/mappers/user_mapper.dart';
import 'package:teslo_shop/features/auth/infraestructure/infraestructure.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final Dio dio;

  AuthDatasourceImpl({Dio? dio})
      : dio = dio ?? Dio(BaseOptions(baseUrl: Enviroment.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final Response<dynamic> response = await dio.get<dynamic>(
        '/auth/check-status',
        options: Options(
            headers: <String, dynamic>{'Authorization': 'Bearer $token'}),
      );
      final User user =
          UserMapper.userJsonToEntity(response.data as Map<String, dynamic>);
      return user;
    } catch (e) {
      throw InvalidTokenError();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final Response<dynamic> response =
          await dio.post<dynamic>("/auth/login", data: {
        "email": email,
        "password": password,
      });
      final User user =
          UserMapper.userJsonToEntity(response.data as Map<String, dynamic>);

      return user;
    } on DioError catch (e) {
      print(e.response?.data);
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ConnectionTimeoutError();
      }
      switch (e.response?.statusCode) {
        case 401:
          throw WrongCredentialsError();
        case 403:
          throw InvalidTokenError();
        case 500:
          throw CustomError(
              message: e.response?.data['message'],
              errorCode: e.response?.statusCode ?? 0);
        default:
          throw CustomError(
              message: e.response?.data['message'],
              errorCode: e.response?.statusCode ?? 0);
      }
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String name,
      List<String> roles, String token) async {
    try {
      final Response<dynamic> response =
          await dio.post<dynamic>("/auth/register", data: {
        "email": email,
        "password": password,
        "fullName": name,
        "roles": roles,
      });
      final User user =
          UserMapper.userJsonToEntity(response.data as Map<String, dynamic>);
      return user;
    } catch (e) {
      throw WrongCredentialsError();
    }
  }
}
