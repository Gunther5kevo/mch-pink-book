/// User Entity (Domain Layer)
/// Pure business logic representation of a user
/// No dependencies on external packages
library;

import 'package:equatable/equatable.dart';
import '../../core/constants/app_constants.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String? email;
  final String? phoneE164;
  final String? nationalId;
  final UserRole role;
  final String? clinicId;
  final String? licenseNumber;
  final String? facilityName;
  final LanguageCode languagePref;
  final String? emergencyContact;
  final String? emergencyName;
  final String? homeClinicId;
  final String? deviceId;
  final DateTime? lastSyncAt;
  final bool consentGiven;
  final DateTime? consentDate;
  final bool emailVerified;
  final bool phoneVerified;
  final bool isActive;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // NEW: Profile setup fields
  final bool hasCompletedSetup;
  final String? preferredClinic;
  final DateTime? lastVisitDate;

  const UserEntity({
    required this.id,
    required this.fullName,
    this.email,
    this.phoneE164,
    this.nationalId,
    required this.role,
    this.clinicId,
    this.licenseNumber,
    this.facilityName,
    required this.languagePref,
    this.emergencyContact,
    this.emergencyName,
    this.homeClinicId,
    this.deviceId,
    this.lastSyncAt,
    required this.consentGiven,
    this.consentDate,
    this.emailVerified = false,
    this.phoneVerified = false,
    required this.isActive,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.hasCompletedSetup = false,
    this.preferredClinic,
    this.lastVisitDate,
  });

  /// Factory constructor to create UserEntity from JSON (snake_case from Supabase)
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String?,
      phoneE164: json['phone_e164'] as String?,
      nationalId: json['national_id'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.mother,
      ),
      clinicId: json['clinic_id'] as String?,
      licenseNumber: json['license_number'] as String?,
      facilityName: json['facility_name'] as String?,
      languagePref: LanguageCode.values.firstWhere(
        (e) => e.name == json['language_pref'],
        orElse: () => LanguageCode.en,
      ),
      emergencyContact: json['emergency_contact'] as String?,
      emergencyName: json['emergency_name'] as String?,
      homeClinicId: json['home_clinic_id'] as String?,
      deviceId: json['device_id'] as String?,
      lastSyncAt: json['last_sync_at'] != null
          ? DateTime.parse(json['last_sync_at'] as String)
          : null,
      consentGiven: json['consent_given'] as bool? ?? false,
      consentDate: json['consent_date'] != null
          ? DateTime.parse(json['consent_date'] as String)
          : null,
      emailVerified: json['email_verified'] as bool? ?? false,
      phoneVerified: json['phone_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      metadata: json['metadata'] != null 
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      // NEW fields
      hasCompletedSetup: json['has_completed_setup'] as bool? ?? false,
      preferredClinic: json['preferred_clinic'] as String?,
      lastVisitDate: json['last_visit_date'] != null
          ? DateTime.parse(json['last_visit_date'] as String)
          : null,
    );
  }

  /// Convert UserEntity to JSON (snake_case for Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_e164': phoneE164,
      'national_id': nationalId,
      'role': role.name,
      'clinic_id': clinicId,
      'license_number': licenseNumber,
      'facility_name': facilityName,
      'language_pref': languagePref.name,
      'emergency_contact': emergencyContact,
      'emergency_name': emergencyName,
      'home_clinic_id': homeClinicId,
      'device_id': deviceId,
      'last_sync_at': lastSyncAt?.toIso8601String(),
      'consent_given': consentGiven,
      'consent_date': consentDate?.toIso8601String(),
      'email_verified': emailVerified,
      'phone_verified': phoneVerified,
      'is_active': isActive,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      // NEW fields
      'has_completed_setup': hasCompletedSetup,
      'preferred_clinic': preferredClinic,
      'last_visit_date': lastVisitDate?.toIso8601String(),
    };
  }

  /// Check if user is a mother
  bool get isMother => role == UserRole.mother;

  /// Check if user is a nurse
  bool get isNurse => role == UserRole.nurse;

  /// Check if user is an admin
  bool get isAdmin => role == UserRole.admin;

  /// Check if user is a healthcare provider
  bool get isHealthcareProvider => isNurse || isAdmin;

  /// Check if user has completed consent
  bool get hasValidConsent => consentGiven && consentDate != null;

  /// Check if user is verified (email or phone)
  bool get isVerified {
    if (email != null && !emailVerified) return false;
    if (phoneE164 != null && !phoneVerified) return false;
    return true;
  }

  /// Get primary contact method
  String? get primaryContact => email ?? phoneE164;

  /// Check if user profile is complete
  bool get isProfileComplete {
    // Must have either email or phone
    if (email == null && phoneE164 == null) return false;
    
    if (isMother) {
      // For mothers, profile is complete if they've done setup OR have old profile data
      return fullName.isNotEmpty &&
          (email != null || phoneE164 != null) &&
          hasValidConsent &&
          (hasCompletedSetup || homeClinicId != null);
    } else if (isNurse) {
      return fullName.isNotEmpty &&
          (email != null || phoneE164 != null) &&
          clinicId != null &&
          licenseNumber != null &&
          licenseNumber!.isNotEmpty;
    } else if (isAdmin) {
      return fullName.isNotEmpty &&
          (email != null || phoneE164 != null) &&
          licenseNumber != null &&
          licenseNumber!.isNotEmpty;
    }
    return fullName.isNotEmpty && (email != null || phoneE164 != null);
  }

  /// Check if mother needs to complete profile setup
  bool get needsProfileSetup {
    return isMother && !hasCompletedSetup;
  }

  /// Get display name with role
  String get displayNameWithRole => '$fullName (${role.displayName})';

  /// Get role display name
  String get roleDisplayName {
    switch (role) {
      case UserRole.mother:
        return 'Mother';
      case UserRole.nurse:
        return 'Healthcare Provider';
      case UserRole.admin:
        return 'Administrator';
    }
  }

  /// Copy with method for immutability
  UserEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneE164,
    String? nationalId,
    UserRole? role,
    String? clinicId,
    String? licenseNumber,
    String? facilityName,
    LanguageCode? languagePref,
    String? emergencyContact,
    String? emergencyName,
    String? homeClinicId,
    String? deviceId,
    DateTime? lastSyncAt,
    bool? consentGiven,
    DateTime? consentDate,
    bool? emailVerified,
    bool? phoneVerified,
    bool? isActive,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? hasCompletedSetup,
    String? preferredClinic,
    DateTime? lastVisitDate,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneE164: phoneE164 ?? this.phoneE164,
      nationalId: nationalId ?? this.nationalId,
      role: role ?? this.role,
      clinicId: clinicId ?? this.clinicId,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      facilityName: facilityName ?? this.facilityName,
      languagePref: languagePref ?? this.languagePref,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyName: emergencyName ?? this.emergencyName,
      homeClinicId: homeClinicId ?? this.homeClinicId,
      deviceId: deviceId ?? this.deviceId,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      consentGiven: consentGiven ?? this.consentGiven,
      consentDate: consentDate ?? this.consentDate,
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasCompletedSetup: hasCompletedSetup ?? this.hasCompletedSetup,
      preferredClinic: preferredClinic ?? this.preferredClinic,
      lastVisitDate: lastVisitDate ?? this.lastVisitDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phoneE164,
        nationalId,
        role,
        clinicId,
        licenseNumber,
        facilityName,
        languagePref,
        emergencyContact,
        emergencyName,
        homeClinicId,
        deviceId,
        lastSyncAt,
        consentGiven,
        consentDate,
        emailVerified,
        phoneVerified,
        isActive,
        metadata,
        createdAt,
        updatedAt,
        hasCompletedSetup,
        preferredClinic,
        lastVisitDate,
      ];

  String? get photoUrl => null;

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $fullName, role: $role, email: $email, phone: $phoneE164, setupComplete: $hasCompletedSetup)';
  }
}