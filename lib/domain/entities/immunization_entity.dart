/// Immunization Entity (Domain Layer)
/// Represents a vaccine administration record
library;

import 'package:equatable/equatable.dart';

class ImmunizationEntity extends Equatable {
  final String id;
  final String childId;
  final String vaccineCode; // BCG, OPV1, DTP1, etc
  final String vaccineName;
  final DateTime? scheduledDate;
  final DateTime administeredDate;
  final int? ageAtAdministration; // in months
  final String? batchNumber;
  final String? manufacturer;
  final int? doseNumber;
  final String? site; // left_arm, right_thigh, etc
  final String? administeredBy;
  final String? clinicId;
  final String? adverseEvents;
  final String? notes;
  final int version;
  final DateTime lastUpdatedAt;
  final DateTime createdAt;

  const ImmunizationEntity({
    required this.id,
    required this.childId,
    required this.vaccineCode,
    required this.vaccineName,
    this.scheduledDate,
    required this.administeredDate,
    this.ageAtAdministration,
    this.batchNumber,
    this.manufacturer,
    this.doseNumber,
    this.site,
    this.administeredBy,
    this.clinicId,
    this.adverseEvents,
    this.notes,
    required this.version,
    required this.lastUpdatedAt,
    required this.createdAt,
  });

  /// Check if vaccine was given on time
  bool get isOnTime {
    if (scheduledDate == null) return true;
    final daysDifference = administeredDate.difference(scheduledDate!).inDays;
    return daysDifference.abs() <= 7; // Within 7 days is considered on time
  }

  /// Check if vaccine was delayed
  bool get isDelayed {
    if (scheduledDate == null) return false;
    return administeredDate.isAfter(scheduledDate!.add(const Duration(days: 7)));
  }

  /// Check if vaccine was given early
  bool get isEarly {
    if (scheduledDate == null) return false;
    return administeredDate.isBefore(scheduledDate!.subtract(const Duration(days: 7)));
  }

  /// Check if there were adverse events
  bool get hadAdverseEvents {
    return adverseEvents != null && adverseEvents!.isNotEmpty;
  }

  /// Get vaccine status badge text
  String get statusBadge {
    if (isOnTime) return 'On Time';
    if (isDelayed) return 'Delayed';
    if (isEarly) return 'Early';
    return 'Given';
  }

  /// Get formatted administered date
  String get formattedDate {
    return '${administeredDate.day}/${administeredDate.month}/${administeredDate.year}';
  }

  /// Get vaccine display name with dose number
  String get displayName {
    if (doseNumber != null) {
      return '$vaccineName (Dose $doseNumber)';
    }
    return vaccineName;
  }

  ImmunizationEntity copyWith({
    String? id,
    String? childId,
    String? vaccineCode,
    String? vaccineName,
    DateTime? scheduledDate,
    DateTime? administeredDate,
    int? ageAtAdministration,
    String? batchNumber,
    String? manufacturer,
    int? doseNumber,
    String? site,
    String? administeredBy,
    String? clinicId,
    String? adverseEvents,
    String? notes,
    int? version,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
  }) {
    return ImmunizationEntity(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      vaccineCode: vaccineCode ?? this.vaccineCode,
      vaccineName: vaccineName ?? this.vaccineName,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      administeredDate: administeredDate ?? this.administeredDate,
      ageAtAdministration: ageAtAdministration ?? this.ageAtAdministration,
      batchNumber: batchNumber ?? this.batchNumber,
      manufacturer: manufacturer ?? this.manufacturer,
      doseNumber: doseNumber ?? this.doseNumber,
      site: site ?? this.site,
      administeredBy: administeredBy ?? this.administeredBy,
      clinicId: clinicId ?? this.clinicId,
      adverseEvents: adverseEvents ?? this.adverseEvents,
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
        vaccineCode,
        vaccineName,
        scheduledDate,
        administeredDate,
        ageAtAdministration,
        batchNumber,
        manufacturer,
        doseNumber,
        site,
        administeredBy,
        clinicId,
        adverseEvents,
        notes,
        version,
        lastUpdatedAt,
        createdAt,
      ];
}