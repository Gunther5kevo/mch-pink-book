/// Clinic Entity (Domain Layer)
/// Represents a health facility/clinic
library;

import 'package:equatable/equatable.dart';

class ClinicEntity extends Equatable {
  final String id;
  final String name;
  final String county;
  final String? subcounty;
  final String? address;
  final String? contact;
  final String? email;
  final String? mflCode; // Master Facility List code
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

  /// Get full address
  String get fullAddress {
    final parts = <String>[];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (subcounty != null && subcounty!.isNotEmpty) parts.add(subcounty!);
    parts.add(county);
    return parts.join(', ');
  }

  /// Get display name with location
  String get displayNameWithLocation => '$name, $county';

  /// Check if clinic has complete information
  bool get hasCompleteInfo {
    return name.isNotEmpty &&
        county.isNotEmpty &&
        contact != null &&
        contact!.isNotEmpty;
  }

  ClinicEntity copyWith({
    String? id,
    String? name,
    String? county,
    String? subcounty,
    String? address,
    String? contact,
    String? email,
    String? mflCode,
    bool? isActive,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClinicEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      county: county ?? this.county,
      subcounty: subcounty ?? this.subcounty,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      mflCode: mflCode ?? this.mflCode,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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