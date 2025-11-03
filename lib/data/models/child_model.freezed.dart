// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChildModel _$ChildModelFromJson(Map<String, dynamic> json) {
  return _ChildModel.fromJson(json);
}

/// @nodoc
mixin _$ChildModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get motherId => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get pregnancyId => throw _privateConstructorUsedError;
  @HiveField(3)
  String get name => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get dateOfBirth => throw _privateConstructorUsedError;
  @HiveField(5)
  String get gender =>
      throw _privateConstructorUsedError; // male, female, other
  @HiveField(6)
  double? get birthWeight => throw _privateConstructorUsedError;
  @HiveField(7)
  double? get birthLength => throw _privateConstructorUsedError;
  @HiveField(8)
  double? get headCircumference => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get birthPlace => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get birthCertificateNo => throw _privateConstructorUsedError;
  @HiveField(11)
  Map<String, dynamic>? get apgarScore => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get birthComplications => throw _privateConstructorUsedError;
  @HiveField(13)
  String get uniqueQrCode => throw _privateConstructorUsedError;
  @HiveField(14)
  String? get photoUrl => throw _privateConstructorUsedError;
  @HiveField(15)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(16)
  int get version => throw _privateConstructorUsedError;
  @HiveField(17)
  DateTime get lastUpdatedAt => throw _privateConstructorUsedError;
  @HiveField(18)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(19)
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChildModelCopyWith<ChildModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildModelCopyWith<$Res> {
  factory $ChildModelCopyWith(
          ChildModel value, $Res Function(ChildModel) then) =
      _$ChildModelCopyWithImpl<$Res, ChildModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String motherId,
      @HiveField(2) String? pregnancyId,
      @HiveField(3) String name,
      @HiveField(4) DateTime dateOfBirth,
      @HiveField(5) String gender,
      @HiveField(6) double? birthWeight,
      @HiveField(7) double? birthLength,
      @HiveField(8) double? headCircumference,
      @HiveField(9) String? birthPlace,
      @HiveField(10) String? birthCertificateNo,
      @HiveField(11) Map<String, dynamic>? apgarScore,
      @HiveField(12) String? birthComplications,
      @HiveField(13) String uniqueQrCode,
      @HiveField(14) String? photoUrl,
      @HiveField(15) bool isActive,
      @HiveField(16) int version,
      @HiveField(17) DateTime lastUpdatedAt,
      @HiveField(18) DateTime createdAt,
      @HiveField(19) DateTime updatedAt});
}

/// @nodoc
class _$ChildModelCopyWithImpl<$Res, $Val extends ChildModel>
    implements $ChildModelCopyWith<$Res> {
  _$ChildModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? motherId = null,
    Object? pregnancyId = freezed,
    Object? name = null,
    Object? dateOfBirth = null,
    Object? gender = null,
    Object? birthWeight = freezed,
    Object? birthLength = freezed,
    Object? headCircumference = freezed,
    Object? birthPlace = freezed,
    Object? birthCertificateNo = freezed,
    Object? apgarScore = freezed,
    Object? birthComplications = freezed,
    Object? uniqueQrCode = null,
    Object? photoUrl = freezed,
    Object? isActive = null,
    Object? version = null,
    Object? lastUpdatedAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      motherId: null == motherId
          ? _value.motherId
          : motherId // ignore: cast_nullable_to_non_nullable
              as String,
      pregnancyId: freezed == pregnancyId
          ? _value.pregnancyId
          : pregnancyId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      birthWeight: freezed == birthWeight
          ? _value.birthWeight
          : birthWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      birthLength: freezed == birthLength
          ? _value.birthLength
          : birthLength // ignore: cast_nullable_to_non_nullable
              as double?,
      headCircumference: freezed == headCircumference
          ? _value.headCircumference
          : headCircumference // ignore: cast_nullable_to_non_nullable
              as double?,
      birthPlace: freezed == birthPlace
          ? _value.birthPlace
          : birthPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      birthCertificateNo: freezed == birthCertificateNo
          ? _value.birthCertificateNo
          : birthCertificateNo // ignore: cast_nullable_to_non_nullable
              as String?,
      apgarScore: freezed == apgarScore
          ? _value.apgarScore
          : apgarScore // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      birthComplications: freezed == birthComplications
          ? _value.birthComplications
          : birthComplications // ignore: cast_nullable_to_non_nullable
              as String?,
      uniqueQrCode: null == uniqueQrCode
          ? _value.uniqueQrCode
          : uniqueQrCode // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdatedAt: null == lastUpdatedAt
          ? _value.lastUpdatedAt
          : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
abstract class _$$ChildModelImplCopyWith<$Res>
    implements $ChildModelCopyWith<$Res> {
  factory _$$ChildModelImplCopyWith(
          _$ChildModelImpl value, $Res Function(_$ChildModelImpl) then) =
      __$$ChildModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String motherId,
      @HiveField(2) String? pregnancyId,
      @HiveField(3) String name,
      @HiveField(4) DateTime dateOfBirth,
      @HiveField(5) String gender,
      @HiveField(6) double? birthWeight,
      @HiveField(7) double? birthLength,
      @HiveField(8) double? headCircumference,
      @HiveField(9) String? birthPlace,
      @HiveField(10) String? birthCertificateNo,
      @HiveField(11) Map<String, dynamic>? apgarScore,
      @HiveField(12) String? birthComplications,
      @HiveField(13) String uniqueQrCode,
      @HiveField(14) String? photoUrl,
      @HiveField(15) bool isActive,
      @HiveField(16) int version,
      @HiveField(17) DateTime lastUpdatedAt,
      @HiveField(18) DateTime createdAt,
      @HiveField(19) DateTime updatedAt});
}

