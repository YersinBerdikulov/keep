// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthUserModel _$AuthUserModelFromJson(Map<String, dynamic> json) {
  return _AuthUserModel.fromJson(json);
}

/// @nodoc
mixin _$AuthUserModel {
  @JsonKey(name: '\$id')
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'emailVerification')
  bool get emailVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'phoneVerification')
  bool get phoneVerified => throw _privateConstructorUsedError;
  bool get status => throw _privateConstructorUsedError;
  String get registration => throw _privateConstructorUsedError;
  @JsonKey(name: 'passwordUpdate')
  String get passwordUpdatedAt => throw _privateConstructorUsedError;
  List<String> get labels => throw _privateConstructorUsedError;
  List<String> get tokens => throw _privateConstructorUsedError;

  /// Serializes this AuthUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthUserModelCopyWith<AuthUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthUserModelCopyWith<$Res> {
  factory $AuthUserModelCopyWith(
          AuthUserModel value, $Res Function(AuthUserModel) then) =
      _$AuthUserModelCopyWithImpl<$Res, AuthUserModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '\$id') String id,
      String name,
      String email,
      String phone,
      @JsonKey(name: 'emailVerification') bool emailVerified,
      @JsonKey(name: 'phoneVerification') bool phoneVerified,
      bool status,
      String registration,
      @JsonKey(name: 'passwordUpdate') String passwordUpdatedAt,
      List<String> labels,
      List<String> tokens});
}

/// @nodoc
class _$AuthUserModelCopyWithImpl<$Res, $Val extends AuthUserModel>
    implements $AuthUserModelCopyWith<$Res> {
  _$AuthUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? emailVerified = null,
    Object? phoneVerified = null,
    Object? status = null,
    Object? registration = null,
    Object? passwordUpdatedAt = null,
    Object? labels = null,
    Object? tokens = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as bool,
      registration: null == registration
          ? _value.registration
          : registration // ignore: cast_nullable_to_non_nullable
              as String,
      passwordUpdatedAt: null == passwordUpdatedAt
          ? _value.passwordUpdatedAt
          : passwordUpdatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      labels: null == labels
          ? _value.labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tokens: null == tokens
          ? _value.tokens
          : tokens // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthUserModelImplCopyWith<$Res>
    implements $AuthUserModelCopyWith<$Res> {
  factory _$$AuthUserModelImplCopyWith(
          _$AuthUserModelImpl value, $Res Function(_$AuthUserModelImpl) then) =
      __$$AuthUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '\$id') String id,
      String name,
      String email,
      String phone,
      @JsonKey(name: 'emailVerification') bool emailVerified,
      @JsonKey(name: 'phoneVerification') bool phoneVerified,
      bool status,
      String registration,
      @JsonKey(name: 'passwordUpdate') String passwordUpdatedAt,
      List<String> labels,
      List<String> tokens});
}

