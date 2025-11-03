// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(UserEntity user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function() signupInProgress,
    required TResult Function() emailVerificationPending,
    required TResult Function(String phone) phoneVerificationPending,
    required TResult Function(String email, UserRole role, String message)
        pendingVerification,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(UserEntity user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function()? signupInProgress,
    TResult? Function()? emailVerificationPending,
    TResult? Function(String phone)? phoneVerificationPending,
    TResult? Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(UserEntity user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function()? signupInProgress,
    TResult Function()? emailVerificationPending,
    TResult Function(String phone)? phoneVerificationPending,
    TResult Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(OtpSent value) otpSent,
    required TResult Function(SignupInProgress value) signupInProgress,
    required TResult Function(EmailVerificationPending value)
        emailVerificationPending,
    required TResult Function(PhoneVerificationPending value)
        phoneVerificationPending,
    required TResult Function(PendingVerification value) pendingVerification,
    required TResult Function(Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(OtpSent value)? otpSent,
    TResult? Function(SignupInProgress value)? signupInProgress,
    TResult? Function(EmailVerificationPending value)? emailVerificationPending,
    TResult? Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult? Function(PendingVerification value)? pendingVerification,
    TResult? Function(Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(OtpSent value)? otpSent,
    TResult Function(SignupInProgress value)? signupInProgress,
    TResult Function(EmailVerificationPending value)? emailVerificationPending,
    TResult Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult Function(PendingVerification value)? pendingVerification,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialImpl implements Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'AuthState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(UserEntity user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function() signupInProgress,
    required TResult Function() emailVerificationPending,
    required TResult Function(String phone) phoneVerificationPending,
    required TResult Function(String email, UserRole role, String message)
        pendingVerification,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(UserEntity user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function()? signupInProgress,
    TResult? Function()? emailVerificationPending,
    TResult? Function(String phone)? phoneVerificationPending,
    TResult? Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(UserEntity user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function()? signupInProgress,
    TResult Function()? emailVerificationPending,
    TResult Function(String phone)? phoneVerificationPending,
    TResult Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(OtpSent value) otpSent,
    required TResult Function(SignupInProgress value) signupInProgress,
    required TResult Function(EmailVerificationPending value)
        emailVerificationPending,
    required TResult Function(PhoneVerificationPending value)
        phoneVerificationPending,
    required TResult Function(PendingVerification value) pendingVerification,
    required TResult Function(Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(OtpSent value)? otpSent,
    TResult? Function(SignupInProgress value)? signupInProgress,
    TResult? Function(EmailVerificationPending value)? emailVerificationPending,
    TResult? Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult? Function(PendingVerification value)? pendingVerification,
    TResult? Function(Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(OtpSent value)? otpSent,
    TResult Function(SignupInProgress value)? signupInProgress,
    TResult Function(EmailVerificationPending value)? emailVerificationPending,
    TResult Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult Function(PendingVerification value)? pendingVerification,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class Initial implements AuthState {
  const factory Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadingImpl implements Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'AuthState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(UserEntity user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function() signupInProgress,
    required TResult Function() emailVerificationPending,
    required TResult Function(String phone) phoneVerificationPending,
    required TResult Function(String email, UserRole role, String message)
        pendingVerification,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(UserEntity user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function()? signupInProgress,
    TResult? Function()? emailVerificationPending,
    TResult? Function(String phone)? phoneVerificationPending,
    TResult? Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(UserEntity user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function()? signupInProgress,
    TResult Function()? emailVerificationPending,
    TResult Function(String phone)? phoneVerificationPending,
    TResult Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(OtpSent value) otpSent,
    required TResult Function(SignupInProgress value) signupInProgress,
    required TResult Function(EmailVerificationPending value)
        emailVerificationPending,
    required TResult Function(PhoneVerificationPending value)
        phoneVerificationPending,
    required TResult Function(PendingVerification value) pendingVerification,
    required TResult Function(Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(OtpSent value)? otpSent,
    TResult? Function(SignupInProgress value)? signupInProgress,
    TResult? Function(EmailVerificationPending value)? emailVerificationPending,
    TResult? Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult? Function(PendingVerification value)? pendingVerification,
    TResult? Function(Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(OtpSent value)? otpSent,
    TResult Function(SignupInProgress value)? signupInProgress,
    TResult Function(EmailVerificationPending value)? emailVerificationPending,
    TResult Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult Function(PendingVerification value)? pendingVerification,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements AuthState {
  const factory Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$AuthenticatedImplCopyWith<$Res> {
  factory _$$AuthenticatedImplCopyWith(
          _$AuthenticatedImpl value, $Res Function(_$AuthenticatedImpl) then) =
      __$$AuthenticatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserEntity user});
}

/// @nodoc
class __$$AuthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthenticatedImpl>
    implements _$$AuthenticatedImplCopyWith<$Res> {
  __$$AuthenticatedImplCopyWithImpl(
      _$AuthenticatedImpl _value, $Res Function(_$AuthenticatedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$AuthenticatedImpl(
      null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserEntity,
    ));
  }
}

/// @nodoc

class _$AuthenticatedImpl implements Authenticated {
  const _$AuthenticatedImpl(this.user);

  @override
  final UserEntity user;

  @override
  String toString() {
    return 'AuthState.authenticated(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticatedImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      __$$AuthenticatedImplCopyWithImpl<_$AuthenticatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(UserEntity user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function() signupInProgress,
    required TResult Function() emailVerificationPending,
    required TResult Function(String phone) phoneVerificationPending,
    required TResult Function(String email, UserRole role, String message)
        pendingVerification,
    required TResult Function(String message) error,
  }) {
    return authenticated(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(UserEntity user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function()? signupInProgress,
    TResult? Function()? emailVerificationPending,
    TResult? Function(String phone)? phoneVerificationPending,
    TResult? Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult? Function(String message)? error,
  }) {
    return authenticated?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(UserEntity user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function()? signupInProgress,
    TResult Function()? emailVerificationPending,
    TResult Function(String phone)? phoneVerificationPending,
    TResult Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(OtpSent value) otpSent,
    required TResult Function(SignupInProgress value) signupInProgress,
    required TResult Function(EmailVerificationPending value)
        emailVerificationPending,
    required TResult Function(PhoneVerificationPending value)
        phoneVerificationPending,
    required TResult Function(PendingVerification value) pendingVerification,
    required TResult Function(Error value) error,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(OtpSent value)? otpSent,
    TResult? Function(SignupInProgress value)? signupInProgress,
    TResult? Function(EmailVerificationPending value)? emailVerificationPending,
    TResult? Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult? Function(PendingVerification value)? pendingVerification,
    TResult? Function(Error value)? error,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(OtpSent value)? otpSent,
    TResult Function(SignupInProgress value)? signupInProgress,
    TResult Function(EmailVerificationPending value)? emailVerificationPending,
    TResult Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult Function(PendingVerification value)? pendingVerification,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class Authenticated implements AuthState {
  const factory Authenticated(final UserEntity user) = _$AuthenticatedImpl;

  UserEntity get user;
  @JsonKey(ignore: true)
  _$$AuthenticatedImplCopyWith<_$AuthenticatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthenticatedImplCopyWith<$Res> {
  factory _$$UnauthenticatedImplCopyWith(_$UnauthenticatedImpl value,
          $Res Function(_$UnauthenticatedImpl) then) =
      __$$UnauthenticatedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnauthenticatedImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$UnauthenticatedImpl>
    implements _$$UnauthenticatedImplCopyWith<$Res> {
  __$$UnauthenticatedImplCopyWithImpl(
      _$UnauthenticatedImpl _value, $Res Function(_$UnauthenticatedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$UnauthenticatedImpl implements Unauthenticated {
  const _$UnauthenticatedImpl();

  @override
  String toString() {
    return 'AuthState.unauthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnauthenticatedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(UserEntity user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function() signupInProgress,
    required TResult Function() emailVerificationPending,
    required TResult Function(String phone) phoneVerificationPending,
    required TResult Function(String email, UserRole role, String message)
        pendingVerification,
    required TResult Function(String message) error,
  }) {
    return unauthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(UserEntity user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function()? signupInProgress,
    TResult? Function()? emailVerificationPending,
    TResult? Function(String phone)? phoneVerificationPending,
    TResult? Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult? Function(String message)? error,
  }) {
    return unauthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(UserEntity user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function()? signupInProgress,
    TResult Function()? emailVerificationPending,
    TResult Function(String phone)? phoneVerificationPending,
    TResult Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(OtpSent value) otpSent,
    required TResult Function(SignupInProgress value) signupInProgress,
    required TResult Function(EmailVerificationPending value)
        emailVerificationPending,
    required TResult Function(PhoneVerificationPending value)
        phoneVerificationPending,
    required TResult Function(PendingVerification value) pendingVerification,
    required TResult Function(Error value) error,
  }) {
    return unauthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(OtpSent value)? otpSent,
    TResult? Function(SignupInProgress value)? signupInProgress,
    TResult? Function(EmailVerificationPending value)? emailVerificationPending,
    TResult? Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult? Function(PendingVerification value)? pendingVerification,
    TResult? Function(Error value)? error,
  }) {
    return unauthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(OtpSent value)? otpSent,
    TResult Function(SignupInProgress value)? signupInProgress,
    TResult Function(EmailVerificationPending value)? emailVerificationPending,
    TResult Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult Function(PendingVerification value)? pendingVerification,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (unauthenticated != null) {
      return unauthenticated(this);
    }
    return orElse();
  }
}

abstract class Unauthenticated implements AuthState {
  const factory Unauthenticated() = _$UnauthenticatedImpl;
}

/// @nodoc
abstract class _$$OtpSentImplCopyWith<$Res> {
  factory _$$OtpSentImplCopyWith(
          _$OtpSentImpl value, $Res Function(_$OtpSentImpl) then) =
      __$$OtpSentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String phoneNumber});
}

/// @nodoc
class __$$OtpSentImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$OtpSentImpl>
    implements _$$OtpSentImplCopyWith<$Res> {
  __$$OtpSentImplCopyWithImpl(
      _$OtpSentImpl _value, $Res Function(_$OtpSentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
  }) {
    return _then(_$OtpSentImpl(
      null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OtpSentImpl implements OtpSent {
  const _$OtpSentImpl(this.phoneNumber);

  @override
  final String phoneNumber;

  @override
  String toString() {
    return 'AuthState.otpSent(phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtpSentImpl &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtpSentImplCopyWith<_$OtpSentImpl> get copyWith =>
      __$$OtpSentImplCopyWithImpl<_$OtpSentImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(UserEntity user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function() signupInProgress,
    required TResult Function() emailVerificationPending,
    required TResult Function(String phone) phoneVerificationPending,
    required TResult Function(String email, UserRole role, String message)
        pendingVerification,
    required TResult Function(String message) error,
  }) {
    return otpSent(phoneNumber);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(UserEntity user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function()? signupInProgress,
    TResult? Function()? emailVerificationPending,
    TResult? Function(String phone)? phoneVerificationPending,
    TResult? Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult? Function(String message)? error,
  }) {
    return otpSent?.call(phoneNumber);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(UserEntity user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function()? signupInProgress,
    TResult Function()? emailVerificationPending,
    TResult Function(String phone)? phoneVerificationPending,
    TResult Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (otpSent != null) {
      return otpSent(phoneNumber);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(OtpSent value) otpSent,
    required TResult Function(SignupInProgress value) signupInProgress,
    required TResult Function(EmailVerificationPending value)
        emailVerificationPending,
    required TResult Function(PhoneVerificationPending value)
        phoneVerificationPending,
    required TResult Function(PendingVerification value) pendingVerification,
    required TResult Function(Error value) error,
  }) {
    return otpSent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(OtpSent value)? otpSent,
    TResult? Function(SignupInProgress value)? signupInProgress,
    TResult? Function(EmailVerificationPending value)? emailVerificationPending,
    TResult? Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult? Function(PendingVerification value)? pendingVerification,
    TResult? Function(Error value)? error,
  }) {
    return otpSent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(OtpSent value)? otpSent,
    TResult Function(SignupInProgress value)? signupInProgress,
    TResult Function(EmailVerificationPending value)? emailVerificationPending,
    TResult Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult Function(PendingVerification value)? pendingVerification,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (otpSent != null) {
      return otpSent(this);
    }
    return orElse();
  }
}

abstract class OtpSent implements AuthState {
  const factory OtpSent(final String phoneNumber) = _$OtpSentImpl;

  String get phoneNumber;
  @JsonKey(ignore: true)
  _$$OtpSentImplCopyWith<_$OtpSentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SignupInProgressImplCopyWith<$Res> {
  factory _$$SignupInProgressImplCopyWith(_$SignupInProgressImpl value,
          $Res Function(_$SignupInProgressImpl) then) =
      __$$SignupInProgressImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignupInProgressImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$SignupInProgressImpl>
    implements _$$SignupInProgressImplCopyWith<$Res> {
  __$$SignupInProgressImplCopyWithImpl(_$SignupInProgressImpl _value,
      $Res Function(_$SignupInProgressImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SignupInProgressImpl implements SignupInProgress {
  const _$SignupInProgressImpl();

  @override
  String toString() {
    return 'AuthState.signupInProgress()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignupInProgressImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(UserEntity user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function() signupInProgress,
    required TResult Function() emailVerificationPending,
    required TResult Function(String phone) phoneVerificationPending,
    required TResult Function(String email, UserRole role, String message)
        pendingVerification,
    required TResult Function(String message) error,
  }) {
    return signupInProgress();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(UserEntity user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function()? signupInProgress,
    TResult? Function()? emailVerificationPending,
    TResult? Function(String phone)? phoneVerificationPending,
    TResult? Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult? Function(String message)? error,
  }) {
    return signupInProgress?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(UserEntity user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function()? signupInProgress,
    TResult Function()? emailVerificationPending,
    TResult Function(String phone)? phoneVerificationPending,
    TResult Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (signupInProgress != null) {
      return signupInProgress();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(OtpSent value) otpSent,
    required TResult Function(SignupInProgress value) signupInProgress,
    required TResult Function(EmailVerificationPending value)
        emailVerificationPending,
    required TResult Function(PhoneVerificationPending value)
        phoneVerificationPending,
    required TResult Function(PendingVerification value) pendingVerification,
    required TResult Function(Error value) error,
  }) {
    return signupInProgress(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(OtpSent value)? otpSent,
    TResult? Function(SignupInProgress value)? signupInProgress,
    TResult? Function(EmailVerificationPending value)? emailVerificationPending,
    TResult? Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult? Function(PendingVerification value)? pendingVerification,
    TResult? Function(Error value)? error,
  }) {
    return signupInProgress?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(OtpSent value)? otpSent,
    TResult Function(SignupInProgress value)? signupInProgress,
    TResult Function(EmailVerificationPending value)? emailVerificationPending,
    TResult Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult Function(PendingVerification value)? pendingVerification,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (signupInProgress != null) {
      return signupInProgress(this);
    }
    return orElse();
  }
}

abstract class SignupInProgress implements AuthState {
  const factory SignupInProgress() = _$SignupInProgressImpl;
}

/// @nodoc
abstract class _$$EmailVerificationPendingImplCopyWith<$Res> {
  factory _$$EmailVerificationPendingImplCopyWith(
          _$EmailVerificationPendingImpl value,
          $Res Function(_$EmailVerificationPendingImpl) then) =
      __$$EmailVerificationPendingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EmailVerificationPendingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$EmailVerificationPendingImpl>
    implements _$$EmailVerificationPendingImplCopyWith<$Res> {
  __$$EmailVerificationPendingImplCopyWithImpl(
      _$EmailVerificationPendingImpl _value,
      $Res Function(_$EmailVerificationPendingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$EmailVerificationPendingImpl implements EmailVerificationPending {
  const _$EmailVerificationPendingImpl();

  @override
  String toString() {
    return 'AuthState.emailVerificationPending()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmailVerificationPendingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(UserEntity user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function() signupInProgress,
    required TResult Function() emailVerificationPending,
    required TResult Function(String phone) phoneVerificationPending,
    required TResult Function(String email, UserRole role, String message)
        pendingVerification,
    required TResult Function(String message) error,
  }) {
    return emailVerificationPending();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(UserEntity user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function()? signupInProgress,
    TResult? Function()? emailVerificationPending,
    TResult? Function(String phone)? phoneVerificationPending,
    TResult? Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult? Function(String message)? error,
  }) {
    return emailVerificationPending?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(UserEntity user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function()? signupInProgress,
    TResult Function()? emailVerificationPending,
    TResult Function(String phone)? phoneVerificationPending,
    TResult Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (emailVerificationPending != null) {
      return emailVerificationPending();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(OtpSent value) otpSent,
    required TResult Function(SignupInProgress value) signupInProgress,
    required TResult Function(EmailVerificationPending value)
        emailVerificationPending,
    required TResult Function(PhoneVerificationPending value)
        phoneVerificationPending,
    required TResult Function(PendingVerification value) pendingVerification,
    required TResult Function(Error value) error,
  }) {
    return emailVerificationPending(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(OtpSent value)? otpSent,
    TResult? Function(SignupInProgress value)? signupInProgress,
    TResult? Function(EmailVerificationPending value)? emailVerificationPending,
    TResult? Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult? Function(PendingVerification value)? pendingVerification,
    TResult? Function(Error value)? error,
  }) {
    return emailVerificationPending?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(OtpSent value)? otpSent,
    TResult Function(SignupInProgress value)? signupInProgress,
    TResult Function(EmailVerificationPending value)? emailVerificationPending,
    TResult Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult Function(PendingVerification value)? pendingVerification,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (emailVerificationPending != null) {
      return emailVerificationPending(this);
    }
    return orElse();
  }
}

abstract class EmailVerificationPending implements AuthState {
  const factory EmailVerificationPending() = _$EmailVerificationPendingImpl;
}

/// @nodoc
abstract class _$$PhoneVerificationPendingImplCopyWith<$Res> {
  factory _$$PhoneVerificationPendingImplCopyWith(
          _$PhoneVerificationPendingImpl value,
          $Res Function(_$PhoneVerificationPendingImpl) then) =
      __$$PhoneVerificationPendingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String phone});
}

/// @nodoc
class __$$PhoneVerificationPendingImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$PhoneVerificationPendingImpl>
    implements _$$PhoneVerificationPendingImplCopyWith<$Res> {
  __$$PhoneVerificationPendingImplCopyWithImpl(
      _$PhoneVerificationPendingImpl _value,
      $Res Function(_$PhoneVerificationPendingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phone = null,
  }) {
    return _then(_$PhoneVerificationPendingImpl(
      null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PhoneVerificationPendingImpl implements PhoneVerificationPending {
  const _$PhoneVerificationPendingImpl(this.phone);

  @override
  final String phone;

  @override
  String toString() {
    return 'AuthState.phoneVerificationPending(phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhoneVerificationPendingImpl &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @override
  int get hashCode => Object.hash(runtimeType, phone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PhoneVerificationPendingImplCopyWith<_$PhoneVerificationPendingImpl>
      get copyWith => __$$PhoneVerificationPendingImplCopyWithImpl<
          _$PhoneVerificationPendingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(UserEntity user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function() signupInProgress,
    required TResult Function() emailVerificationPending,
    required TResult Function(String phone) phoneVerificationPending,
    required TResult Function(String email, UserRole role, String message)
        pendingVerification,
    required TResult Function(String message) error,
  }) {
    return phoneVerificationPending(phone);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(UserEntity user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function()? signupInProgress,
    TResult? Function()? emailVerificationPending,
    TResult? Function(String phone)? phoneVerificationPending,
    TResult? Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult? Function(String message)? error,
  }) {
    return phoneVerificationPending?.call(phone);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(UserEntity user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function()? signupInProgress,
    TResult Function()? emailVerificationPending,
    TResult Function(String phone)? phoneVerificationPending,
    TResult Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (phoneVerificationPending != null) {
      return phoneVerificationPending(phone);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(OtpSent value) otpSent,
    required TResult Function(SignupInProgress value) signupInProgress,
    required TResult Function(EmailVerificationPending value)
        emailVerificationPending,
    required TResult Function(PhoneVerificationPending value)
        phoneVerificationPending,
    required TResult Function(PendingVerification value) pendingVerification,
    required TResult Function(Error value) error,
  }) {
    return phoneVerificationPending(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(OtpSent value)? otpSent,
    TResult? Function(SignupInProgress value)? signupInProgress,
    TResult? Function(EmailVerificationPending value)? emailVerificationPending,
    TResult? Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult? Function(PendingVerification value)? pendingVerification,
    TResult? Function(Error value)? error,
  }) {
    return phoneVerificationPending?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(OtpSent value)? otpSent,
    TResult Function(SignupInProgress value)? signupInProgress,
    TResult Function(EmailVerificationPending value)? emailVerificationPending,
    TResult Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult Function(PendingVerification value)? pendingVerification,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (phoneVerificationPending != null) {
      return phoneVerificationPending(this);
    }
    return orElse();
  }
}

abstract class PhoneVerificationPending implements AuthState {
  const factory PhoneVerificationPending(final String phone) =
      _$PhoneVerificationPendingImpl;

  String get phone;
  @JsonKey(ignore: true)
  _$$PhoneVerificationPendingImplCopyWith<_$PhoneVerificationPendingImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PendingVerificationImplCopyWith<$Res> {
  factory _$$PendingVerificationImplCopyWith(_$PendingVerificationImpl value,
          $Res Function(_$PendingVerificationImpl) then) =
      __$$PendingVerificationImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String email, UserRole role, String message});
}

/// @nodoc
class __$$PendingVerificationImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$PendingVerificationImpl>
    implements _$$PendingVerificationImplCopyWith<$Res> {
  __$$PendingVerificationImplCopyWithImpl(_$PendingVerificationImpl _value,
      $Res Function(_$PendingVerificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? role = null,
    Object? message = null,
  }) {
    return _then(_$PendingVerificationImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PendingVerificationImpl implements PendingVerification {
  const _$PendingVerificationImpl(
      {required this.email, required this.role, required this.message});

  @override
  final String email;
  @override
  final UserRole role;
  @override
  final String message;

  @override
  String toString() {
    return 'AuthState.pendingVerification(email: $email, role: $role, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PendingVerificationImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, role, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PendingVerificationImplCopyWith<_$PendingVerificationImpl> get copyWith =>
      __$$PendingVerificationImplCopyWithImpl<_$PendingVerificationImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(UserEntity user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function() signupInProgress,
    required TResult Function() emailVerificationPending,
    required TResult Function(String phone) phoneVerificationPending,
    required TResult Function(String email, UserRole role, String message)
        pendingVerification,
    required TResult Function(String message) error,
  }) {
    return pendingVerification(email, role, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(UserEntity user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function()? signupInProgress,
    TResult? Function()? emailVerificationPending,
    TResult? Function(String phone)? phoneVerificationPending,
    TResult? Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult? Function(String message)? error,
  }) {
    return pendingVerification?.call(email, role, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(UserEntity user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function()? signupInProgress,
    TResult Function()? emailVerificationPending,
    TResult Function(String phone)? phoneVerificationPending,
    TResult Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (pendingVerification != null) {
      return pendingVerification(email, role, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(OtpSent value) otpSent,
    required TResult Function(SignupInProgress value) signupInProgress,
    required TResult Function(EmailVerificationPending value)
        emailVerificationPending,
    required TResult Function(PhoneVerificationPending value)
        phoneVerificationPending,
    required TResult Function(PendingVerification value) pendingVerification,
    required TResult Function(Error value) error,
  }) {
    return pendingVerification(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(OtpSent value)? otpSent,
    TResult? Function(SignupInProgress value)? signupInProgress,
    TResult? Function(EmailVerificationPending value)? emailVerificationPending,
    TResult? Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult? Function(PendingVerification value)? pendingVerification,
    TResult? Function(Error value)? error,
  }) {
    return pendingVerification?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(OtpSent value)? otpSent,
    TResult Function(SignupInProgress value)? signupInProgress,
    TResult Function(EmailVerificationPending value)? emailVerificationPending,
    TResult Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult Function(PendingVerification value)? pendingVerification,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (pendingVerification != null) {
      return pendingVerification(this);
    }
    return orElse();
  }
}

abstract class PendingVerification implements AuthState {
  const factory PendingVerification(
      {required final String email,
      required final UserRole role,
      required final String message}) = _$PendingVerificationImpl;

  String get email;
  UserRole get role;
  String get message;
  @JsonKey(ignore: true)
  _$$PendingVerificationImplCopyWith<_$PendingVerificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AuthState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(UserEntity user) authenticated,
    required TResult Function() unauthenticated,
    required TResult Function(String phoneNumber) otpSent,
    required TResult Function() signupInProgress,
    required TResult Function() emailVerificationPending,
    required TResult Function(String phone) phoneVerificationPending,
    required TResult Function(String email, UserRole role, String message)
        pendingVerification,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(UserEntity user)? authenticated,
    TResult? Function()? unauthenticated,
    TResult? Function(String phoneNumber)? otpSent,
    TResult? Function()? signupInProgress,
    TResult? Function()? emailVerificationPending,
    TResult? Function(String phone)? phoneVerificationPending,
    TResult? Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(UserEntity user)? authenticated,
    TResult Function()? unauthenticated,
    TResult Function(String phoneNumber)? otpSent,
    TResult Function()? signupInProgress,
    TResult Function()? emailVerificationPending,
    TResult Function(String phone)? phoneVerificationPending,
    TResult Function(String email, UserRole role, String message)?
        pendingVerification,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Initial value) initial,
    required TResult Function(Loading value) loading,
    required TResult Function(Authenticated value) authenticated,
    required TResult Function(Unauthenticated value) unauthenticated,
    required TResult Function(OtpSent value) otpSent,
    required TResult Function(SignupInProgress value) signupInProgress,
    required TResult Function(EmailVerificationPending value)
        emailVerificationPending,
    required TResult Function(PhoneVerificationPending value)
        phoneVerificationPending,
    required TResult Function(PendingVerification value) pendingVerification,
    required TResult Function(Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Initial value)? initial,
    TResult? Function(Loading value)? loading,
    TResult? Function(Authenticated value)? authenticated,
    TResult? Function(Unauthenticated value)? unauthenticated,
    TResult? Function(OtpSent value)? otpSent,
    TResult? Function(SignupInProgress value)? signupInProgress,
    TResult? Function(EmailVerificationPending value)? emailVerificationPending,
    TResult? Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult? Function(PendingVerification value)? pendingVerification,
    TResult? Function(Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Initial value)? initial,
    TResult Function(Loading value)? loading,
    TResult Function(Authenticated value)? authenticated,
    TResult Function(Unauthenticated value)? unauthenticated,
    TResult Function(OtpSent value)? otpSent,
    TResult Function(SignupInProgress value)? signupInProgress,
    TResult Function(EmailVerificationPending value)? emailVerificationPending,
    TResult Function(PhoneVerificationPending value)? phoneVerificationPending,
    TResult Function(PendingVerification value)? pendingVerification,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements AuthState {
  const factory Error(final String message) = _$ErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
