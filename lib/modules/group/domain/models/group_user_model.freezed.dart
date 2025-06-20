// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupUserModel _$GroupUserModelFromJson(Map<String, dynamic> json) {
  return _GroupUserModel.fromJson(json);
}

/// @nodoc
mixin _$GroupUserModel {
  @JsonKey(name: '\$id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: '\$createdAt')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: '\$updatedAt')
  String? get updatedAt => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this GroupUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupUserModelCopyWith<GroupUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupUserModelCopyWith<$Res> {
  factory $GroupUserModelCopyWith(
          GroupUserModel value, $Res Function(GroupUserModel) then) =
      _$GroupUserModelCopyWithImpl<$Res, GroupUserModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '\$id') String? id,
      @JsonKey(name: '\$createdAt') String? createdAt,
      @JsonKey(name: '\$updatedAt') String? updatedAt,
      String userId,
      String groupId,
      String status,
      String role});
}

/// @nodoc
class _$GroupUserModelCopyWithImpl<$Res, $Val extends GroupUserModel>
    implements $GroupUserModelCopyWith<$Res> {
  _$GroupUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? userId = null,
    Object? groupId = null,
    Object? status = null,
    Object? role = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupUserModelImplCopyWith<$Res>
    implements $GroupUserModelCopyWith<$Res> {
  factory _$$GroupUserModelImplCopyWith(_$GroupUserModelImpl value,
          $Res Function(_$GroupUserModelImpl) then) =
      __$$GroupUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '\$id') String? id,
      @JsonKey(name: '\$createdAt') String? createdAt,
      @JsonKey(name: '\$updatedAt') String? updatedAt,
      String userId,
      String groupId,
      String status,
      String role});
}

/// @nodoc
class __$$GroupUserModelImplCopyWithImpl<$Res>
    extends _$GroupUserModelCopyWithImpl<$Res, _$GroupUserModelImpl>
    implements _$$GroupUserModelImplCopyWith<$Res> {
  __$$GroupUserModelImplCopyWithImpl(
      _$GroupUserModelImpl _value, $Res Function(_$GroupUserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? userId = null,
    Object? groupId = null,
    Object? status = null,
    Object? role = null,
  }) {
    return _then(_$GroupUserModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupUserModelImpl implements _GroupUserModel {
  const _$GroupUserModelImpl(
      {@JsonKey(name: '\$id') this.id,
      @JsonKey(name: '\$createdAt') this.createdAt,
      @JsonKey(name: '\$updatedAt') this.updatedAt,
      required this.userId,
      required this.groupId,
      this.status = "pending",
      this.role = "member"});

  factory _$GroupUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupUserModelImplFromJson(json);

  @override
  @JsonKey(name: '\$id')
  final String? id;
  @override
  @JsonKey(name: '\$createdAt')
  final String? createdAt;
  @override
  @JsonKey(name: '\$updatedAt')
  final String? updatedAt;
  @override
  final String userId;
  @override
  final String groupId;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String role;

  @override
  String toString() {
    return 'GroupUserModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, groupId: $groupId, status: $status, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, createdAt, updatedAt, userId, groupId, status, role);

  /// Create a copy of GroupUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupUserModelImplCopyWith<_$GroupUserModelImpl> get copyWith =>
      __$$GroupUserModelImplCopyWithImpl<_$GroupUserModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupUserModelImplToJson(
      this,
    );
  }
}

abstract class _GroupUserModel implements GroupUserModel {
  const factory _GroupUserModel(
      {@JsonKey(name: '\$id') final String? id,
      @JsonKey(name: '\$createdAt') final String? createdAt,
      @JsonKey(name: '\$updatedAt') final String? updatedAt,
      required final String userId,
      required final String groupId,
      final String status,
      final String role}) = _$GroupUserModelImpl;

  factory _GroupUserModel.fromJson(Map<String, dynamic> json) =
      _$GroupUserModelImpl.fromJson;

  @override
  @JsonKey(name: '\$id')
  String? get id;
  @override
  @JsonKey(name: '\$createdAt')
  String? get createdAt;
  @override
  @JsonKey(name: '\$updatedAt')
  String? get updatedAt;
  @override
  String get userId;
  @override
  String get groupId;
  @override
  String get status;
  @override
  String get role;

  /// Create a copy of GroupUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupUserModelImplCopyWith<_$GroupUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
