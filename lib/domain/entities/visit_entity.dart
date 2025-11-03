/// Visit Entity (Domain Layer)
/// Represents a clinical visit
library;

import 'package:equatable/equatable.dart';
import '../../core/constants/app_constants.dart';

class VisitEntity extends Equatable {
  final String id;
  final String subjectId; // mother_id or child_id
  final String subjectType; // 'mother' or 'child'
  final String? pregnancyId;
  final VisitType type;
  final int? visitNumber;
  final DateTime visitDate;
  final int? gestationWeeks; // for ANC visits
  final String providerId;
  final String clinicId;
  final Map<String, dynamic> vitals; // BP, weight, temp, pulse, etc
  final Map<String, dynamic> labResults; // hemoglobin, urine tests, etc
  final Map<String, dynamic> examination; // physical exam findings
  final List<Map<String, dynamic>> prescriptions;
  final List<Map<String, dynamic>> referrals;
  final DateTime? nextVisitDate;
  final String? advice;
  final String? notes;
  final int version;
  final DateTime lastUpdatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const VisitEntity({
    required this.id,
    required this.subjectId,
    required this.subjectType,
    this.pregnancyId,
    required this.type,
    this.visitNumber,
    required this.visitDate,
    this.gestationWeeks,
    required this.providerId,
    required this.clinicId,
    required this.vitals,
    required this.labResults,
    required this.examination,
    required this.prescriptions,
    required this.referrals,
    this.nextVisitDate,
    this.advice,
    this.notes,
    required this.version,
    required this.lastUpdatedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if visit is for a mother
  bool get isMother => subjectType == 'mother';

  /// Check if visit is for a child
  bool get isChild => subjectType == 'child';

  /// Check if this is an ANC visit
  bool get isANCVisit => type == VisitType.anc;

  /// Check if referral was given
  bool get hasReferrals => referrals.isNotEmpty;

  /// Check if prescriptions were given
  bool get hasPrescriptions => prescriptions.isNotEmpty;

  /// Get blood pressure reading
  String? get bloodPressure {
    if (vitals.containsKey('bp_systolic') && vitals.containsKey('bp_diastolic')) {
      return '${vitals['bp_systolic']}/${vitals['bp_diastolic']}';
    }
    return null;
  }

  /// Get weight reading
  double? get weight {
    if (vitals.containsKey('weight')) {
      return (vitals['weight'] as num).toDouble();
    }
    return null;
  }

  /// Get temperature reading
  double? get temperature {
    if (vitals.containsKey('temp')) {
      return (vitals['temp'] as num).toDouble();
    }
    return null;
  }

  /// Get formatted visit date
  String get formattedDate {
    return '${visitDate.day}/${visitDate.month}/${visitDate.year}';
  }

  VisitEntity copyWith({
    String? id,
    String? subjectId,
    String? subjectType,
    String? pregnancyId,
    VisitType? type,
    int? visitNumber,
    DateTime? visitDate,
    int? gestationWeeks,
    String? providerId,
    String? clinicId,
    Map<String, dynamic>? vitals,
    Map<String, dynamic>? labResults,
    Map<String, dynamic>? examination,
    List<Map<String, dynamic>>? prescriptions,
    List<Map<String, dynamic>>? referrals,
    DateTime? nextVisitDate,
    String? advice,
    String? notes,
    int? version,
    DateTime? lastUpdatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VisitEntity(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      subjectType: subjectType ?? this.subjectType,
      pregnancyId: pregnancyId ?? this.pregnancyId,
      type: type ?? this.type,
      visitNumber: visitNumber ?? this.visitNumber,
      visitDate: visitDate ?? this.visitDate,
      gestationWeeks: gestationWeeks ?? this.gestationWeeks,
      providerId: providerId ?? this.providerId,
      clinicId: clinicId ?? this.clinicId,
      vitals: vitals ?? this.vitals,
      labResults: labResults ?? this.labResults,
      examination: examination ?? this.examination,
      prescriptions: prescriptions ?? this.prescriptions,
      referrals: referrals ?? this.referrals,
      nextVisitDate: nextVisitDate ?? this.nextVisitDate,
      advice: advice ?? this.advice,
      notes: notes ?? this.notes,
      version: version ?? this.version,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        subjectId,
        subjectType,
        pregnancyId,
        type,
        visitNumber,
        visitDate,
        gestationWeeks,
        providerId,
        clinicId,
        vitals,
        labResults,
        examination,
        prescriptions,
        referrals,
        nextVisitDate,
        advice,
        notes,
        version,
        lastUpdatedAt,
        createdAt,
        updatedAt,
      ];
}