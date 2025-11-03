/// Logger Utility
/// Provides logging functionality for the application
library;

import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

class Logger {
  final String? tag;
  final bool enableInProduction;

  Logger({
    this.tag,
    this.enableInProduction = false,
  });

  /// Log debug message
  void debug(String message, [dynamic data]) {
    _log(LogLevel.debug, message, data: data);
  }

  /// Log info message
  void info(String message, [dynamic data]) {
    _log(LogLevel.info, message, data: data);
  }

  /// Log warning message
  void warning(String message, [dynamic data]) {
    _log(LogLevel.warning, message, data: data);
  }

  /// Log error message
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(
      LogLevel.error,
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log fatal error message
  void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _log(
      LogLevel.fatal,
      message,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Internal logging method
  void _log(
    LogLevel level,
    String message, {
    dynamic data,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    // Only log in debug mode unless explicitly enabled for production
    if (!kDebugMode && !enableInProduction) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase().padRight(7);
    final tagStr = tag != null ? '[$tag] ' : '';
    
    final logMessage = '$timestamp $levelStr $tagStr$message';

    // Print to console with appropriate color/style
    switch (level) {
      case LogLevel.debug:
        debugPrint('🔍 $logMessage');
        break;
      case LogLevel.info:
        debugPrint('ℹ️  $logMessage');
        break;
      case LogLevel.warning:
        debugPrint('⚠️  $logMessage');
        break;
      case LogLevel.error:
        debugPrint('❌ $logMessage');
        break;
      case LogLevel.fatal:
        debugPrint('💀 $logMessage');
        break;
    }

    // Print additional data if provided
    if (data != null) {
      debugPrint('   Data: $data');
    }

    // Print error details if provided
    if (error != null) {
      debugPrint('   Error: $error');
    }

    // Print stack trace for errors
    if (stackTrace != null) {
      debugPrint('   Stack Trace:\n$stackTrace');
    }

  }
}