/// @nodoc
class __$$AuthUserModelImplCopyWithImpl<$Res>
    extends _$AuthUserModelCopyWithImpl<$Res, _$AuthUserModelImpl>
    implements _$$AuthUserModelImplCopyWith<$Res> {
  __$$AuthUserModelImplCopyWithImpl(
      _$AuthUserModelImpl _value, $Res Function(_$AuthUserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuthUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? emailVerified = null,
    Object? phoneVerified = null,
    Object? status = null,
    Object? registration = null,
    Object? passwordUpdatedAt = null,
    Object? labels = null,
    Object? tokens = null,
  }) {
    return _then(_$AuthUserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as bool,
      registration: null == registration
          ? _value.registration
          : registration // ignore: cast_nullable_to_non_nullable
              as String,
      passwordUpdatedAt: null == passwordUpdatedAt
          ? _value.passwordUpdatedAt
          : passwordUpdatedAt // ignore: cast_nullable_to_non_nullable
              as String,
      labels: null == labels
          ? _value._labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tokens: null == tokens
          ? _value._tokens
          : tokens // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthUserModelImpl implements _AuthUserModel {
  const _$AuthUserModelImpl(
      {@JsonKey(name: '\$id') required this.id,
      required this.name,
      required this.email,
      required this.phone,
      @JsonKey(name: 'emailVerification') required this.emailVerified,
      @JsonKey(name: 'phoneVerification') required this.phoneVerified,
      required this.status,
      required this.registration,
      @JsonKey(name: 'passwordUpdate') required this.passwordUpdatedAt,
      final List<String> labels = const [],
      final List<String> tokens = const []})
      : _labels = labels,
        _tokens = tokens;

  factory _$AuthUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthUserModelImplFromJson(json);

  @override
  @JsonKey(name: '\$id')
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String phone;
  @override
  @JsonKey(name: 'emailVerification')
  final bool emailVerified;
  @override
  @JsonKey(name: 'phoneVerification')
  final bool phoneVerified;
  @override
  final bool status;
  @override
  final String registration;
  @override
  @JsonKey(name: 'passwordUpdate')
  final String passwordUpdatedAt;
  final List<String> _labels;
  @override
  @JsonKey()
  List<String> get labels {
    if (_labels is EqualUnmodifiableListView) return _labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_labels);
  }

  final List<String> _tokens;
  @override
  @JsonKey()
  List<String> get tokens {
    if (_tokens is EqualUnmodifiableListView) return _tokens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tokens);
  }

  @override
  String toString() {
    return 'AuthUserModel(id: $id, name: $name, email: $email, phone: $phone, emailVerified: $emailVerified, phoneVerified: $phoneVerified, status: $status, registration: $registration, passwordUpdatedAt: $passwordUpdatedAt, labels: $labels, tokens: $tokens)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.phoneVerified, phoneVerified) ||
                other.phoneVerified == phoneVerified) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.registration, registration) ||
                other.registration == registration) &&
            (identical(other.passwordUpdatedAt, passwordUpdatedAt) ||
                other.passwordUpdatedAt == passwordUpdatedAt) &&
            const DeepCollectionEquality().equals(other._labels, _labels) &&
            const DeepCollectionEquality().equals(other._tokens, _tokens));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      email,
      phone,
      emailVerified,
      phoneVerified,
      status,
      registration,
      passwordUpdatedAt,
      const DeepCollectionEquality().hash(_labels),
      const DeepCollectionEquality().hash(_tokens));

  /// Create a copy of AuthUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthUserModelImplCopyWith<_$AuthUserModelImpl> get copyWith =>
      __$$AuthUserModelImplCopyWithImpl<_$AuthUserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthUserModelImplToJson(
      this,
    );
  }
}

abstract class _AuthUserModel implements AuthUserModel {
  const factory _AuthUserModel(
      {@JsonKey(name: '\$id') required final String id,
      required final String name,
      required final String email,
      required final String phone,
      @JsonKey(name: 'emailVerification') required final bool emailVerified,
      @JsonKey(name: 'phoneVerification') required final bool phoneVerified,
      required final bool status,
      required final String registration,
      @JsonKey(name: 'passwordUpdate') required final String passwordUpdatedAt,
      final List<String> labels,
      final List<String> tokens}) = _$AuthUserModelImpl;

  factory _AuthUserModel.fromJson(Map<String, dynamic> json) =
      _$AuthUserModelImpl.fromJson;

  @override
  @JsonKey(name: '\$id')
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get phone;
  @override
  @JsonKey(name: 'emailVerification')
  bool get emailVerified;
  @override
  @JsonKey(name: 'phoneVerification')
  bool get phoneVerified;
  @override
  bool get status;
  @override
  String get registration;
  @override
  @JsonKey(name: 'passwordUpdate')
  String get passwordUpdatedAt;
  @override
  List<String> get labels;
  @override
  List<String> get tokens;

  /// Create a copy of AuthUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthUserModelImplCopyWith<_$AuthUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
