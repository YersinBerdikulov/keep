// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_friend_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserFriendModel _$UserFriendModelFromJson(Map<String, dynamic> json) {
  return _UserFriendModel.fromJson(json);
}

/// @nodoc
mixin _$UserFriendModel {
  @JsonKey(name: '\$id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: '\$createdAt')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: '\$updatedAt')
  String? get updatedAt => throw _privateConstructorUsedError;
  String get sendRequestUserId => throw _privateConstructorUsedError;
  String get receiveRequestUserId => throw _privateConstructorUsedError;
  String? get sendRequestUserName => throw _privateConstructorUsedError;
  String? get receiveRequestUserName => throw _privateConstructorUsedError;
  String? get sendRequestProfilePic => throw _privateConstructorUsedError;
  String? get receiveRequestProfilePic => throw _privateConstructorUsedError;
  FriendRequestStatus get status => throw _privateConstructorUsedError;

  /// Serializes this UserFriendModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserFriendModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserFriendModelCopyWith<UserFriendModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserFriendModelCopyWith<$Res> {
  factory $UserFriendModelCopyWith(
          UserFriendModel value, $Res Function(UserFriendModel) then) =
      _$UserFriendModelCopyWithImpl<$Res, UserFriendModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '\$id') String? id,
      @JsonKey(name: '\$createdAt') String? createdAt,
      @JsonKey(name: '\$updatedAt') String? updatedAt,
      String sendRequestUserId,
      String receiveRequestUserId,
      String? sendRequestUserName,
      String? receiveRequestUserName,
      String? sendRequestProfilePic,
      String? receiveRequestProfilePic,
      FriendRequestStatus status});
}

/// @nodoc
class _$UserFriendModelCopyWithImpl<$Res, $Val extends UserFriendModel>
    implements $UserFriendModelCopyWith<$Res> {
  _$UserFriendModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserFriendModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? sendRequestUserId = null,
    Object? receiveRequestUserId = null,
    Object? sendRequestUserName = freezed,
    Object? receiveRequestUserName = freezed,
    Object? sendRequestProfilePic = freezed,
    Object? receiveRequestProfilePic = freezed,
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
      sendRequestUserId: null == sendRequestUserId
          ? _value.sendRequestUserId
          : sendRequestUserId // ignore: cast_nullable_to_non_nullable
              as String,
      receiveRequestUserId: null == receiveRequestUserId
          ? _value.receiveRequestUserId
          : receiveRequestUserId // ignore: cast_nullable_to_non_nullable
              as String,
      sendRequestUserName: freezed == sendRequestUserName
          ? _value.sendRequestUserName
          : sendRequestUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      receiveRequestUserName: freezed == receiveRequestUserName
          ? _value.receiveRequestUserName
          : receiveRequestUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      sendRequestProfilePic: freezed == sendRequestProfilePic
          ? _value.sendRequestProfilePic
          : sendRequestProfilePic // ignore: cast_nullable_to_non_nullable
              as String?,
      receiveRequestProfilePic: freezed == receiveRequestProfilePic
          ? _value.receiveRequestProfilePic
          : receiveRequestProfilePic // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendRequestStatus,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserFriendModelImplCopyWith<$Res>
    implements $UserFriendModelCopyWith<$Res> {
  factory _$$UserFriendModelImplCopyWith(_$UserFriendModelImpl value,
          $Res Function(_$UserFriendModelImpl) then) =
      __$$UserFriendModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '\$id') String? id,
      @JsonKey(name: '\$createdAt') String? createdAt,
      @JsonKey(name: '\$updatedAt') String? updatedAt,
      String sendRequestUserId,
      String receiveRequestUserId,
      String? sendRequestUserName,
      String? receiveRequestUserName,
      String? sendRequestProfilePic,
      String? receiveRequestProfilePic,
      FriendRequestStatus status});
}

