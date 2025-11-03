// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get fullName => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get email => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get phoneE164 => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get nationalId => throw _privateConstructorUsedError;
  @HiveField(5)
  String get role => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get clinicId => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get licenseNumber => throw _privateConstructorUsedError;
  @HiveField(8)
  String get languagePref => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get emergencyContact => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get emergencyName => throw _privateConstructorUsedError;
  @HiveField(11)
  String? get homeClinicId => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get deviceId => throw _privateConstructorUsedError;
  @HiveField(13)
  DateTime? get lastSyncAt => throw _privateConstructorUsedError;
  @HiveField(14)
  bool get consentGiven => throw _privateConstructorUsedError;
  @HiveField(15)
  DateTime? get consentDate => throw _privateConstructorUsedError;
  @HiveField(16)
  bool get emailVerified => throw _privateConstructorUsedError;
  @HiveField(17)
  bool get phoneVerified => throw _privateConstructorUsedError;
  @HiveField(18)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(19)
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  @HiveField(20)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(21)
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String fullName,
      @HiveField(2) String? email,
      @HiveField(3) String? phoneE164,
      @HiveField(4) String? nationalId,
      @HiveField(5) String role,
      @HiveField(6) String? clinicId,
      @HiveField(7) String? licenseNumber,
      @HiveField(8) String languagePref,
      @HiveField(9) String? emergencyContact,
      @HiveField(10) String? emergencyName,
      @HiveField(11) String? homeClinicId,
      @HiveField(12) String? deviceId,
      @HiveField(13) DateTime? lastSyncAt,
      @HiveField(14) bool consentGiven,
      @HiveField(15) DateTime? consentDate,
      @HiveField(16) bool emailVerified,
      @HiveField(17) bool phoneVerified,
      @HiveField(18) bool isActive,
      @HiveField(19) Map<String, dynamic> metadata,
      @HiveField(20) DateTime createdAt,
      @HiveField(21) DateTime updatedAt});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = freezed,
    Object? phoneE164 = freezed,
    Object? nationalId = freezed,
    Object? role = null,
    Object? clinicId = freezed,
    Object? licenseNumber = freezed,
    Object? languagePref = null,
    Object? emergencyContact = freezed,
    Object? emergencyName = freezed,
    Object? homeClinicId = freezed,
    Object? deviceId = freezed,
    Object? lastSyncAt = freezed,
    Object? consentGiven = null,
    Object? consentDate = freezed,
    Object? emailVerified = null,
    Object? phoneVerified = null,
    Object? isActive = null,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneE164: freezed == phoneE164
          ? _value.phoneE164
          : phoneE164 // ignore: cast_nullable_to_non_nullable
              as String?,
      nationalId: freezed == nationalId
          ? _value.nationalId
          : nationalId // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      clinicId: freezed == clinicId
          ? _value.clinicId
          : clinicId // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseNumber: freezed == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      languagePref: null == languagePref
          ? _value.languagePref
          : languagePref // ignore: cast_nullable_to_non_nullable
              as String,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyName: freezed == emergencyName
          ? _value.emergencyName
          : emergencyName // ignore: cast_nullable_to_non_nullable
              as String?,
      homeClinicId: freezed == homeClinicId
          ? _value.homeClinicId
          : homeClinicId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSyncAt: freezed == lastSyncAt
          ? _value.lastSyncAt
          : lastSyncAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      consentGiven: null == consentGiven
          ? _value.consentGiven
          : consentGiven // ignore: cast_nullable_to_non_nullable
              as bool,
      consentDate: freezed == consentDate
          ? _value.consentDate
          : consentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String fullName,
      @HiveField(2) String? email,
      @HiveField(3) String? phoneE164,
      @HiveField(4) String? nationalId,
      @HiveField(5) String role,
      @HiveField(6) String? clinicId,
      @HiveField(7) String? licenseNumber,
      @HiveField(8) String languagePref,
      @HiveField(9) String? emergencyContact,
      @HiveField(10) String? emergencyName,
      @HiveField(11) String? homeClinicId,
      @HiveField(12) String? deviceId,
      @HiveField(13) DateTime? lastSyncAt,
      @HiveField(14) bool consentGiven,
      @HiveField(15) DateTime? consentDate,
      @HiveField(16) bool emailVerified,
      @HiveField(17) bool phoneVerified,
      @HiveField(18) bool isActive,
      @HiveField(19) Map<String, dynamic> metadata,
      @HiveField(20) DateTime createdAt,
      @HiveField(21) DateTime updatedAt});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? email = freezed,
    Object? phoneE164 = freezed,
    Object? nationalId = freezed,
    Object? role = null,
    Object? clinicId = freezed,
    Object? licenseNumber = freezed,
    Object? languagePref = null,
    Object? emergencyContact = freezed,
    Object? emergencyName = freezed,
    Object? homeClinicId = freezed,
    Object? deviceId = freezed,
    Object? lastSyncAt = freezed,
    Object? consentGiven = null,
    Object? consentDate = freezed,
    Object? emailVerified = null,
    Object? phoneVerified = null,
    Object? isActive = null,
    Object? metadata = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneE164: freezed == phoneE164
          ? _value.phoneE164
          : phoneE164 // ignore: cast_nullable_to_non_nullable
              as String?,
      nationalId: freezed == nationalId
          ? _value.nationalId
          : nationalId // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      clinicId: freezed == clinicId
          ? _value.clinicId
          : clinicId // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseNumber: freezed == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      languagePref: null == languagePref
          ? _value.languagePref
          : languagePref // ignore: cast_nullable_to_non_nullable
              as String,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyName: freezed == emergencyName
          ? _value.emergencyName
          : emergencyName // ignore: cast_nullable_to_non_nullable
              as String?,
      homeClinicId: freezed == homeClinicId
          ? _value.homeClinicId
          : homeClinicId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSyncAt: freezed == lastSyncAt
          ? _value.lastSyncAt
          : lastSyncAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      consentGiven: null == consentGiven
          ? _value.consentGiven
          : consentGiven // ignore: cast_nullable_to_non_nullable
              as bool,
      consentDate: freezed == consentDate
          ? _value.consentDate
          : consentDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.fullName,
      @HiveField(2) this.email,
      @HiveField(3) this.phoneE164,
      @HiveField(4) this.nationalId,
      @HiveField(5) required this.role,
      @HiveField(6) this.clinicId,
      @HiveField(7) this.licenseNumber,
      @HiveField(8) required this.languagePref,
      @HiveField(9) this.emergencyContact,
      @HiveField(10) this.emergencyName,
      @HiveField(11) this.homeClinicId,
      @HiveField(12) this.deviceId,
      @HiveField(13) this.lastSyncAt,
      @HiveField(14) required this.consentGiven,
      @HiveField(15) this.consentDate,
      @HiveField(16) this.emailVerified = false,
      @HiveField(17) this.phoneVerified = false,
      @HiveField(18) this.isActive = true,
      @HiveField(19) final Map<String, dynamic> metadata = const {},
      @HiveField(20) required this.createdAt,
      @HiveField(21) required this.updatedAt})
      : _metadata = metadata,
        super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String fullName;
  @override
  @HiveField(2)
  final String? email;
  @override
  @HiveField(3)
  final String? phoneE164;
  @override
  @HiveField(4)
  final String? nationalId;
  @override
  @HiveField(5)
  final String role;
  @override
  @HiveField(6)
  final String? clinicId;
  @override
  @HiveField(7)
  final String? licenseNumber;
  @override
  @HiveField(8)
  final String languagePref;
  @override
  @HiveField(9)
  final String? emergencyContact;
  @override
  @HiveField(10)
  final String? emergencyName;
  @override
  @HiveField(11)
  final String? homeClinicId;
  @override
  @HiveField(12)
  final String? deviceId;
  @override
  @HiveField(13)
  final DateTime? lastSyncAt;
  @override
  @HiveField(14)
  final bool consentGiven;
  @override
  @HiveField(15)
  final DateTime? consentDate;
  @override
  @JsonKey()
  @HiveField(16)
  final bool emailVerified;
  @override
  @JsonKey()
  @HiveField(17)
  final bool phoneVerified;
  @override
  @JsonKey()
  @HiveField(18)
  final bool isActive;
  final Map<String, dynamic> _metadata;
  @override
  @JsonKey()
  @HiveField(19)
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  @HiveField(20)
  final DateTime createdAt;
  @override
  @HiveField(21)
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, email: $email, phoneE164: $phoneE164, nationalId: $nationalId, role: $role, clinicId: $clinicId, licenseNumber: $licenseNumber, languagePref: $languagePref, emergencyContact: $emergencyContact, emergencyName: $emergencyName, homeClinicId: $homeClinicId, deviceId: $deviceId, lastSyncAt: $lastSyncAt, consentGiven: $consentGiven, consentDate: $consentDate, emailVerified: $emailVerified, phoneVerified: $phoneVerified, isActive: $isActive, metadata: $metadata, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneE164, phoneE164) ||
                other.phoneE164 == phoneE164) &&
            (identical(other.nationalId, nationalId) ||
                other.nationalId == nationalId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.clinicId, clinicId) ||
                other.clinicId == clinicId) &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.languagePref, languagePref) ||
                other.languagePref == languagePref) &&
            (identical(other.emergencyContact, emergencyContact) ||
                other.emergencyContact == emergencyContact) &&
            (identical(other.emergencyName, emergencyName) ||
                other.emergencyName == emergencyName) &&
            (identical(other.homeClinicId, homeClinicId) ||
                other.homeClinicId == homeClinicId) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.lastSyncAt, lastSyncAt) ||
                other.lastSyncAt == lastSyncAt) &&
            (identical(other.consentGiven, consentGiven) ||
                other.consentGiven == consentGiven) &&
            (identical(other.consentDate, consentDate) ||
                other.consentDate == consentDate) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.phoneVerified, phoneVerified) ||
                other.phoneVerified == phoneVerified) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        fullName,
        email,
        phoneE164,
        nationalId,
        role,
        clinicId,
        licenseNumber,
        languagePref,
        emergencyContact,
        emergencyName,
        homeClinicId,
        deviceId,
        lastSyncAt,
        consentGiven,
        consentDate,
        emailVerified,
        phoneVerified,
        isActive,
        const DeepCollectionEquality().hash(_metadata),
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String fullName,
      @HiveField(2) final String? email,
      @HiveField(3) final String? phoneE164,
      @HiveField(4) final String? nationalId,
      @HiveField(5) required final String role,
      @HiveField(6) final String? clinicId,
      @HiveField(7) final String? licenseNumber,
      @HiveField(8) required final String languagePref,
      @HiveField(9) final String? emergencyContact,
      @HiveField(10) final String? emergencyName,
      @HiveField(11) final String? homeClinicId,
      @HiveField(12) final String? deviceId,
      @HiveField(13) final DateTime? lastSyncAt,
      @HiveField(14) required final bool consentGiven,
      @HiveField(15) final DateTime? consentDate,
      @HiveField(16) final bool emailVerified,
      @HiveField(17) final bool phoneVerified,
      @HiveField(18) final bool isActive,
      @HiveField(19) final Map<String, dynamic> metadata,
      @HiveField(20) required final DateTime createdAt,
      @HiveField(21) required final DateTime updatedAt}) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get fullName;
  @override
  @HiveField(2)
  String? get email;
  @override
  @HiveField(3)
  String? get phoneE164;
  @override
  @HiveField(4)
  String? get nationalId;
  @override
  @HiveField(5)
  String get role;
  @override
  @HiveField(6)
  String? get clinicId;
  @override
  @HiveField(7)
  String? get licenseNumber;
  @override
  @HiveField(8)
  String get languagePref;
  @override
  @HiveField(9)
  String? get emergencyContact;
  @override
  @HiveField(10)
  String? get emergencyName;
  @override
  @HiveField(11)
  String? get homeClinicId;
  @override
  @HiveField(12)
  String? get deviceId;
  @override
  @HiveField(13)
  DateTime? get lastSyncAt;
  @override
  @HiveField(14)
  bool get consentGiven;
  @override
  @HiveField(15)
  DateTime? get consentDate;
  @override
  @HiveField(16)
  bool get emailVerified;
  @override
  @HiveField(17)
  bool get phoneVerified;
  @override
  @HiveField(18)
  bool get isActive;
  @override
  @HiveField(19)
  Map<String, dynamic> get metadata;
  @override
  @HiveField(20)
  DateTime get createdAt;
  @override
  @HiveField(21)
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
