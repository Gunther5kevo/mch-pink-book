// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      fullName: fields[1] as String,
      email: fields[2] as String?,
      phoneE164: fields[3] as String?,
      nationalId: fields[4] as String?,
      role: fields[5] as String,
      clinicId: fields[6] as String?,
      licenseNumber: fields[7] as String?,
      languagePref: fields[8] as String,
      emergencyContact: fields[9] as String?,
      emergencyName: fields[10] as String?,
      homeClinicId: fields[11] as String?,
      deviceId: fields[12] as String?,
      lastSyncAt: fields[13] as DateTime?,
      consentGiven: fields[14] as bool,
      consentDate: fields[15] as DateTime?,
      emailVerified: fields[16] as bool,
      phoneVerified: fields[17] as bool,
      isActive: fields[18] as bool,
      metadata: (fields[19] as Map).cast<String, dynamic>(),
      createdAt: fields[20] as DateTime,
      updatedAt: fields[21] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phoneE164)
      ..writeByte(4)
      ..write(obj.nationalId)
      ..writeByte(5)
      ..write(obj.role)
      ..writeByte(6)
      ..write(obj.clinicId)
      ..writeByte(7)
      ..write(obj.licenseNumber)
      ..writeByte(8)
      ..write(obj.languagePref)
      ..writeByte(9)
      ..write(obj.emergencyContact)
      ..writeByte(10)
      ..write(obj.emergencyName)
      ..writeByte(11)
      ..write(obj.homeClinicId)
      ..writeByte(12)
      ..write(obj.deviceId)
      ..writeByte(13)
      ..write(obj.lastSyncAt)
      ..writeByte(14)
      ..write(obj.consentGiven)
      ..writeByte(15)
      ..write(obj.consentDate)
      ..writeByte(16)
      ..write(obj.emailVerified)
      ..writeByte(17)
      ..write(obj.phoneVerified)
      ..writeByte(18)
      ..write(obj.isActive)
      ..writeByte(19)
      ..write(obj.metadata)
      ..writeByte(20)
      ..write(obj.createdAt)
      ..writeByte(21)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      phoneE164: json['phoneE164'] as String?,
      nationalId: json['nationalId'] as String?,
      role: json['role'] as String,
      clinicId: json['clinicId'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
      languagePref: json['languagePref'] as String,
      emergencyContact: json['emergencyContact'] as String?,
      emergencyName: json['emergencyName'] as String?,
      homeClinicId: json['homeClinicId'] as String?,
      deviceId: json['deviceId'] as String?,
      lastSyncAt: json['lastSyncAt'] == null
          ? null
          : DateTime.parse(json['lastSyncAt'] as String),
      consentGiven: json['consentGiven'] as bool,
      consentDate: json['consentDate'] == null
          ? null
          : DateTime.parse(json['consentDate'] as String),
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneE164': instance.phoneE164,
      'nationalId': instance.nationalId,
      'role': instance.role,
      'clinicId': instance.clinicId,
      'licenseNumber': instance.licenseNumber,
      'languagePref': instance.languagePref,
      'emergencyContact': instance.emergencyContact,
      'emergencyName': instance.emergencyName,
      'homeClinicId': instance.homeClinicId,
      'deviceId': instance.deviceId,
      'lastSyncAt': instance.lastSyncAt?.toIso8601String(),
      'consentGiven': instance.consentGiven,
      'consentDate': instance.consentDate?.toIso8601String(),
      'emailVerified': instance.emailVerified,
      'phoneVerified': instance.phoneVerified,
      'isActive': instance.isActive,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