/// @nodoc
class __$$UserFriendModelImplCopyWithImpl<$Res>
    extends _$UserFriendModelCopyWithImpl<$Res, _$UserFriendModelImpl>
    implements _$$UserFriendModelImplCopyWith<$Res> {
  __$$UserFriendModelImplCopyWithImpl(
      _$UserFriendModelImpl _value, $Res Function(_$UserFriendModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserFriendModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? sendRequestUserId = null,
    Object? receiveRequestUserId = null,
    Object? sendRequestUserName = freezed,
    Object? receiveRequestUserName = freezed,
    Object? sendRequestProfilePic = freezed,
    Object? receiveRequestProfilePic = freezed,
    Object? status = null,
  }) {
    return _then(_$UserFriendModelImpl(
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
      sendRequestUserId: null == sendRequestUserId
          ? _value.sendRequestUserId
          : sendRequestUserId // ignore: cast_nullable_to_non_nullable
              as String,
      receiveRequestUserId: null == receiveRequestUserId
          ? _value.receiveRequestUserId
          : receiveRequestUserId // ignore: cast_nullable_to_non_nullable
              as String,
      sendRequestUserName: freezed == sendRequestUserName
          ? _value.sendRequestUserName
          : sendRequestUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      receiveRequestUserName: freezed == receiveRequestUserName
          ? _value.receiveRequestUserName
          : receiveRequestUserName // ignore: cast_nullable_to_non_nullable
              as String?,
      sendRequestProfilePic: freezed == sendRequestProfilePic
          ? _value.sendRequestProfilePic
          : sendRequestProfilePic // ignore: cast_nullable_to_non_nullable
              as String?,
      receiveRequestProfilePic: freezed == receiveRequestProfilePic
          ? _value.receiveRequestProfilePic
          : receiveRequestProfilePic // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FriendRequestStatus,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserFriendModelImpl implements _UserFriendModel {
  const _$UserFriendModelImpl(
      {@JsonKey(name: '\$id') this.id,
      @JsonKey(name: '\$createdAt') this.createdAt,
      @JsonKey(name: '\$updatedAt') this.updatedAt,
      required this.sendRequestUserId,
      required this.receiveRequestUserId,
      this.sendRequestUserName,
      this.receiveRequestUserName,
      this.sendRequestProfilePic,
      this.receiveRequestProfilePic,
      this.status = FriendRequestStatus.pending});

  factory _$UserFriendModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserFriendModelImplFromJson(json);

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
  final String sendRequestUserId;
  @override
  final String receiveRequestUserId;
  @override
  final String? sendRequestUserName;
  @override
  final String? receiveRequestUserName;
  @override
  final String? sendRequestProfilePic;
  @override
  final String? receiveRequestProfilePic;
  @override
  @JsonKey()
  final FriendRequestStatus status;

  @override
  String toString() {
    return 'UserFriendModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, sendRequestUserId: $sendRequestUserId, receiveRequestUserId: $receiveRequestUserId, sendRequestUserName: $sendRequestUserName, receiveRequestUserName: $receiveRequestUserName, sendRequestProfilePic: $sendRequestProfilePic, receiveRequestProfilePic: $receiveRequestProfilePic, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserFriendModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.sendRequestUserId, sendRequestUserId) ||
                other.sendRequestUserId == sendRequestUserId) &&
            (identical(other.receiveRequestUserId, receiveRequestUserId) ||
                other.receiveRequestUserId == receiveRequestUserId) &&
            (identical(other.sendRequestUserName, sendRequestUserName) ||
                other.sendRequestUserName == sendRequestUserName) &&
            (identical(other.receiveRequestUserName, receiveRequestUserName) ||
                other.receiveRequestUserName == receiveRequestUserName) &&
            (identical(other.sendRequestProfilePic, sendRequestProfilePic) ||
                other.sendRequestProfilePic == sendRequestProfilePic) &&
            (identical(
                    other.receiveRequestProfilePic, receiveRequestProfilePic) ||
                other.receiveRequestProfilePic == receiveRequestProfilePic) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      updatedAt,
      sendRequestUserId,
      receiveRequestUserId,
      sendRequestUserName,
      receiveRequestUserName,
      sendRequestProfilePic,
      receiveRequestProfilePic,
      status);

  /// Create a copy of UserFriendModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserFriendModelImplCopyWith<_$UserFriendModelImpl> get copyWith =>
      __$$UserFriendModelImplCopyWithImpl<_$UserFriendModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserFriendModelImplToJson(
      this,
    );
  }
}

abstract class _UserFriendModel implements UserFriendModel {
  const factory _UserFriendModel(
      {@JsonKey(name: '\$id') final String? id,
      @JsonKey(name: '\$createdAt') final String? createdAt,
      @JsonKey(name: '\$updatedAt') final String? updatedAt,
      required final String sendRequestUserId,
      required final String receiveRequestUserId,
      final String? sendRequestUserName,
      final String? receiveRequestUserName,
      final String? sendRequestProfilePic,
      final String? receiveRequestProfilePic,
      final FriendRequestStatus status}) = _$UserFriendModelImpl;

  factory _UserFriendModel.fromJson(Map<String, dynamic> json) =
      _$UserFriendModelImpl.fromJson;

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
  String get sendRequestUserId;
  @override
  String get receiveRequestUserId;
  @override
  String? get sendRequestUserName;
  @override
  String? get receiveRequestUserName;
  @override
  String? get sendRequestProfilePic;
  @override
  String? get receiveRequestProfilePic;
  @override
  FriendRequestStatus get status;

  /// Create a copy of UserFriendModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserFriendModelImplCopyWith<_$UserFriendModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
