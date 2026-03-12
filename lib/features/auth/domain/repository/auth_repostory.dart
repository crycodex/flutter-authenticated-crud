import '../entities/user.dart';

abstract class AuthRepostory {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String name,
      List<String> roles, String token);
  Future<User> checkAuthStatus();
}
