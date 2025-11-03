/// User Model
/// Represents a user in the system (mother, nurse, or admin)
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
@HiveType(typeId: 0)
class UserModel with _$UserModel {
  const factory UserModel({
    @HiveField(0) required String id,
    @HiveField(1) required String fullName,
    @HiveField(2) String? email,
    @HiveField(3) String? phoneE164,
    @HiveField(4) String? nationalId,
    @HiveField(5) required String role,
    @HiveField(6) String? clinicId,
    @HiveField(7) String? licenseNumber,
    @HiveField(8) required String languagePref,
    @HiveField(9) String? emergencyContact,
    @HiveField(10) String? emergencyName,
    @HiveField(11) String? homeClinicId,
    @HiveField(12) String? deviceId,
    @HiveField(13) DateTime? lastSyncAt,
    @HiveField(14) required bool consentGiven,
    @HiveField(15) DateTime? consentDate,
    @HiveField(16) @Default(false) bool emailVerified,
    @HiveField(17) @Default(false) bool phoneVerified,
    @HiveField(18) @Default(true) bool isActive,
    @HiveField(19) @Default({}) Map<String, dynamic> metadata,
    @HiveField(20) required DateTime createdAt,
    @HiveField(21) required DateTime updatedAt,
  }) = _UserModel;

  const UserModel._();

  /// Create from JSON (from Supabase)
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  /// Convert to Entity (domain layer)
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      fullName: fullName,
      email: email,
      phoneE164: phoneE164,
      nationalId: nationalId,
      role: _parseRole(role),
      clinicId: clinicId,
      licenseNumber: licenseNumber,
      languagePref: _parseLanguage(languagePref),
      emergencyContact: emergencyContact,
      emergencyName: emergencyName,
      homeClinicId: homeClinicId,
      deviceId: deviceId,
      lastSyncAt: lastSyncAt,
      consentGiven: consentGiven,
      consentDate: consentDate,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      isActive: isActive,
      metadata: metadata,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create from Entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      fullName: entity.fullName,
      email: entity.email,
      phoneE164: entity.phoneE164,
      nationalId: entity.nationalId,
      role: entity.role.name,
      clinicId: entity.clinicId,
      licenseNumber: entity.licenseNumber,
      languagePref: entity.languagePref.code,
      emergencyContact: entity.emergencyContact,
      emergencyName: entity.emergencyName,
      homeClinicId: entity.homeClinicId,
      deviceId: entity.deviceId,
      lastSyncAt: entity.lastSyncAt,
      consentGiven: entity.consentGiven,
      consentDate: entity.consentDate,
      emailVerified: entity.emailVerified,
      phoneVerified: entity.phoneVerified,
      isActive: entity.isActive,
      metadata: entity.metadata,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Helper to parse role string to enum
  static UserRole _parseRole(String role) {
    return UserRole.values.firstWhere(
      (r) => r.name == role,
      orElse: () => UserRole.mother,
    );
  }

  /// Helper to parse language string to enum
  static LanguageCode _parseLanguage(String lang) {
    return LanguageCode.values.firstWhere(
      (l) => l.code == lang,
      orElse: () => LanguageCode.en,
    );
  }
}