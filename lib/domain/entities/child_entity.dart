/// Child Entity (Domain Layer)
library;

import 'package:equatable/equatable.dart';

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

  /// Get formatted age string
  String get ageString {
    final months = ageInMonths;
    if (months < 1) {
      final days = ageInDays;
      return '$days ${days == 1 ? 'day' : 'days'} old';
    } else if (months < 12) {
      return '$months ${months == 1 ? 'month' : 'months'} old';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years ${years == 1 ? 'year' : 'years'} old';
      }
      return '$years ${years == 1 ? 'year' : 'years'}, $remainingMonths ${remainingMonths == 1 ? 'month' : 'months'} old';
    }
  }

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
}