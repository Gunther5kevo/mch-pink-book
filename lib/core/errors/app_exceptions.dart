/// Application Exceptions
/// Custom exception classes for better error handling
library;

/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => message;
}

/// Database-related exceptions
class DatabaseException extends AppException {
  DatabaseException(super.message, {super.code, super.originalError});
}

/// Network-related exceptions
class NetworkException extends AppException {
  NetworkException(super.message, {super.code, super.originalError});
}

/// Authentication exceptions
class AuthException extends AppException {
  AuthException(super.message, {super.code, super.originalError});
}

/// Validation exceptions
class ValidationException extends AppException {
  ValidationException(super.message, {super.code, super.originalError});
}

/// Not found exceptions
class NotFoundException extends AppException {
  NotFoundException(super.message, {super.code, super.originalError});
}

/// Permission/Authorization exceptions
class PermissionException extends AppException {
  PermissionException(super.message, {super.code, super.originalError});
}

/// Server exceptions
class ServerException extends AppException {
  ServerException(super.message, {super.code, super.originalError});
}