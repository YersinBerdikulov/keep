// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'box_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BoxUserModel _$BoxUserModelFromJson(Map<String, dynamic> json) {
  return _BoxUserModel.fromJson(json);
}

/// @nodoc
mixin _$BoxUserModel {
  @JsonKey(name: '\$id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: '\$createdAt')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: '\$updatedAt')
  String? get updatedAt => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String get boxId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  /// Serializes this BoxUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoxUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoxUserModelCopyWith<BoxUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoxUserModelCopyWith<$Res> {
  factory $BoxUserModelCopyWith(
          BoxUserModel value, $Res Function(BoxUserModel) then) =
      _$BoxUserModelCopyWithImpl<$Res, BoxUserModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '\$id') String? id,
      @JsonKey(name: '\$createdAt') String? createdAt,
      @JsonKey(name: '\$updatedAt') String? updatedAt,
      String userId,
      String groupId,
      String boxId,
      String status});
}

/// @nodoc
class _$BoxUserModelCopyWithImpl<$Res, $Val extends BoxUserModel>
    implements $BoxUserModelCopyWith<$Res> {
  _$BoxUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoxUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? userId = null,
    Object? groupId = null,
    Object? boxId = null,
    Object? status = null,
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
      boxId: null == boxId
          ? _value.boxId
          : boxId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoxUserModelImplCopyWith<$Res>
    implements $BoxUserModelCopyWith<$Res> {
  factory _$$BoxUserModelImplCopyWith(
          _$BoxUserModelImpl value, $Res Function(_$BoxUserModelImpl) then) =
      __$$BoxUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '\$id') String? id,
      @JsonKey(name: '\$createdAt') String? createdAt,
      @JsonKey(name: '\$updatedAt') String? updatedAt,
      String userId,
      String groupId,
      String boxId,
      String status});
}

/// @nodoc
class __$$BoxUserModelImplCopyWithImpl<$Res>
    extends _$BoxUserModelCopyWithImpl<$Res, _$BoxUserModelImpl>
    implements _$$BoxUserModelImplCopyWith<$Res> {
  __$$BoxUserModelImplCopyWithImpl(
      _$BoxUserModelImpl _value, $Res Function(_$BoxUserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BoxUserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? userId = null,
    Object? groupId = null,
    Object? boxId = null,
    Object? status = null,
  }) {
    return _then(_$BoxUserModelImpl(
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
      boxId: null == boxId
          ? _value.boxId
          : boxId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoxUserModelImpl implements _BoxUserModel {
  const _$BoxUserModelImpl(
      {@JsonKey(name: '\$id') this.id,
      @JsonKey(name: '\$createdAt') this.createdAt,
      @JsonKey(name: '\$updatedAt') this.updatedAt,
      required this.userId,
      required this.groupId,
      required this.boxId,
      this.status = "accept"});

  factory _$BoxUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoxUserModelImplFromJson(json);

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
  final String boxId;
  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'BoxUserModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, groupId: $groupId, boxId: $boxId, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoxUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.boxId, boxId) || other.boxId == boxId) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, createdAt, updatedAt, userId, groupId, boxId, status);

  /// Create a copy of BoxUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoxUserModelImplCopyWith<_$BoxUserModelImpl> get copyWith =>
      __$$BoxUserModelImplCopyWithImpl<_$BoxUserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoxUserModelImplToJson(
      this,
    );
  }
}

abstract class _BoxUserModel implements BoxUserModel {
  const factory _BoxUserModel(
      {@JsonKey(name: '\$id') final String? id,
      @JsonKey(name: '\$createdAt') final String? createdAt,
      @JsonKey(name: '\$updatedAt') final String? updatedAt,
      required final String userId,
      required final String groupId,
      required final String boxId,
      final String status}) = _$BoxUserModelImpl;

  factory _BoxUserModel.fromJson(Map<String, dynamic> json) =
      _$BoxUserModelImpl.fromJson;

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
  String get boxId;
  @override
  String get status;

  /// Create a copy of BoxUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoxUserModelImplCopyWith<_$BoxUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
