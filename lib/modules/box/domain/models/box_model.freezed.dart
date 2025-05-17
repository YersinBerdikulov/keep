// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'box_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BoxModel _$BoxModelFromJson(Map<String, dynamic> json) {
  return _BoxModel.fromJson(json);
}

/// @nodoc
mixin _$BoxModel {
  @JsonKey(name: '\$id')
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: '\$createdAt')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: '\$updatedAt')
  String? get updatedAt => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String get groupId => throw _privateConstructorUsedError;
  List<String> get boxUsers => throw _privateConstructorUsedError;
  List<String> get expenseIds => throw _privateConstructorUsedError;
  num get total => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get creatorId => throw _privateConstructorUsedError;

  /// Serializes this BoxModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BoxModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoxModelCopyWith<BoxModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoxModelCopyWith<$Res> {
  factory $BoxModelCopyWith(BoxModel value, $Res Function(BoxModel) then) =
      _$BoxModelCopyWithImpl<$Res, BoxModel>;
  @useResult
  $Res call(
      {@JsonKey(name: '\$id') String? id,
      @JsonKey(name: '\$createdAt') String? createdAt,
      @JsonKey(name: '\$updatedAt') String? updatedAt,
      String title,
      String? description,
      String? image,
      String groupId,
      List<String> boxUsers,
      List<String> expenseIds,
      num total,
      String currency,
      String creatorId});
}

/// @nodoc
class _$BoxModelCopyWithImpl<$Res, $Val extends BoxModel>
    implements $BoxModelCopyWith<$Res> {
  _$BoxModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BoxModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? image = freezed,
    Object? groupId = null,
    Object? boxUsers = null,
    Object? expenseIds = null,
    Object? total = null,
    Object? currency = null,
    Object? creatorId = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      boxUsers: null == boxUsers
          ? _value.boxUsers
          : boxUsers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      expenseIds: null == expenseIds
          ? _value.expenseIds
          : expenseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as num,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BoxModelImplCopyWith<$Res>
    implements $BoxModelCopyWith<$Res> {
  factory _$$BoxModelImplCopyWith(
          _$BoxModelImpl value, $Res Function(_$BoxModelImpl) then) =
      __$$BoxModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '\$id') String? id,
      @JsonKey(name: '\$createdAt') String? createdAt,
      @JsonKey(name: '\$updatedAt') String? updatedAt,
      String title,
      String? description,
      String? image,
      String groupId,
      List<String> boxUsers,
      List<String> expenseIds,
      num total,
      String currency,
      String creatorId});
}

/// @nodoc
class __$$BoxModelImplCopyWithImpl<$Res>
    extends _$BoxModelCopyWithImpl<$Res, _$BoxModelImpl>
    implements _$$BoxModelImplCopyWith<$Res> {
  __$$BoxModelImplCopyWithImpl(
      _$BoxModelImpl _value, $Res Function(_$BoxModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BoxModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? title = null,
    Object? description = freezed,
    Object? image = freezed,
    Object? groupId = null,
    Object? boxUsers = null,
    Object? expenseIds = null,
    Object? total = null,
    Object? currency = null,
    Object? creatorId = null,
  }) {
    return _then(_$BoxModelImpl(
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      boxUsers: null == boxUsers
          ? _value._boxUsers
          : boxUsers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      expenseIds: null == expenseIds
          ? _value._expenseIds
          : expenseIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as num,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      creatorId: null == creatorId
          ? _value.creatorId
          : creatorId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BoxModelImpl implements _BoxModel {
  const _$BoxModelImpl(
      {@JsonKey(name: '\$id') this.id,
      @JsonKey(name: '\$createdAt') this.createdAt,
      @JsonKey(name: '\$updatedAt') this.updatedAt,
      required this.title,
      this.description,
      this.image,
      required this.groupId,
      final List<String> boxUsers = const [],
      final List<String> expenseIds = const [],
      this.total = 0,
      this.currency = "KZT",
      required this.creatorId})
      : _boxUsers = boxUsers,
        _expenseIds = expenseIds;

  factory _$BoxModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoxModelImplFromJson(json);

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
  final String title;
  @override
  final String? description;
  @override
  final String? image;
  @override
  final String groupId;
  final List<String> _boxUsers;
  @override
  @JsonKey()
  List<String> get boxUsers {
    if (_boxUsers is EqualUnmodifiableListView) return _boxUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_boxUsers);
  }

  final List<String> _expenseIds;
  @override
  @JsonKey()
  List<String> get expenseIds {
    if (_expenseIds is EqualUnmodifiableListView) return _expenseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_expenseIds);
  }

  @override
  @JsonKey()
  final num total;
  @override
  @JsonKey()
  final String currency;
  @override
  final String creatorId;

  @override
  String toString() {
    return 'BoxModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, description: $description, image: $image, groupId: $groupId, boxUsers: $boxUsers, expenseIds: $expenseIds, total: $total, currency: $currency, creatorId: $creatorId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoxModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            const DeepCollectionEquality().equals(other._boxUsers, _boxUsers) &&
            const DeepCollectionEquality()
                .equals(other._expenseIds, _expenseIds) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.creatorId, creatorId) ||
                other.creatorId == creatorId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      updatedAt,
      title,
      description,
      image,
      groupId,
      const DeepCollectionEquality().hash(_boxUsers),
      const DeepCollectionEquality().hash(_expenseIds),
      total,
      currency,
      creatorId);

  /// Create a copy of BoxModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoxModelImplCopyWith<_$BoxModelImpl> get copyWith =>
      __$$BoxModelImplCopyWithImpl<_$BoxModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoxModelImplToJson(
      this,
    );
  }
}

abstract class _BoxModel implements BoxModel {
  const factory _BoxModel(
      {@JsonKey(name: '\$id') final String? id,
      @JsonKey(name: '\$createdAt') final String? createdAt,
      @JsonKey(name: '\$updatedAt') final String? updatedAt,
      required final String title,
      final String? description,
      final String? image,
      required final String groupId,
      final List<String> boxUsers,
      final List<String> expenseIds,
      final num total,
      final String currency,
      required final String creatorId}) = _$BoxModelImpl;

  factory _BoxModel.fromJson(Map<String, dynamic> json) =
      _$BoxModelImpl.fromJson;

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
  String get title;
  @override
  String? get description;
  @override
  String? get image;
  @override
  String get groupId;
  @override
  List<String> get boxUsers;
  @override
  List<String> get expenseIds;
  @override
  num get total;
  @override
  String get currency;
  @override
  String get creatorId;

  /// Create a copy of BoxModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoxModelImplCopyWith<_$BoxModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
