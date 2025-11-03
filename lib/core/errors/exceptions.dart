/// Custom Exception Classes
/// These are thrown by data sources and caught by repositories
library;

/// Server/API Exception
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ServerException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Network Exception
class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'No internet connection']);

  @override
  String toString() => 'NetworkException: $message';
}

/// Cache Exception
class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache error occurred']);

  @override
  String toString() => 'CacheException: $message';
}

/// Authentication Exception
class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AuthException: $message ${code != null ? '($code)' : ''}';
}

/// Validation Exception
class ValidationException implements Exception {
  final String message;
  final Map<String, List<String>>? errors;

  ValidationException({
    required this.message,
    this.errors,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Permission Exception
class PermissionException implements Exception {
  final String message;
  final String permission;

  PermissionException({
    required this.message,
    required this.permission,
  });

  @override
  String toString() => 'PermissionException: $message (Permission: $permission)';
}

/// Sync Conflict Exception
class SyncConflictException implements Exception {
  final String message;
  final Map<String, dynamic> clientData;
  final Map<String, dynamic> serverData;
  final int clientVersion;
  final int serverVersion;

  SyncConflictException({
    required this.message,
    required this.clientData,
    required this.serverData,
    required this.clientVersion,
    required this.serverVersion,
  });

  @override
  String toString() => 
    'SyncConflictException: $message (Client v$clientVersion vs Server v$serverVersion)';
}