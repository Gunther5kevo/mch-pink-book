/// Child Entity (Domain Layer)
library;

import 'package:equatable/equatable.dart';
import 'package:postgrest/src/types.dart';

class ChildEntity extends Equatable {
  final String id;
  final String motherId;
  final String? pregnancyId;
  final String name;
  final DateTime dateOfBirth;
  final String gender;
  final double? birthWeight;
  final double? birthLength;
  final double? headCircumference;
  final String? birthPlace;
  final String? birthCertificateNo;
  final Map<String, dynamic>? apgarScore;
  final String? birthComplications;
  final String uniqueQrCode;
  final String? photoUrl;
  final bool isActive;
  final int version;
  final DateTime lastUpdatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChildEntity({
    required this.id,
    required this.motherId,
    this.pregnancyId,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    this.birthWeight,
    this.birthLength,
    this.headCircumference,
    this.birthPlace,
    this.birthCertificateNo,
    this.apgarScore,
    this.birthComplications,
    required this.uniqueQrCode,
    this.photoUrl,
    required this.isActive,
    required this.version,
    required this.lastUpdatedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChildEntity.fromJson(PostgrestMap json) {
    print('DEBUG [ChildEntity.fromJson]: Parsing JSON: $json');
    print('DEBUG: date_of_birth value: ${json['date_of_birth']}');
    print('DEBUG: date_of_birth type: ${json['date_of_birth'].runtimeType}');
    
    return ChildEntity(
      id: json['id'] as String,
      motherId: json['mother_id'] as String,
      pregnancyId: json['pregnancy_id'] as String?,
      name: json['name'] as String,
      dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
      gender: json['gender'] as String,
      birthWeight: json['birth_weight'] != null
          ? double.tryParse(json['birth_weight'].toString())
          : null,
      birthLength: json['birth_length'] != null
          ? double.tryParse(json['birth_length'].toString())
          : null,
      headCircumference: json['head_circumference'] != null
          ? double.tryParse(json['head_circumference'].toString())
          : null,
      birthPlace: json['birth_place'] as String?,
      birthCertificateNo: json['birth_certificate_no'] as String?,
      apgarScore: json['apgar_score'] as Map<String, dynamic>?,
      birthComplications: json['birth_complications'] as String?,
      uniqueQrCode: json['unique_qr_code'] as String,
      photoUrl: json['photo_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      version: json['version'] as int? ?? 1,
      lastUpdatedAt: DateTime.parse(json['last_updated_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Calculate age in months
  int get ageInMonths {
    final now = DateTime.now();
    final months = (now.year - dateOfBirth.year) * 12 + 
                   (now.month - dateOfBirth.month);
    return months;
  }

  /// Calculate age in days
  int get ageInDays {
    final now = DateTime.now();
    return now.difference(dateOfBirth).inDays;
  }

  /// Calculate age in years
  int get ageInYears {
    final now = DateTime.now();
    int years = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month || 
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      years--;
    }
    return years;
  }

  /// Get formatted age string
  String get ageString {
    final months = ageInMonths;
    if (months < 1) {
      final days = ageInDays;
      return '$days ${days == 1 ? 'day' : 'days'} old';
    } else if (months < 12) {
      return '$months ${months == 1 ? 'month' : 'months'} old';
    } else {
      final years = ageInYears;
      final remainingMonths = months - (years * 12);
      if (remainingMonths == 0) {
        return '$years ${years == 1 ? 'year' : 'years'} old';
      }
      return '$years ${years == 1 ? 'yr' : 'yrs'}, $remainingMonths ${remainingMonths == 1 ? 'mo' : 'mos'}';
    }
  }

  /// Get formatted date of birth (DD/MM/YYYY)
  String get dateOfBirthFormatted {
    print('DEBUG [ChildEntity]: Formatting date: $dateOfBirth');
    return '${dateOfBirth.day.toString().padLeft(2, '0')}/'
           '${dateOfBirth.month.toString().padLeft(2, '0')}/'
           '${dateOfBirth.year}';
  }

  /// Get age category (Infant, Toddler, Child)
  String get ageCategory {
    final months = ageInMonths;
    if (months < 12) return 'Infant';
    if (months < 36) return 'Toddler';
    return 'Child';
  }

  /// Get QR code (alias for uniqueQrCode)
  String get qrCode => uniqueQrCode;

  /// Check if birth weight is low (< 2.5 kg)
  bool get isLowBirthWeight {
    return birthWeight != null && birthWeight! < 2.5;
  }

  /// Check if child is under 5 years (eligible for MCH services)
  bool get isUnderFive {
    return ageInMonths < 60;
  }

  /// Get gender display
  String get genderDisplay {
    switch (gender.toLowerCase()) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      default:
        return 'Other';
    }
  }

  /// Get full name (trimmed)
  String get fullName => name.trim();

  ChildEntity copyWith({
    String? id,
    String? motherId,
    String? pregnancyId,
    String? name,
    DateTime? dateOfBirth,
    String? gender,
    double? birthWeight,
    double? birthLength,
    double? headCircumference,
    String? birthPlace,
    String? birthCertificateNo,
    Map<String, dynamic>? apgarScore,
    String? birthComplications,
    String? uniqueQrCode,
    String? photoUrl,
    bool? isActive,
    int? version,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildEntity(
      id: id ?? this.id,
      motherId: motherId ?? this.motherId,
      pregnancyId: pregnancyId ?? this.pregnancyId,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      birthWeight: birthWeight ?? this.birthWeight,
      birthLength: birthLength ?? this.birthLength,
      headCircumference: headCircumference ?? this.headCircumference,
      birthPlace: birthPlace ?? this.birthPlace,
      birthCertificateNo: birthCertificateNo ?? this.birthCertificateNo,
      apgarScore: apgarScore ?? this.apgarScore,
      birthComplications: birthComplications ?? this.birthComplications,
      uniqueQrCode: uniqueQrCode ?? this.uniqueQrCode,
      photoUrl: photoUrl ?? this.photoUrl,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mother_id': motherId,
      'pregnancy_id': pregnancyId,
      'name': name,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'gender': gender,
      'birth_weight': birthWeight,
      'birth_length': birthLength,
      'head_circumference': headCircumference,
      'birth_place': birthPlace,
      'birth_certificate_no': birthCertificateNo,
      'apgar_score': apgarScore,
      'birth_complications': birthComplications,
      'unique_qr_code': uniqueQrCode,
      'photo_url': photoUrl,
      'is_active': isActive,
      'version': version,
      'last_updated_at': lastUpdatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        motherId,
        pregnancyId,
        name,
        dateOfBirth,
        gender,
        birthWeight,
        birthLength,
        headCircumference,
        birthPlace,
        birthCertificateNo,
        apgarScore,
        birthComplications,
        uniqueQrCode,
        photoUrl,
        isActive,
        version,
        lastUpdatedAt,
        createdAt,
        updatedAt,
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChildEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ChildEntity(id: $id, name: $name, dateOfBirth: $dateOfBirth, gender: $gender, motherId: $motherId)';
  }
}