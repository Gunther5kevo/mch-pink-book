// lib/core/entities/immunization_entity.dart
class ImmunizationEntity {
  final String id;
  final String childId;
  final String vaccineCode;
  final String vaccineName;
  final DateTime? scheduledDate;
  final DateTime administeredDate;
  final int? ageAtAdministration; // in days
  final String? batchNumber;
  final String? manufacturer;
  final int? doseNumber;
  final String? site;
  final String? administeredBy;
  final String? clinicId;
  final String? adverseEvents;
  final String? notes;
  final int version;
  final DateTime lastUpdatedAt;
  final DateTime createdAt;

  ImmunizationEntity({
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

  factory ImmunizationEntity.fromJson(Map<String, dynamic> json) {
    return ImmunizationEntity(
      id: json['id'] as String,
      childId: json['child_id'] as String,
      vaccineCode: json['vaccine_code'] as String,
      vaccineName: json['vaccine_name'] as String,
      scheduledDate: json['scheduled_date'] != null
          ? DateTime.parse(json['scheduled_date'])
          : null,
      administeredDate: DateTime.parse(json['administered_date']),
      ageAtAdministration: json['age_at_administration'] as int?,
      batchNumber: json['batch_number'] as String?,
      manufacturer: json['manufacturer'] as String?,
      doseNumber: json['dose_number'] as int?,
      site: json['site'] as String?,
      administeredBy: json['administered_by'] as String?,
      clinicId: json['clinic_id'] as String?,
      adverseEvents: json['adverse_events'] as String?,
      notes: json['notes'] as String?,
      version: json['version'] as int? ?? 1,
      lastUpdatedAt: DateTime.parse(json['last_updated_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'child_id': childId,
      'vaccine_code': vaccineCode,
      'vaccine_name': vaccineName,
      'scheduled_date': scheduledDate?.toIso8601String().split('T').first,
      'administered_date': administeredDate.toIso8601String().split('T').first,
      'age_at_administration': ageAtAdministration,
      'batch_number': batchNumber,
      'manufacturer': manufacturer,
      'dose_number': doseNumber,
      'site': site,
      'administered_by': administeredBy,
      'clinic_id': clinicId,
      'adverse_events': adverseEvents,
      'notes': notes,
      'version': version,
    };
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
}