/// Custom Failure Classes for Error Handling
/// Using sealed classes for type-safe error handling
library;

import 'package:equatable/equatable.dart';

/// Base Failure class
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final dynamic details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];
}

/// Server/API Failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Network/Connectivity Failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.code,
    super.details,
  });
}

/// Cache/Local Storage Failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Authentication Failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Validation Failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Permission Failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Sync Failures
class SyncFailure extends Failure {
  const SyncFailure({
    required super.message,
    super.code,
    super.details,
  });
}

/// Conflict Failures (for offline sync conflicts)
class ConflictFailure extends Failure {
  final Map<String, dynamic>? clientData;
  final Map<String, dynamic>? serverData;

  const ConflictFailure({
    required super.message,
    super.code,
    this.clientData,
    this.serverData,
  }) : super(details: null);

  @override
  List<Object?> get props => [message, code, clientData, serverData];
}

/// Unknown/Unexpected Failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred',
    super.code,
    super.details,
  });
}