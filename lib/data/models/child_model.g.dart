// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChildModelAdapter extends TypeAdapter<ChildModel> {
  @override
  final int typeId = 1;

  @override
  ChildModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChildModel(
      id: fields[0] as String,
      motherId: fields[1] as String,
      pregnancyId: fields[2] as String?,
      name: fields[3] as String,
      dateOfBirth: fields[4] as DateTime,
      gender: fields[5] as String,
      birthWeight: fields[6] as double?,
      birthLength: fields[7] as double?,
      headCircumference: fields[8] as double?,
      birthPlace: fields[9] as String?,
      birthCertificateNo: fields[10] as String?,
      apgarScore: (fields[11] as Map?)?.cast<String, dynamic>(),
      birthComplications: fields[12] as String?,
      uniqueQrCode: fields[13] as String,
      photoUrl: fields[14] as String?,
      isActive: fields[15] as bool,
      version: fields[16] as int,
      lastUpdatedAt: fields[17] as DateTime,
      createdAt: fields[18] as DateTime,
      updatedAt: fields[19] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ChildModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.motherId)
      ..writeByte(2)
      ..write(obj.pregnancyId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.dateOfBirth)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.birthWeight)
      ..writeByte(7)
      ..write(obj.birthLength)
      ..writeByte(8)
      ..write(obj.headCircumference)
      ..writeByte(9)
      ..write(obj.birthPlace)
      ..writeByte(10)
      ..write(obj.birthCertificateNo)
      ..writeByte(11)
      ..write(obj.apgarScore)
      ..writeByte(12)
      ..write(obj.birthComplications)
      ..writeByte(13)
      ..write(obj.uniqueQrCode)
      ..writeByte(14)
      ..write(obj.photoUrl)
      ..writeByte(15)
      ..write(obj.isActive)
      ..writeByte(16)
      ..write(obj.version)
      ..writeByte(17)
      ..write(obj.lastUpdatedAt)
      ..writeByte(18)
      ..write(obj.createdAt)
      ..writeByte(19)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChildModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChildModelImpl _$$ChildModelImplFromJson(Map<String, dynamic> json) =>
    _$ChildModelImpl(
      id: json['id'] as String,
      motherId: json['motherId'] as String,
      pregnancyId: json['pregnancyId'] as String?,
      name: json['name'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      gender: json['gender'] as String,
      birthWeight: (json['birthWeight'] as num?)?.toDouble(),
      birthLength: (json['birthLength'] as num?)?.toDouble(),
      headCircumference: (json['headCircumference'] as num?)?.toDouble(),
      birthPlace: json['birthPlace'] as String?,
      birthCertificateNo: json['birthCertificateNo'] as String?,
      apgarScore: json['apgarScore'] as Map<String, dynamic>?,
      birthComplications: json['birthComplications'] as String?,
      uniqueQrCode: json['uniqueQrCode'] as String,
      photoUrl: json['photoUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      version: (json['version'] as num?)?.toInt() ?? 1,
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChildModelImplToJson(_$ChildModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'motherId': instance.motherId,
      'pregnancyId': instance.pregnancyId,
      'name': instance.name,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'gender': instance.gender,
      'birthWeight': instance.birthWeight,
      'birthLength': instance.birthLength,
      'headCircumference': instance.headCircumference,
      'birthPlace': instance.birthPlace,
      'birthCertificateNo': instance.birthCertificateNo,
      'apgarScore': instance.apgarScore,
      'birthComplications': instance.birthComplications,
      'uniqueQrCode': instance.uniqueQrCode,
      'photoUrl': instance.photoUrl,
      'isActive': instance.isActive,
      'version': instance.version,
      'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
