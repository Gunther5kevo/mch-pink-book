/// Application Constants
/// All app-wide constants in one place
library;

import 'package:flutter/material.dart';

/// App Colors - Based on Pink Book theme
class AppColors {
  // Primary Colors (Pink theme)
  static const Color primaryPink = Color(0xFFF48FB1);
  static const Color primaryPinkDark = Color(0xFFF06292);
  static const Color primaryPinkLight = Color(0xFFFCE4EC);
  
  // Secondary Color (ADDED)
  static const Color secondary = Color(0xFF7E57C2); // Purple secondary color
  
  // Accent Colors
  static const Color accentBlue = Color(0xFF42A5F5);
  static const Color accentGreen = Color(0xFF66BB6A);
  static const Color accentOrange = Color(0xFFFF9800);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Neutral Colors
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  static const Color background = Color(0xFFFAFAFA);
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFE0E0E0);

  static get primaryBlue => null;
}

/// Typography
class AppTextStyles {
  static const String fontFamily = 'Roboto';
  
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    fontFamily: fontFamily,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
    fontFamily: fontFamily,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    fontFamily: fontFamily,
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
    fontFamily: fontFamily,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textDark,
    fontFamily: fontFamily,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textLight,
    fontFamily: fontFamily,
  );
  
  // Special
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamily,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textLight,
    fontFamily: fontFamily,
  );
}

/// Spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Border Radius
class AppBorderRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
}

/// Durations for animations
class AppDurations {
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 500);
}

/// User Roles
enum UserRole {
  mother,
  nurse,
  admin;

  String get displayName {
    switch (this) {
      case UserRole.mother:
        return 'Mother';
      case UserRole.nurse:
        return 'Healthcare Provider';
      case UserRole.admin:
        return 'Administrator';
    }
  }
  
  /// Get user-friendly description
  String get description {
    switch (this) {
      case UserRole.mother:
        return 'Expectant or nursing mother';
      case UserRole.nurse:
        return 'Healthcare provider or nurse';
      case UserRole.admin:
        return 'System administrator';
    }
  }
  
  /// Check if role requires license number
  bool get requiresLicense {
    return this == UserRole.nurse || this == UserRole.admin;
  }
  
  /// Check if role requires clinic assignment
  bool get requiresClinic {
    return this == UserRole.nurse;
  }
  
  /// Check if role requires home clinic
  bool get requiresHomeClinic {
    return this == UserRole.mother;
  }
}

/// Visit Types
enum VisitType {
  anc,
  delivery,
  postnatal,
  immunization,
  growthMonitoring,
  general;

  String get displayName {
    switch (this) {
      case VisitType.anc:
        return 'ANC Visit';
      case VisitType.delivery:
        return 'Delivery';
      case VisitType.postnatal:
        return 'Postnatal';
      case VisitType.immunization:
        return 'Immunization';
      case VisitType.growthMonitoring:
        return 'Growth Monitoring';
      case VisitType.general:
        return 'General Visit';
    }
  }
}

/// Appointment Status
enum AppointmentStatus {
  scheduled,
  completed,
  missed,
  cancelled,
  rescheduled;

  String get displayName {
    switch (this) {
      case AppointmentStatus.scheduled:
        return 'Scheduled';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.missed:
        return 'Missed';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.rescheduled:
        return 'Rescheduled';
    }
  }

  Color get color {
    switch (this) {
      case AppointmentStatus.scheduled:
        return AppColors.info;
      case AppointmentStatus.completed:
        return AppColors.success;
      case AppointmentStatus.missed:
        return AppColors.error;
      case AppointmentStatus.cancelled:
        return AppColors.textLight;
      case AppointmentStatus.rescheduled:
        return AppColors.warning;
    }
  }
}


/// Language Options
enum LanguageCode {
  en,
  sw;

  String get displayName {
    switch (this) {
      case LanguageCode.en:
        return 'English';
      case LanguageCode.sw:
        return 'Kiswahili';
    }
  }

  String get code {
    return name;
  }
}

