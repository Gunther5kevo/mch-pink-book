/// Form Validators - Supabase Auth Edition
/// Minimal client-side validation (Supabase handles server-side)
/// Location: lib/core/utils/validators.dart
library;


import '../../core/constants/app_constants.dart';
class Validators {
  Validators._();

  // ==========================================================================
  // AUTH VALIDATORS
  // ==========================================================================

  /// Basic email format check
  /// Supabase will do full validation server-side
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final trimmed = value.trim();
    
    // Simple email pattern - just catch obvious typos
    if (!trimmed.contains('@') || !trimmed.contains('.')) {
      return 'Enter a valid email address';
    }

    return null;
  }

  /// Password minimum length
  /// Supabase default is 6 characters
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Kenyan phone number format
  /// Supports: 0712345678, 712345678, 254712345678, +254712345678
  static String? phoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final cleaned = value.replaceAll(RegExp(r'[^\d+]'), '');
    final digitsOnly = cleaned.replaceAll('+', '');

    // Valid formats:
    // +254712345678 or 254712345678 (12 digits)
    // 0712345678 (10 digits)
    // 712345678 (9 digits)
    
    if (digitsOnly.startsWith('254') && digitsOnly.length == 12) {
      return null;
    }
    
    if (digitsOnly.startsWith('0') && digitsOnly.length == 10) {
      if (!digitsOnly.startsWith('07') && !digitsOnly.startsWith('01')) {
        return 'Phone must start with 07 or 01';
      }
      return null;
    }
    
    if ((digitsOnly.startsWith('7') || digitsOnly.startsWith('1')) && 
        digitsOnly.length == 9) {
      return null;
    }

    return 'Enter a valid phone number (e.g., 0712345678)';
  }

  // ==========================================================================
  // USER PROFILE VALIDATORS
  // ==========================================================================

  /// Full name (first + last)
  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    final trimmed = value.trim();

    if (trimmed.length < 3) {
      return 'Name must be at least 3 characters';
    }

    // Check for at least two words
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length < 2) {
      return 'Enter your full name (first and last)';
    }

    return null;
  }

  /// License number for healthcare providers
  static String? licenseNumber(String? value, UserRole? role) {
    // Only required for nurses and admins
    if (role != UserRole.nurse && role != UserRole.admin) {
      return null;
    }

    if (value == null || value.trim().isEmpty) {
      return 'License number is required';
    }

    final trimmed = value.trim();

    if (trimmed.length < 5) {
      return 'License number must be at least 5 characters';
    }

    // Alphanumeric with common separators (/, -, space)
    if (!RegExp(r'^[A-Za-z0-9/\-\s]+$').hasMatch(trimmed)) {
      return 'Invalid license format';
    }

    return null;
  }

  // ==========================================================================
  // GENERIC HELPERS
  // ==========================================================================

  /// Required field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Minimum length
  static String? minLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Field'} is required';
    }

    if (value.length < length) {
      return '${fieldName ?? 'Field'} must be at least $length characters';
    }

    return null;
  }
}

// ==========================================================================
// CONVENIENCE EXTENSIONS
// ==========================================================================

extension StringValidatorX on String? {
  bool get isValidEmail => Validators.email(this) == null;
  bool get isValidPhone => Validators.phoneNumber(this) == null;
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
  bool get isNotEmpty => !isNullOrEmpty;
}