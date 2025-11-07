// lib/domain/entities/clinic_entity.dart
import 'package:equatable/equatable.dart';

class ClinicEntity extends Equatable {
  final String id;
  final String name;
  final String county;
  final String? subcounty;
  final String? address;
  final String? contact;
  final String? email;
  final String? mflCode;
  final bool isActive;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ClinicEntity({
    required this.id,
    required this.name,
    required this.county,
    this.subcounty,
    this.address,
    this.contact,
    this.email,
    this.mflCode,
    required this.isActive,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClinicEntity.fromJson(Map<String, dynamic> json) {
    return ClinicEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      county: json['county'] as String,
      subcounty: json['subcounty'] as String?,
      address: json['address'] as String?,
      contact: json['contact'] as String?,
      email: json['email'] as String?,
      mflCode: json['mfl_code'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      metadata: (json['metadata'] as Map?)?.cast<String, dynamic>() ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        county,
        subcounty,
        address,
        contact,
        email,
        mflCode,
        isActive,
        metadata,
        createdAt,
        updatedAt,
      ];
}