/// @nodoc
class __$$ChildModelImplCopyWithImpl<$Res>
    extends _$ChildModelCopyWithImpl<$Res, _$ChildModelImpl>
    implements _$$ChildModelImplCopyWith<$Res> {
  __$$ChildModelImplCopyWithImpl(
      _$ChildModelImpl _value, $Res Function(_$ChildModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? motherId = null,
    Object? pregnancyId = freezed,
    Object? name = null,
    Object? dateOfBirth = null,
    Object? gender = null,
    Object? birthWeight = freezed,
    Object? birthLength = freezed,
    Object? headCircumference = freezed,
    Object? birthPlace = freezed,
    Object? birthCertificateNo = freezed,
    Object? apgarScore = freezed,
    Object? birthComplications = freezed,
    Object? uniqueQrCode = null,
    Object? photoUrl = freezed,
    Object? isActive = null,
    Object? version = null,
    Object? lastUpdatedAt = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ChildModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      motherId: null == motherId
          ? _value.motherId
          : motherId // ignore: cast_nullable_to_non_nullable
              as String,
      pregnancyId: freezed == pregnancyId
          ? _value.pregnancyId
          : pregnancyId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      dateOfBirth: null == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      birthWeight: freezed == birthWeight
          ? _value.birthWeight
          : birthWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      birthLength: freezed == birthLength
          ? _value.birthLength
          : birthLength // ignore: cast_nullable_to_non_nullable
              as double?,
      headCircumference: freezed == headCircumference
          ? _value.headCircumference
          : headCircumference // ignore: cast_nullable_to_non_nullable
              as double?,
      birthPlace: freezed == birthPlace
          ? _value.birthPlace
          : birthPlace // ignore: cast_nullable_to_non_nullable
              as String?,
      birthCertificateNo: freezed == birthCertificateNo
          ? _value.birthCertificateNo
          : birthCertificateNo // ignore: cast_nullable_to_non_nullable
              as String?,
      apgarScore: freezed == apgarScore
          ? _value._apgarScore
          : apgarScore // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      birthComplications: freezed == birthComplications
          ? _value.birthComplications
          : birthComplications // ignore: cast_nullable_to_non_nullable
              as String?,
      uniqueQrCode: null == uniqueQrCode
          ? _value.uniqueQrCode
          : uniqueQrCode // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      lastUpdatedAt: null == lastUpdatedAt
          ? _value.lastUpdatedAt
          : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
class _$ChildModelImpl extends _ChildModel {
  const _$ChildModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.motherId,
      @HiveField(2) this.pregnancyId,
      @HiveField(3) required this.name,
      @HiveField(4) required this.dateOfBirth,
      @HiveField(5) required this.gender,
      @HiveField(6) this.birthWeight,
      @HiveField(7) this.birthLength,
      @HiveField(8) this.headCircumference,
      @HiveField(9) this.birthPlace,
      @HiveField(10) this.birthCertificateNo,
      @HiveField(11) final Map<String, dynamic>? apgarScore,
      @HiveField(12) this.birthComplications,
      @HiveField(13) required this.uniqueQrCode,
      @HiveField(14) this.photoUrl,
      @HiveField(15) this.isActive = true,
      @HiveField(16) this.version = 1,
      @HiveField(17) required this.lastUpdatedAt,
      @HiveField(18) required this.createdAt,
      @HiveField(19) required this.updatedAt})
      : _apgarScore = apgarScore,
        super._();

  factory _$ChildModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String motherId;
  @override
  @HiveField(2)
  final String? pregnancyId;
  @override
  @HiveField(3)
  final String name;
  @override
  @HiveField(4)
  final DateTime dateOfBirth;
  @override
  @HiveField(5)
  final String gender;
// male, female, other
  @override
  @HiveField(6)
  final double? birthWeight;
  @override
  @HiveField(7)
  final double? birthLength;
  @override
  @HiveField(8)
  final double? headCircumference;
  @override
  @HiveField(9)
  final String? birthPlace;
  @override
  @HiveField(10)
  final String? birthCertificateNo;
  final Map<String, dynamic>? _apgarScore;
  @override
  @HiveField(11)
  Map<String, dynamic>? get apgarScore {
    final value = _apgarScore;
    if (value == null) return null;
    if (_apgarScore is EqualUnmodifiableMapView) return _apgarScore;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @HiveField(12)
  final String? birthComplications;
  @override
  @HiveField(13)
  final String uniqueQrCode;
  @override
  @HiveField(14)
  final String? photoUrl;
  @override
  @JsonKey()
  @HiveField(15)
  final bool isActive;
  @override
  @JsonKey()
  @HiveField(16)
  final int version;
  @override
  @HiveField(17)
  final DateTime lastUpdatedAt;
  @override
  @HiveField(18)
  final DateTime createdAt;
  @override
  @HiveField(19)
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ChildModel(id: $id, motherId: $motherId, pregnancyId: $pregnancyId, name: $name, dateOfBirth: $dateOfBirth, gender: $gender, birthWeight: $birthWeight, birthLength: $birthLength, headCircumference: $headCircumference, birthPlace: $birthPlace, birthCertificateNo: $birthCertificateNo, apgarScore: $apgarScore, birthComplications: $birthComplications, uniqueQrCode: $uniqueQrCode, photoUrl: $photoUrl, isActive: $isActive, version: $version, lastUpdatedAt: $lastUpdatedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.motherId, motherId) ||
                other.motherId == motherId) &&
            (identical(other.pregnancyId, pregnancyId) ||
                other.pregnancyId == pregnancyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthWeight, birthWeight) ||
                other.birthWeight == birthWeight) &&
            (identical(other.birthLength, birthLength) ||
                other.birthLength == birthLength) &&
            (identical(other.headCircumference, headCircumference) ||
                other.headCircumference == headCircumference) &&
            (identical(other.birthPlace, birthPlace) ||
                other.birthPlace == birthPlace) &&
            (identical(other.birthCertificateNo, birthCertificateNo) ||
                other.birthCertificateNo == birthCertificateNo) &&
            const DeepCollectionEquality()
                .equals(other._apgarScore, _apgarScore) &&
            (identical(other.birthComplications, birthComplications) ||
                other.birthComplications == birthComplications) &&
            (identical(other.uniqueQrCode, uniqueQrCode) ||
                other.uniqueQrCode == uniqueQrCode) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.lastUpdatedAt, lastUpdatedAt) ||
                other.lastUpdatedAt == lastUpdatedAt) &&
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
        motherId,
        pregnancyId,
        name,
        dateOfBirth,
        gender,
        birthWeight,
        birthLength,
        headCircumference,
        birthPlace,
        birthCertificateNo,
        const DeepCollectionEquality().hash(_apgarScore),
        birthComplications,
        uniqueQrCode,
        photoUrl,
        isActive,
        version,
        lastUpdatedAt,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildModelImplCopyWith<_$ChildModelImpl> get copyWith =>
      __$$ChildModelImplCopyWithImpl<_$ChildModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChildModelImplToJson(
      this,
    );
  }
}

