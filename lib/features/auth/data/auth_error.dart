class AuthError implements Exception {
  const AuthError({required this.message, this.code, this.statusCode});

  final String message;
  final String? code;
  final String? statusCode;
}
