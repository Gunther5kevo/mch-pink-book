// lib/domain/entities/clinic_entity.dart
// ============================================================================
import 'package:equatable/equatable.dart';

class ClinicEntity extends Equatable {
  final String id;
  final String name;
  final String county;
  final String? subcounty;
  final String? subCounty; // Alternative field name from schema
  final String? address;
  final String? contact;
  final String? email;
  final String? mflCode;
  final bool isActive;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? facilityType;
  final String operationStatus;
  final String? countyCode;
  final String source;
  final bool verified;
  final DateTime? lastSyncedAt;

  const ClinicEntity({
    required this.id,
    required this.name,
    required this.county,
    this.subcounty,
    this.subCounty,
    this.address,
    this.contact,
    this.email,
    this.mflCode,
    required this.isActive,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.facilityType,
    this.operationStatus = 'Operational',
    this.countyCode,
    this.source = 'KMHFL',
    this.verified = true,
    this.lastSyncedAt,
  });

  factory ClinicEntity.fromJson(Map<String, dynamic> json) {
    return ClinicEntity(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'county': county,
      'subcounty': subcounty,
      'sub_county': subCounty,
      'address': address,
      'contact': contact,
      'email': email,
      'mfl_code': mflCode,
      'is_active': isActive,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'facility_type': facilityType,
      'operation_status': operationStatus,
      'county_code': countyCode,
      'source': source,
      'verified': verified,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
    };
  }

  /// Display name with MFL code
  String get displayName => mflCode != null ? '$name (MFL: $mflCode)' : name;

  /// Short display format
  String get shortDisplay => mflCode != null ? '$name - $mflCode' : name;

  /// Location display
  String get locationDisplay {
    final parts = <String>[
      if (subCounty != null && subCounty!.isNotEmpty) subCounty!,
      county,
    ];
    return parts.join(', ');
  }

  /// Check if facility is operational
  bool get isOperational => 
      isActive && operationStatus.toLowerCase() == 'operational';

  /// Get subcounty (handles both field names)
  String? get effectiveSubCounty => subCounty ?? subcounty;

  @override
  List<Object?> get props => [
        id,
        name,
        county,
        subcounty,
        subCounty,
        address,
        contact,
        email,
        mflCode,
        isActive,
        metadata,
        createdAt,
        updatedAt,
        facilityType,
        operationStatus,
        countyCode,
        source,
        verified,
        lastSyncedAt,
      ];
}