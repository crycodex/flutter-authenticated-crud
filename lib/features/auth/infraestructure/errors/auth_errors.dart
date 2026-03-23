class WrongCredentialsError implements Exception {}

class InvalidTokenError implements Exception {}

class ConnectionTimeoutError implements Exception {}

class CustomError implements Exception {
  final String message;
  final int errorCode;

  CustomError({required this.message, required this.errorCode});
}
