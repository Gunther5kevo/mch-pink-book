/// Growth Measurement Entity (Domain Layer)
/// Represents a growth/anthropometric measurement
library;

import 'package:equatable/equatable.dart';

class GrowthMeasurementEntity extends Equatable {
  final String id;
  final String childId;
  final DateTime measurementDate;
  final int ageMonths;
  final double? weightKg;
  final double? heightCm;
  final double? headCircumferenceCm;
  final double? muacCm; // Mid-Upper Arm Circumference
  final double? weightForAgeZ; // Z-scores based on WHO standards
  final double? heightForAgeZ;
  final double? weightForHeightZ;
  final double? bmi;
  final String? assessment; // normal, underweight, stunted, wasted
  final String? measuredBy;
  final String? clinicId;
  final String? notes;
  final int version;
  final DateTime lastUpdatedAt;
  final DateTime createdAt;

  const GrowthMeasurementEntity({
    required this.id,
    required this.childId,
    required this.measurementDate,
    required this.ageMonths,
    this.weightKg,
    this.heightCm,
    this.headCircumferenceCm,
    this.muacCm,
    this.weightForAgeZ,
    this.heightForAgeZ,
    this.weightForHeightZ,
    this.bmi,
    this.assessment,
    this.measuredBy,
    this.clinicId,
    this.notes,
    required this.version,
    required this.lastUpdatedAt,
    required this.createdAt,
  });

  /// Check if weight is available
  bool get hasWeight => weightKg != null;

  /// Check if height is available
  bool get hasHeight => heightCm != null;

  /// Check if all measurements are complete
  bool get isComplete {
    return weightKg != null && heightCm != null && headCircumferenceCm != null;
  }

  /// Get growth status color
  String get statusColor {
    if (assessment == null) return 'gray';
    
    switch (assessment!.toLowerCase()) {
      case 'normal':
        return 'green';
      case 'underweight':
      case 'at_risk':
        return 'orange';
      case 'stunted':
      case 'wasted':
      case 'severely_underweight':
        return 'red';
      default:
        return 'gray';
    }
  }

  /// Check if measurement indicates a problem
  bool get hasGrowthConcern {
    if (weightForAgeZ != null && weightForAgeZ! < -2) return true;
    if (heightForAgeZ != null && heightForAgeZ! < -2) return true;
    if (weightForHeightZ != null && weightForHeightZ! < -2) return true;
    if (muacCm != null && muacCm! < 11.5) return true; // Red zone MUAC
    return false;
  }

  /// Get MUAC category
  String? get muacCategory {
    if (muacCm == null) return null;
    
    if (muacCm! < 11.5) return 'Severe Malnutrition (Red)';
    if (muacCm! < 12.5) return 'Moderate Malnutrition (Yellow)';
    return 'Normal (Green)';
  }

  /// Get age display
  String get ageDisplay {
    if (ageMonths < 12) {
      return '$ageMonths months';
    }
    final years = ageMonths ~/ 12;
    final months = ageMonths % 12;
    if (months == 0) {
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
    return '$years yr $months mo';
  }

  /// Get formatted measurement date
  String get formattedDate {
    return '${measurementDate.day}/${measurementDate.month}/${measurementDate.year}';
  }

  GrowthMeasurementEntity copyWith({
    String? id,
    String? childId,
    DateTime? measurementDate,
    int? ageMonths,
    double? weightKg,
    double? heightCm,
    double? headCircumferenceCm,
    double? muacCm,
    double? weightForAgeZ,
    double? heightForAgeZ,
    double? weightForHeightZ,
    double? bmi,
    String? assessment,
    String? measuredBy,
    String? clinicId,
    String? notes,
    int? version,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
  }) {
    return GrowthMeasurementEntity(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      measurementDate: measurementDate ?? this.measurementDate,
      ageMonths: ageMonths ?? this.ageMonths,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      headCircumferenceCm: headCircumferenceCm ?? this.headCircumferenceCm,
      muacCm: muacCm ?? this.muacCm,
      weightForAgeZ: weightForAgeZ ?? this.weightForAgeZ,
      heightForAgeZ: heightForAgeZ ?? this.heightForAgeZ,
      weightForHeightZ: weightForHeightZ ?? this.weightForHeightZ,
      bmi: bmi ?? this.bmi,
      assessment: assessment ?? this.assessment,
      measuredBy: measuredBy ?? this.measuredBy,
      clinicId: clinicId ?? this.clinicId,
      notes: notes ?? this.notes,
      version: version ?? this.version,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        childId,
        measurementDate,
        ageMonths,
        weightKg,
        heightCm,
        headCircumferenceCm,
        muacCm,
        weightForAgeZ,
        heightForAgeZ,
        weightForHeightZ,
        bmi,
        assessment,
        measuredBy,
        clinicId,
        notes,
        version,
        lastUpdatedAt,
        createdAt,
      ];
}