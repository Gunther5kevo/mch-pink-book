/// Child Model
/// Represents a child in the system
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/child_entity.dart';

part 'child_model.freezed.dart';
part 'child_model.g.dart';

@freezed
@HiveType(typeId: 1)
class ChildModel with _$ChildModel {
  const factory ChildModel({
    @HiveField(0) required String id,
    @HiveField(1) required String motherId,
    @HiveField(2) String? pregnancyId,
    @HiveField(3) required String name,
    @HiveField(4) required DateTime dateOfBirth,
    @HiveField(5) required String gender, // male, female, other
    @HiveField(6) double? birthWeight,
    @HiveField(7) double? birthLength,
    @HiveField(8) double? headCircumference,
    @HiveField(9) String? birthPlace,
    @HiveField(10) String? birthCertificateNo,
    @HiveField(11) Map<String, dynamic>? apgarScore,
    @HiveField(12) String? birthComplications,
    @HiveField(13) required String uniqueQrCode,
    @HiveField(14) String? photoUrl,
    @HiveField(15) @Default(true) bool isActive,
    @HiveField(16) @Default(1) int version,
    @HiveField(17) required DateTime lastUpdatedAt,
    @HiveField(18) required DateTime createdAt,
    @HiveField(19) required DateTime updatedAt,
  }) = _ChildModel;

  const ChildModel._();

  factory ChildModel.fromJson(Map<String, dynamic> json) =>
      _$ChildModelFromJson(json);

  /// Convert to Entity
  ChildEntity toEntity() {
    return ChildEntity(
      id: id,
      motherId: motherId,
      pregnancyId: pregnancyId,
      name: name,
      dateOfBirth: dateOfBirth,
      gender: gender,
      birthWeight: birthWeight,
      birthLength: birthLength,
      headCircumference: headCircumference,
      birthPlace: birthPlace,
      birthCertificateNo: birthCertificateNo,
      apgarScore: apgarScore,
      birthComplications: birthComplications,
      uniqueQrCode: uniqueQrCode,
      photoUrl: photoUrl,
      isActive: isActive,
      version: version,
      lastUpdatedAt: lastUpdatedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create from Entity
  factory ChildModel.fromEntity(ChildEntity entity) {
    return ChildModel(
      id: entity.id,
      motherId: entity.motherId,
      pregnancyId: entity.pregnancyId,
      name: entity.name,
      dateOfBirth: entity.dateOfBirth,
      gender: entity.gender,
      birthWeight: entity.birthWeight,
      birthLength: entity.birthLength,
      headCircumference: entity.headCircumference,
      birthPlace: entity.birthPlace,
      birthCertificateNo: entity.birthCertificateNo,
      apgarScore: entity.apgarScore,
      birthComplications: entity.birthComplications,
      uniqueQrCode: entity.uniqueQrCode,
      photoUrl: entity.photoUrl,
      isActive: entity.isActive,
      version: entity.version,
      lastUpdatedAt: entity.lastUpdatedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}