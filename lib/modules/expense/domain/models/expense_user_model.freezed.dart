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
  String? get systemCreatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: '\$updatedAt')
  String? get systemUpdatedAt => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  String get boxId => throw _privateConstructorUsedError;
  String get expenseId => throw _privateConstructorUsedError;
  double get cost => throw _privateConstructorUsedError;
  bool get isPaid => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  String? get dueDate => throw _privateConstructorUsedError;
  String get splitType => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  List<String> get recipients => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get recurringId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  double get shares => throw _privateConstructorUsedError;
  double get sharePercentage => throw _privateConstructorUsedError;
  double get shareAmount => throw _privateConstructorUsedError;
  bool get isSettled => throw _privateConstructorUsedError;
  String? get settledAt => throw _privateConstructorUsedError;
  String? get settlementId => throw _privateConstructorUsedError;

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
      @JsonKey(name: '\$createdAt') String? systemCreatedAt,
      @JsonKey(name: '\$updatedAt') String? systemUpdatedAt,
      String userId,
      String groupId,
      String boxId,
      String expenseId,
      double cost,
      bool isPaid,
      String createdAt,
      String? updatedAt,
      String? dueDate,
      String splitType,
      String currency,
      List<String> recipients,
      String status,
      String? recurringId,
      String? notes,
      double shares,
      double sharePercentage,
      double shareAmount,
      bool isSettled,
      String? settledAt,
      String? settlementId});
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
    Object? systemCreatedAt = freezed,
    Object? systemUpdatedAt = freezed,
    Object? userId = null,
    Object? groupId = null,
    Object? boxId = null,
    Object? expenseId = null,
    Object? cost = null,
    Object? isPaid = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? dueDate = freezed,
    Object? splitType = null,
    Object? currency = null,
    Object? recipients = null,
    Object? status = null,
    Object? recurringId = freezed,
    Object? notes = freezed,
    Object? shares = null,
    Object? sharePercentage = null,
    Object? shareAmount = null,
    Object? isSettled = null,
    Object? settledAt = freezed,
    Object? settlementId = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      systemCreatedAt: freezed == systemCreatedAt
          ? _value.systemCreatedAt
          : systemCreatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      systemUpdatedAt: freezed == systemUpdatedAt
          ? _value.systemUpdatedAt
          : systemUpdatedAt // ignore: cast_nullable_to_non_nullable
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
              as double,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      splitType: null == splitType
          ? _value.splitType
          : splitType // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      recipients: null == recipients
          ? _value.recipients
          : recipients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      recurringId: freezed == recurringId
          ? _value.recurringId
          : recurringId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      shares: null == shares
          ? _value.shares
          : shares // ignore: cast_nullable_to_non_nullable
              as double,
      sharePercentage: null == sharePercentage
          ? _value.sharePercentage
          : sharePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      shareAmount: null == shareAmount
          ? _value.shareAmount
          : shareAmount // ignore: cast_nullable_to_non_nullable
              as double,
      isSettled: null == isSettled
          ? _value.isSettled
          : isSettled // ignore: cast_nullable_to_non_nullable
              as bool,
      settledAt: freezed == settledAt
          ? _value.settledAt
          : settledAt // ignore: cast_nullable_to_non_nullable
              as String?,
      settlementId: freezed == settlementId
          ? _value.settlementId
          : settlementId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: '\$createdAt') String? systemCreatedAt,
      @JsonKey(name: '\$updatedAt') String? systemUpdatedAt,
      String userId,
      String groupId,
      String boxId,
      String expenseId,
      double cost,
      bool isPaid,
      String createdAt,
      String? updatedAt,
      String? dueDate,
      String splitType,
      String currency,
      List<String> recipients,
      String status,
      String? recurringId,
      String? notes,
      double shares,
      double sharePercentage,
      double shareAmount,
      bool isSettled,
      String? settledAt,
      String? settlementId});
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
    Object? systemCreatedAt = freezed,
    Object? systemUpdatedAt = freezed,
    Object? userId = null,
    Object? groupId = null,
    Object? boxId = null,
    Object? expenseId = null,
    Object? cost = null,
    Object? isPaid = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? dueDate = freezed,
    Object? splitType = null,
    Object? currency = null,
    Object? recipients = null,
    Object? status = null,
    Object? recurringId = freezed,
    Object? notes = freezed,
    Object? shares = null,
    Object? sharePercentage = null,
    Object? shareAmount = null,
    Object? isSettled = null,
    Object? settledAt = freezed,
    Object? settlementId = freezed,
  }) {
    return _then(_$ExpenseUserModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      systemCreatedAt: freezed == systemCreatedAt
          ? _value.systemCreatedAt
          : systemCreatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      systemUpdatedAt: freezed == systemUpdatedAt
          ? _value.systemUpdatedAt
          : systemUpdatedAt // ignore: cast_nullable_to_non_nullable
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
              as double,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as String?,
      splitType: null == splitType
          ? _value.splitType
          : splitType // ignore: cast_nullable_to_non_nullable
              as String,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      recipients: null == recipients
          ? _value._recipients
          : recipients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      recurringId: freezed == recurringId
          ? _value.recurringId
          : recurringId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      shares: null == shares
          ? _value.shares
          : shares // ignore: cast_nullable_to_non_nullable
              as double,
      sharePercentage: null == sharePercentage
          ? _value.sharePercentage
          : sharePercentage // ignore: cast_nullable_to_non_nullable
              as double,
      shareAmount: null == shareAmount
          ? _value.shareAmount
          : shareAmount // ignore: cast_nullable_to_non_nullable
              as double,
      isSettled: null == isSettled
          ? _value.isSettled
          : isSettled // ignore: cast_nullable_to_non_nullable
              as bool,
      settledAt: freezed == settledAt
          ? _value.settledAt
          : settledAt // ignore: cast_nullable_to_non_nullable
              as String?,
      settlementId: freezed == settlementId
          ? _value.settlementId
          : settlementId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExpenseUserModelImpl implements _ExpenseUserModel {
  const _$ExpenseUserModelImpl(
      {@JsonKey(name: '\$id') this.id,
      @JsonKey(name: '\$createdAt') this.systemCreatedAt,
      @JsonKey(name: '\$updatedAt') this.systemUpdatedAt,
      required this.userId,
      required this.groupId,
      required this.boxId,
      required this.expenseId,
      this.cost = 0,
      this.isPaid = false,
      required this.createdAt,
      this.updatedAt,
      this.dueDate,
      required this.splitType,
      required this.currency,
      required final List<String> recipients,
      required this.status,
      this.recurringId,
      this.notes,
      this.shares = 0,
      this.sharePercentage = 0,
      this.shareAmount = 0,
      this.isSettled = false,
      this.settledAt,
      this.settlementId})
      : _recipients = recipients;

  factory _$ExpenseUserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExpenseUserModelImplFromJson(json);

  @override
  @JsonKey(name: '\$id')
  final String? id;
  @override
  @JsonKey(name: '\$createdAt')
  final String? systemCreatedAt;
  @override
  @JsonKey(name: '\$updatedAt')
  final String? systemUpdatedAt;
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
  final double cost;
  @override
  @JsonKey()
  final bool isPaid;
  @override
  final String createdAt;
  @override
  final String? updatedAt;
  @override
  final String? dueDate;
  @override
  final String splitType;
  @override
  final String currency;
  final List<String> _recipients;
  @override
  List<String> get recipients {
    if (_recipients is EqualUnmodifiableListView) return _recipients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recipients);
  }

  @override
  final String status;
  @override
  final String? recurringId;
  @override
  final String? notes;
  @override
  @JsonKey()
  final double shares;
  @override
  @JsonKey()
  final double sharePercentage;
  @override
  @JsonKey()
  final double shareAmount;
  @override
  @JsonKey()
  final bool isSettled;
  @override
  final String? settledAt;
  @override
  final String? settlementId;

  @override
  String toString() {
    return 'ExpenseUserModel(id: $id, systemCreatedAt: $systemCreatedAt, systemUpdatedAt: $systemUpdatedAt, userId: $userId, groupId: $groupId, boxId: $boxId, expenseId: $expenseId, cost: $cost, isPaid: $isPaid, createdAt: $createdAt, updatedAt: $updatedAt, dueDate: $dueDate, splitType: $splitType, currency: $currency, recipients: $recipients, status: $status, recurringId: $recurringId, notes: $notes, shares: $shares, sharePercentage: $sharePercentage, shareAmount: $shareAmount, isSettled: $isSettled, settledAt: $settledAt, settlementId: $settlementId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseUserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.systemCreatedAt, systemCreatedAt) ||
                other.systemCreatedAt == systemCreatedAt) &&
            (identical(other.systemUpdatedAt, systemUpdatedAt) ||
                other.systemUpdatedAt == systemUpdatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.boxId, boxId) || other.boxId == boxId) &&
            (identical(other.expenseId, expenseId) ||
                other.expenseId == expenseId) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.isPaid, isPaid) || other.isPaid == isPaid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.splitType, splitType) ||
                other.splitType == splitType) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            const DeepCollectionEquality()
                .equals(other._recipients, _recipients) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.recurringId, recurringId) ||
                other.recurringId == recurringId) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.shares, shares) || other.shares == shares) &&
            (identical(other.sharePercentage, sharePercentage) ||
                other.sharePercentage == sharePercentage) &&
            (identical(other.shareAmount, shareAmount) ||
                other.shareAmount == shareAmount) &&
            (identical(other.isSettled, isSettled) ||
                other.isSettled == isSettled) &&
            (identical(other.settledAt, settledAt) ||
                other.settledAt == settledAt) &&
            (identical(other.settlementId, settlementId) ||
                other.settlementId == settlementId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        systemCreatedAt,
        systemUpdatedAt,
        userId,
        groupId,
        boxId,
        expenseId,
        cost,
        isPaid,
        createdAt,
        updatedAt,
        dueDate,
        splitType,
        currency,
        const DeepCollectionEquality().hash(_recipients),
        status,
        recurringId,
        notes,
        shares,
        sharePercentage,
        shareAmount,
        isSettled,
        settledAt,
        settlementId
      ]);

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
      @JsonKey(name: '\$createdAt') final String? systemCreatedAt,
      @JsonKey(name: '\$updatedAt') final String? systemUpdatedAt,
      required final String userId,
      required final String groupId,
      required final String boxId,
      required final String expenseId,
      final double cost,
      final bool isPaid,
      required final String createdAt,
      final String? updatedAt,
      final String? dueDate,
      required final String splitType,
      required final String currency,
      required final List<String> recipients,
      required final String status,
      final String? recurringId,
      final String? notes,
      final double shares,
      final double sharePercentage,
      final double shareAmount,
      final bool isSettled,
      final String? settledAt,
      final String? settlementId}) = _$ExpenseUserModelImpl;

  factory _ExpenseUserModel.fromJson(Map<String, dynamic> json) =
      _$ExpenseUserModelImpl.fromJson;

  @override
  @JsonKey(name: '\$id')
  String? get id;
  @override
  @JsonKey(name: '\$createdAt')
  String? get systemCreatedAt;
  @override
  @JsonKey(name: '\$updatedAt')
  String? get systemUpdatedAt;
  @override
  String get userId;
  @override
  String get groupId;
  @override
  String get boxId;
  @override
  String get expenseId;
  @override
  double get cost;
  @override
  bool get isPaid;
  @override
  String get createdAt;
  @override
  String? get updatedAt;
  @override
  String? get dueDate;
  @override
  String get splitType;
  @override
  String get currency;
  @override
  List<String> get recipients;
  @override
  String get status;
  @override
  String? get recurringId;
  @override
  String? get notes;
  @override
  double get shares;
  @override
  double get sharePercentage;
  @override
  double get shareAmount;
  @override
  bool get isSettled;
  @override
  String? get settledAt;
  @override
  String? get settlementId;

  /// Create a copy of ExpenseUserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExpenseUserModelImplCopyWith<_$ExpenseUserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
