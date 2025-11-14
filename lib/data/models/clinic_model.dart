// ============================================================================
// lib/data/models/clinic_model.dart
// ============================================================================
import '../../domain/entities/clinic_entity.dart';

class ClinicModel extends ClinicEntity {
  const ClinicModel({
    required super.id,
    required super.name,
    required super.county,
    super.subcounty,
    super.subCounty,
    super.address,
    super.contact,
    super.email,
    super.mflCode,
    required super.isActive,
    required super.metadata,
    required super.createdAt,
    required super.updatedAt,
    super.facilityType,
    super.operationStatus,
    super.countyCode,
    super.source,
    super.verified,
    super.lastSyncedAt,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] as String,
      name: json['name'] as String,
      county: json['county'] as String,
      subcounty: json['subcounty'] as String?,
      subCounty: json['sub_county'] as String?,
      address: json['address'] as String?,
      contact: json['contact'] as String?,
      email: json['email'] as String?,
      mflCode: json['mfl_code'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      metadata: (json['metadata'] as Map?)?.cast<String, dynamic>() ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      facilityType: json['facility_type'] as String?,
      operationStatus: json['operation_status'] as String? ?? 'Operational',
      countyCode: json['county_code'] as String?,
      source: json['source'] as String? ?? 'KMHFL',
      verified: json['verified'] as bool? ?? true,
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
    );
  }

  factory ClinicModel.fromEntity(ClinicEntity entity) {
    return ClinicModel(
      id: entity.id,
      name: entity.name,
      county: entity.county,
      subcounty: entity.subcounty,
      subCounty: entity.subCounty,
      address: entity.address,
      contact: entity.contact,
      email: entity.email,
      mflCode: entity.mflCode,
      isActive: entity.isActive,
      metadata: entity.metadata,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      facilityType: entity.facilityType,
      operationStatus: entity.operationStatus,
      countyCode: entity.countyCode,
      source: entity.source,
      verified: entity.verified,
      lastSyncedAt: entity.lastSyncedAt,
    );
  }

  ClinicModel copyWith({
    String? id,
    String? name,
    String? county,
    String? subcounty,
    String? subCounty,
    String? address,
    String? contact,
    String? email,
    String? mflCode,
    bool? isActive,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? facilityType,
    String? operationStatus,
    String? countyCode,
    String? source,
    bool? verified,
    DateTime? lastSyncedAt,
  }) {
    return ClinicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      county: county ?? this.county,
      subcounty: subcounty ?? this.subcounty,
      subCounty: subCounty ?? this.subCounty,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      mflCode: mflCode ?? this.mflCode,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      facilityType: facilityType ?? this.facilityType,
      operationStatus: operationStatus ?? this.operationStatus,
      countyCode: countyCode ?? this.countyCode,
      source: source ?? this.source,
      verified: verified ?? this.verified,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}
