import 'package:teslo_shop/features/auth/domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      roles: List<String>.from(json['roles'].map((role) => role.toString())),
      token: json['token'],
    );
  }
}
