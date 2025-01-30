// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExpenseUserModel _$ExpenseUserModelFromJson(Map<String, dynamic> json) {
  return _ExpenseUserModel.fromJson(json);
}

/// @nodoc
mixin _$ExpenseUserModel {
  @JsonKey(name: '\$id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: '\$createdAt')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: '\$updatedAt')
  String? get updatedAt => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String get boxId => throw _privateConstructorUsedError;
  String get expenseId => throw _privateConstructorUsedError;
  num get cost => throw _privateConstructorUsedError;
  bool get isPaid => throw _privateConstructorUsedError;

  /// Serializes this ExpenseUserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExpenseUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExpenseUserModelCopyWith<ExpenseUserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseUserModelCopyWith<$Res> {
  factory $ExpenseUserModelCopyWith(
          ExpenseUserModel value, $Res Function(ExpenseUserModel) then) =
      _$ExpenseUserModelCopyWithImpl<$Res, ExpenseUserModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '\$id') String? id,
      @JsonKey(name: '\$createdAt') String? createdAt,
      @JsonKey(name: '\$updatedAt') String? updatedAt,
      String userId,
      String groupId,
      String boxId,
      String expenseId,
      num cost,
      bool isPaid});
}

/// @nodoc
class _$ExpenseUserModelCopyWithImpl<$Res, $Val extends ExpenseUserModel>
    implements $ExpenseUserModelCopyWith<$Res> {
  _$ExpenseUserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExpenseUserModel
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
    Object? expenseId = null,
    Object? cost = null,
    Object? isPaid = null,
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
      expenseId: null == expenseId
          ? _value.expenseId
          : expenseId // ignore: cast_nullable_to_non_nullable
              as String,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as num,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExpenseUserModelImplCopyWith<$Res>
    implements $ExpenseUserModelCopyWith<$Res> {
  factory _$$ExpenseUserModelImplCopyWith(_$ExpenseUserModelImpl value,
          $Res Function(_$ExpenseUserModelImpl) then) =
      __$$ExpenseUserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '\$id') String? id,
      @JsonKey(name: '\$createdAt') String? createdAt,
      @JsonKey(name: '\$updatedAt') String? updatedAt,
      String userId,
      String groupId,
      String boxId,
      String expenseId,
      num cost,
      bool isPaid});
}

/// @nodoc
class __$$ExpenseUserModelImplCopyWithImpl<$Res>
    extends _$ExpenseUserModelCopyWithImpl<$Res, _$ExpenseUserModelImpl>
    implements _$$ExpenseUserModelImplCopyWith<$Res> {
  __$$ExpenseUserModelImplCopyWithImpl(_$ExpenseUserModelImpl _value,
      $Res Function(_$ExpenseUserModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExpenseUserModel
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
    Object? expenseId = null,
    Object? cost = null,
    Object? isPaid = null,
  }) {
    return _then(_$ExpenseUserModelImpl(
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
      expenseId: null == expenseId
          ? _value.expenseId
          : expenseId // ignore: cast_nullable_to_non_nullable
              as String,
      cost: null == cost
          ? _value.cost
          : cost // ignore: cast_nullable_to_non_nullable
              as num,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseUserModelImpl implements _ExpenseUserModel {
  const _$ExpenseUserModelImpl(
      {@JsonKey(name: '\$id') this.id,
      @JsonKey(name: '\$createdAt') this.createdAt,
      @JsonKey(name: '\$updatedAt') this.updatedAt,
      required this.userId,
      required this.groupId,
      required this.boxId,
      required this.expenseId,
      this.cost = 0,
      this.isPaid = false});

  factory _$ExpenseUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseUserModelImplFromJson(json);

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
  final String expenseId;
  @override
  @JsonKey()
  final num cost;
  @override
  @JsonKey()
  final bool isPaid;

  @override
  String toString() {
    return 'ExpenseUserModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, groupId: $groupId, boxId: $boxId, expenseId: $expenseId, cost: $cost, isPaid: $isPaid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.boxId, boxId) || other.boxId == boxId) &&
            (identical(other.expenseId, expenseId) ||
                other.expenseId == expenseId) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.isPaid, isPaid) || other.isPaid == isPaid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, createdAt, updatedAt, userId,
      groupId, boxId, expenseId, cost, isPaid);

  /// Create a copy of ExpenseUserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseUserModelImplCopyWith<_$ExpenseUserModelImpl> get copyWith =>
      __$$ExpenseUserModelImplCopyWithImpl<_$ExpenseUserModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExpenseUserModelImplToJson(
      this,
    );
  }
}

abstract class _ExpenseUserModel implements ExpenseUserModel {
  const factory _ExpenseUserModel(
      {@JsonKey(name: '\$id') final String? id,
      @JsonKey(name: '\$createdAt') final String? createdAt,
      @JsonKey(name: '\$updatedAt') final String? updatedAt,
      required final String userId,
      required final String groupId,
      required final String boxId,
      required final String expenseId,
      final num cost,
      final bool isPaid}) = _$ExpenseUserModelImpl;

  factory _ExpenseUserModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseUserModelImpl.fromJson;

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
  String get expenseId;
  @override
  num get cost;
  @override
  bool get isPaid;

  /// Create a copy of ExpenseUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseUserModelImplCopyWith<_$ExpenseUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