/// Kenyan EPI Immunization Schedule
class ImmunizationSchedule {
  static const Map<String, Map<String, dynamic>> kenyaEPI = {
    'BCG': {
      'name': 'BCG Vaccine',
      'ageWeeks': 0,
      'description': 'Protects against tuberculosis',
    },
    'OPV0': {
      'name': 'Oral Polio Vaccine 0',
      'ageWeeks': 0,
      'description': 'First dose of polio vaccine',
    },
    'OPV1': {
      'name': 'Oral Polio Vaccine 1',
      'ageWeeks': 6,
      'description': 'Second dose of polio vaccine',
    },
    'DTP-HepB-Hib1': {
      'name': 'Pentavalent 1',
      'ageWeeks': 6,
      'description': 'Protects against 5 diseases',
    },
    'PCV1': {
      'name': 'Pneumococcal 1',
      'ageWeeks': 6,
      'description': 'Protects against pneumonia',
    },
    'ROTA1': {
      'name': 'Rotavirus 1',
      'ageWeeks': 6,
      'description': 'Protects against diarrhea',
    },
    'OPV2': {
      'name': 'Oral Polio Vaccine 2',
      'ageWeeks': 10,
      'description': 'Third dose of polio vaccine',
    },
    'DTP-HepB-Hib2': {
      'name': 'Pentavalent 2',
      'ageWeeks': 10,
      'description': 'Second pentavalent dose',
    },
    'PCV2': {
      'name': 'Pneumococcal 2',
      'ageWeeks': 10,
      'description': 'Second pneumococcal dose',
    },
    'ROTA2': {
      'name': 'Rotavirus 2',
      'ageWeeks': 10,
      'description': 'Second rotavirus dose',
    },
    'OPV3': {
      'name': 'Oral Polio Vaccine 3',
      'ageWeeks': 14,
      'description': 'Fourth dose of polio vaccine',
    },
    'DTP-HepB-Hib3': {
      'name': 'Pentavalent 3',
      'ageWeeks': 14,
      'description': 'Third pentavalent dose',
    },
    'PCV3': {
      'name': 'Pneumococcal 3',
      'ageWeeks': 14,
      'description': 'Third pneumococcal dose',
    },
    'IPV': {
      'name': 'Inactivated Polio Vaccine',
      'ageWeeks': 14,
      'description': 'Injectable polio vaccine',
    },
    'MR1': {
      'name': 'Measles-Rubella 1',
      'ageWeeks': 39,
      'description': 'First measles-rubella dose at 9 months',
    },
    'YF': {
      'name': 'Yellow Fever',
      'ageWeeks': 39,
      'description': 'Yellow fever vaccine at 9 months',
    },
    'MR2': {
      'name': 'Measles-Rubella 2',
      'ageWeeks': 78,
      'description': 'Second measles-rubella dose at 18 months',
    },
  };
}

/// Routes
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String healthcareProviderSignup = '/healthcare-provider-signup';
  static const String phoneVerification = '/phone-verification';
  static const String register = '/register';
  static const String pendingVerification = '/pending-verification';
  // Mother Routes
  static const String motherHome = '/mother/home';
  static const String motherProfile = '/mother/profile';
  static const String pregnancy = '/mother/pregnancy';
  static const String childProfile = '/mother/child';
  static const String growthChart = '/mother/growth-chart';
  static const String immunizations = '/mother/immunizations';
  static const String appointments = '/mother/appointments';
  static const String healthLibrary = '/mother/health-library';
  
  // Nurse Routes
  static const String nurseHome = '/nurse/home';
  static const String patientSearch = '/nurse/search';
  static const String recordVisit = '/nurse/record-visit';
  static const String recordImmunization = '/nurse/record-immunization';
  static const String clinicStats = '/nurse/stats';
  
  // Admin Routes
  static const String adminHome = '/admin/home';
  static const String manageUsers = '/admin/users';
  static const String manageClinics = '/admin/clinics';
  static const String manageArticles = '/admin/articles';
  static const String analytics = '/admin/analytics';
}

/// Storage Keys
class StorageKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  static const String language = 'language';
  static const String onboardingComplete = 'onboarding_complete';
  static const String lastSyncTime = 'last_sync_time';
}

/// Validation Regex
class ValidationPatterns {
  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  static final RegExp kenyanPhone = RegExp(
    r'^(\+254|254|0)(7|1)[0-9]{8}$',
  );
  
  static final RegExp nationalId = RegExp(
    r'^[0-9]{7,8}$',
  );
}

/// Error Messages
class ErrorMessages {
  static const String networkError = 'No internet connection. Please check your network.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unexpected error occurred.';
  static const String authError = 'Authentication failed. Please login again.';
  static const String validationError = 'Please check your input and try again.';
}

/// Success Messages
class SuccessMessages {
  static const String dataSaved = 'Data saved successfully';
  static const String syncComplete = 'Sync completed successfully';
  static const String appointmentBooked = 'Appointment booked successfully';
  static const String recordUpdated = 'Record updated successfully';
}

// ==== VisitType Extensions ====
extension VisitTypeX on VisitType {
  IconData get icon => switch (this) {
        VisitType.anc => Icons.pregnant_woman,
        VisitType.delivery => Icons.local_hospital,
        VisitType.postnatal => Icons.child_care,
        VisitType.immunization => Icons.vaccines,
        VisitType.growthMonitoring => Icons.show_chart,
        VisitType.general => Icons.healing,
      };

  Color get color => switch (this) {
        VisitType.anc => AppColors.primaryPink,
        VisitType.delivery => AppColors.error,
        VisitType.postnatal => AppColors.accentBlue,
        VisitType.immunization => AppColors.accentGreen,
        VisitType.growthMonitoring => AppColors.accentOrange,
        VisitType.general => AppColors.textLight,
      };
}

// ==== DateTime Extensions ====
extension DateTimeX on DateTime {
  String get formattedDate {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    return '$day/$month/$year';
  }

  String get formattedTime {
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}