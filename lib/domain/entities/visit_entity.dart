import 'package:mch_pink_book/core/constants/app_constants.dart' show VisitType;

class VisitEntity {
  final String id;
  final String subjectId;
  final String subjectType;
  final String? pregnancyId;
  final VisitType type;
  final int? visitNumber;
  final DateTime visitDate;
  final int? gestationWeeks;
  final String providerId;
  final String clinicId;
  final Map<String, dynamic> vitals;
  final Map<String, dynamic> labResults;
  final Map<String, dynamic> examination;
  final List<Map<String, dynamic>> prescriptions;
  final List<Map<String, dynamic>> referrals;
  final DateTime? nextVisitDate;
  final String? advice;
  final String? notes;
  final int version;
  final DateTime? lastUpdatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  VisitEntity({
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
    this.vitals = const {},
    this.labResults = const {},
    this.examination = const {},
    this.prescriptions = const [],
    this.referrals = const [],
    this.nextVisitDate,
    this.advice,
    this.notes,
    required this.version,
    this.lastUpdatedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VisitEntity.fromJson(Map<String, dynamic> json) {
    return VisitEntity(
      id: json['id'] as String,
      subjectId: json['subject_id'] as String,
      subjectType: json['subject_type'] as String,
      pregnancyId: json['pregnancy_id'] as String?,
      type: VisitType.fromString(json['type'] as String),
      visitNumber: json['visit_number'] as int?,
      visitDate: DateTime.parse(json['visit_date'] as String),
      gestationWeeks: json['gestation_weeks'] as int?,
      providerId: json['provider_id'] as String,
      clinicId: json['clinic_id'] as String,
      vitals: Map<String, dynamic>.from(json['vitals'] ?? {}),
      labResults: Map<String, dynamic>.from(json['lab_results'] ?? {}),
      examination: Map<String, dynamic>.from(json['examination'] ?? {}),
      prescriptions: List<Map<String, dynamic>>.from(json['prescriptions'] ?? []),
      referrals: List<Map<String, dynamic>>.from(json['referrals'] ?? []),
      nextVisitDate: json['next_visit_date'] != null
          ? DateTime.parse(json['next_visit_date'] as String)
          : null,
      advice: json['advice'] as String?,
      notes: json['notes'] as String?,
      version: (json['version'] as int?) ?? 1,
      lastUpdatedAt: json['last_updated_at'] != null
          ? DateTime.parse(json['last_updated_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_id': subjectId,
      'subject_type': subjectType,
      'pregnancy_id': pregnancyId,
      'type': type.dbValue,
      'visit_number': visitNumber,
      'visit_date': visitDate.toIso8601String(),
      'gestation_weeks': gestationWeeks,
      'provider_id': providerId,
      'clinic_id': clinicId,
      'vitals': vitals,
      'lab_results': labResults,
      'examination': examination,
      'prescriptions': prescriptions,
      'referrals': referrals,
      'next_visit_date': nextVisitDate?.toIso8601String(),
      'advice': advice,
      'notes': notes,
      'version': version,
      'last_updated_at': lastUpdatedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