abstract class _ChildModel extends ChildModel {
  const factory _ChildModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String motherId,
      @HiveField(2) final String? pregnancyId,
      @HiveField(3) required final String name,
      @HiveField(4) required final DateTime dateOfBirth,
      @HiveField(5) required final String gender,
      @HiveField(6) final double? birthWeight,
      @HiveField(7) final double? birthLength,
      @HiveField(8) final double? headCircumference,
      @HiveField(9) final String? birthPlace,
      @HiveField(10) final String? birthCertificateNo,
      @HiveField(11) final Map<String, dynamic>? apgarScore,
      @HiveField(12) final String? birthComplications,
      @HiveField(13) required final String uniqueQrCode,
      @HiveField(14) final String? photoUrl,
      @HiveField(15) final bool isActive,
      @HiveField(16) final int version,
      @HiveField(17) required final DateTime lastUpdatedAt,
      @HiveField(18) required final DateTime createdAt,
      @HiveField(19) required final DateTime updatedAt}) = _$ChildModelImpl;
  const _ChildModel._() : super._();

  factory _ChildModel.fromJson(Map<String, dynamic> json) =
      _$ChildModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get motherId;
  @override
  @HiveField(2)
  String? get pregnancyId;
  @override
  @HiveField(3)
  String get name;
  @override
  @HiveField(4)
  DateTime get dateOfBirth;
  @override
  @HiveField(5)
  String get gender;
  @override // male, female, other
  @HiveField(6)
  double? get birthWeight;
  @override
  @HiveField(7)
  double? get birthLength;
  @override
  @HiveField(8)
  double? get headCircumference;
  @override
  @HiveField(9)
  String? get birthPlace;
  @override
  @HiveField(10)
  String? get birthCertificateNo;
  @override
  @HiveField(11)
  Map<String, dynamic>? get apgarScore;
  @override
  @HiveField(12)
  String? get birthComplications;
  @override
  @HiveField(13)
  String get uniqueQrCode;
  @override
  @HiveField(14)
  String? get photoUrl;
  @override
  @HiveField(15)
  bool get isActive;
  @override
  @HiveField(16)
  int get version;
  @override
  @HiveField(17)
  DateTime get lastUpdatedAt;
  @override
  @HiveField(18)
  DateTime get createdAt;
  @override
  @HiveField(19)
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ChildModelImplCopyWith<_$ChildModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
