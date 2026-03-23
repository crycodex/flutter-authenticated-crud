import 'package:teslo_shop/features/auth/domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) {
    final Map<String, dynamic> userJson = (json['user'] is Map<String, dynamic>)
        ? json['user'] as Map<String, dynamic>
        : json;
    final Object? rawRoles = userJson['roles'] ?? json['roles'];
    final List<String> roles = (rawRoles is List<dynamic>)
        ? rawRoles.map((dynamic role) => role.toString()).toList()
        : <String>[];
    return User(
      id: (userJson['id'] ?? userJson['_id'] ?? '').toString(),
      email: (userJson['email'] ?? '').toString(),
      password: (userJson['password'] ?? '').toString(),
      name: (userJson['name'] ?? userJson['fullName'] ?? '').toString(),
      roles: roles,
      token: (json['token'] ?? userJson['token'] ?? '').toString(),
    );
  }
}
