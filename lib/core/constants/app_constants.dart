/// Application Constants
/// All app-wide constants in one place
library;

import 'package:flutter/material.dart';

/// App Colors - Based on Pink Book theme (MCH Digital Health)
class AppColors {
  // Primary Colors (Pink theme)
  static const Color primaryPink = Color(0xFFF48FB1);
  static const Color primaryPinkDark = Color(0xFFF06292);
  static const Color primaryPinkLight = Color(0xFFFCE4EC);
  
  // Secondary Color
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
  static const Color textMedium = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color background = Color(0xFFFAFAFA);
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFE0E0E0);
  static const Color surface = Color(0xFFF5F5F5);

  // Shadows & Overlays
  static const Color shadow = Color(0x1F000000);
  static const Color overlayDark = Color(0x80000000);
  static const Color overlayLight = Color(0x1AFFFFFF);

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

  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    fontFamily: fontFamily,
  );
  
  static const TextStyle h5 = TextStyle(
    fontSize: 16,
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
    color: Colors.white,
    fontFamily: fontFamily,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textMedium,
    fontFamily: fontFamily,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 13,
    color: AppColors.textMedium,
    fontFamily: fontFamily,
  );

  // Error
  static const TextStyle error = TextStyle(
    fontSize: 14,
    color: AppColors.error,
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
  static const double xxl = 24.0;
  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
}

/// Durations for animations
class AppDurations {
  static const Duration short = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 500);
}

/// Icons
class AppIcons {
  static const pregnant = Icons.pregnant_woman;
  static const child = Icons.child_care;
  static const calendar = Icons.calendar_today;
  static const noteAdd = Icons.note_add;
  static const vaccines = Icons.vaccines;
  static const search = Icons.search;
  static const share = Icons.share;
  static const download = Icons.download;
  static const qrCode = Icons.qr_code;
  static const location = Icons.location_on_outlined;
  static const check = Icons.check_circle;
  static const schedule = Icons.schedule;
  static const warning = Icons.warning_amber;
  static const error = Icons.error_outline;
  static const refresh = Icons.refresh;
}

/// User Roles
enum UserRole {
  mother,
  nurse,
  admin;

  String get displayName => switch (this) {
    UserRole.mother => 'Mother',
    UserRole.nurse => 'Healthcare Provider',
    UserRole.admin => 'Administrator',
  };
  
  String get description => switch (this) {
    UserRole.mother => 'Expectant or nursing mother',
    UserRole.nurse => 'Healthcare provider or nurse',
    UserRole.admin => 'System administrator',
  };
  
  bool get requiresLicense => this == UserRole.nurse || this == UserRole.admin;
  bool get requiresClinic => this == UserRole.nurse;
  bool get requiresHomeClinic => this == UserRole.mother;
}

/// Visit Types
enum VisitType {
  anc,
  delivery,
  postnatal,
  immunization,
  growth_monitoring,
  general;

  String get displayName => switch (this) {
    VisitType.anc => 'ANC Visit',
    VisitType.delivery => 'Delivery',
    VisitType.postnatal => 'Postnatal',
    VisitType.immunization => 'Immunization',
    VisitType.growth_monitoring => 'Growth Monitoring',
    VisitType.general => 'General Visit',
  };

  static VisitType fromString(String value) {
    return values.firstWhere((e) => e.name == value, orElse: () => VisitType.general);
  }

  String get dbValue => name;
}

/// Appointment Status
enum AppointmentStatus {
  scheduled,
  completed,
  missed,
  cancelled,
  rescheduled;

  String get displayName => switch (this) {
    AppointmentStatus.scheduled => 'Scheduled',
    AppointmentStatus.completed => 'Completed',
    AppointmentStatus.missed => 'Missed',
    AppointmentStatus.cancelled => 'Cancelled',
    AppointmentStatus.rescheduled => 'Rescheduled',
  };

  Color get color => switch (this) {
    AppointmentStatus.scheduled => AppColors.info,
    AppointmentStatus.completed => AppColors.success,
    AppointmentStatus.missed => AppColors.error,
    AppointmentStatus.cancelled => AppColors.textLight,
    AppointmentStatus.rescheduled => AppColors.warning,
  };
}

/// Language Options
enum LanguageCode {
  en,
  sw;

  String get displayName => switch (this) {
    LanguageCode.en => 'English',
    LanguageCode.sw => 'Kiswahili',
  };

  String get code => name;
}

/// Kenyan EPI Immunization Schedule
class ImmunizationSchedule {
  static const Map<String, Map<String, dynamic>> kenyaEPI = {
    'BCG': {'name': 'BCG Vaccine', 'ageWeeks': 0, 'description': 'Protects against tuberculosis'},
    'OPV0': {'name': 'Oral Polio Vaccine 0', 'ageWeeks': 0, 'description': 'First dose of polio vaccine'},
    'OPV1': {'name': 'Oral Polio Vaccine 1', 'ageWeeks': 6, 'description': 'Second dose of polio vaccine'},
    'DTP-HepB-Hib1': {'name': 'Pentavalent 1', 'ageWeeks': 6, 'description': 'Protects against 5 diseases'},
    'PCV1': {'name': 'Pneumococcal 1', 'ageWeeks': 6, 'description': 'Protects against pneumonia'},
    'ROTA1': {'name': 'Rotavirus 1', 'ageWeeks': 6, 'description': 'Protects against diarrhea'},
    'OPV2': {'name': 'Oral Polio Vaccine 2', 'ageWeeks': 10, 'description': 'Third dose of polio vaccine'},
    'DTP-HepB-Hib2': {'name': 'Pentavalent 2', 'ageWeeks': 10, 'description': 'Second pentavalent dose'},
    'PCV2': {'name': 'Pneumococcal 2', 'ageWeeks': 10, 'description': 'Second pneumococcal dose'},
    'ROTA2': {'name': 'Rotavirus 2', 'ageWeeks': 10, 'description': 'Second rotavirus dose'},
    'OPV3': {'name': 'Oral Polio Vaccine 3', 'ageWeeks': 14, 'description': 'Fourth dose of polio vaccine'},
    'DTP-HepB-Hib3': {'name': 'Pentavalent 3', 'ageWeeks': 14, 'description': 'Third pentavalent dose'},
    'PCV3': {'name': 'Pneumococcal 3', 'ageWeeks': 14, 'description': 'Third pneumococcal dose'},
    'IPV': {'name': 'Inactivated Polio Vaccine', 'ageWeeks': 14, 'description': 'Injectable polio vaccine'},
    'MR1': {'name': 'Measles-Rubella 1', 'ageWeeks': 39, 'description': 'First measles-rubella dose at 9 months'},
    'YF': {'name': 'Yellow Fever', 'ageWeeks': 39, 'description': 'Yellow fever vaccine at 9 months'},
    'MR2': {'name': 'Measles-Rubella 2', 'ageWeeks': 78, 'description': 'Second measles-rubella dose at 18 months'},
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
  static final RegExp email = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static final RegExp kenyanPhone = RegExp(r'^(\+254|254|0)(7|1)[0-9]{8}$');
  static final RegExp nationalId = RegExp(r'^[0-9]{7,8}$');
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
    VisitType.growth_monitoring => Icons.show_chart,
    VisitType.general => Icons.healing,
  };

  Color get color => switch (this) {
    VisitType.anc => AppColors.primaryPink,
    VisitType.delivery => AppColors.error,
    VisitType.postnatal => AppColors.accentBlue,
    VisitType.immunization => AppColors.accentGreen,
    VisitType.growth_monitoring => AppColors.accentOrange,
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