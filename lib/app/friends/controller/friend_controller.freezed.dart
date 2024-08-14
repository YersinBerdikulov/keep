// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FriendState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function() loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function()? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FriendInitState value) init,
    required TResult Function(FriendLoadingState value) loading,
    required TResult Function(FriendLoadedState value) loaded,
    required TResult Function(FriendErrorState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FriendInitState value)? init,
    TResult? Function(FriendLoadingState value)? loading,
    TResult? Function(FriendLoadedState value)? loaded,
    TResult? Function(FriendErrorState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FriendInitState value)? init,
    TResult Function(FriendLoadingState value)? loading,
    TResult Function(FriendLoadedState value)? loaded,
    TResult Function(FriendErrorState value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendStateCopyWith<$Res> {
  factory $FriendStateCopyWith(
          FriendState value, $Res Function(FriendState) then) =
      _$FriendStateCopyWithImpl<$Res, FriendState>;
}

/// @nodoc
class _$FriendStateCopyWithImpl<$Res, $Val extends FriendState>
    implements $FriendStateCopyWith<$Res> {
  _$FriendStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$FriendInitStateImplCopyWith<$Res> {
  factory _$$FriendInitStateImplCopyWith(_$FriendInitStateImpl value,
          $Res Function(_$FriendInitStateImpl) then) =
      __$$FriendInitStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FriendInitStateImplCopyWithImpl<$Res>
    extends _$FriendStateCopyWithImpl<$Res, _$FriendInitStateImpl>
    implements _$$FriendInitStateImplCopyWith<$Res> {
  __$$FriendInitStateImplCopyWithImpl(
      _$FriendInitStateImpl _value, $Res Function(_$FriendInitStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$FriendInitStateImpl implements FriendInitState {
  const _$FriendInitStateImpl();

  @override
  String toString() {
    return 'FriendState.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FriendInitStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function() loaded,
    required TResult Function(String message) error,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? error,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function()? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FriendInitState value) init,
    required TResult Function(FriendLoadingState value) loading,
    required TResult Function(FriendLoadedState value) loaded,
    required TResult Function(FriendErrorState value) error,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FriendInitState value)? init,
    TResult? Function(FriendLoadingState value)? loading,
    TResult? Function(FriendLoadedState value)? loaded,
    TResult? Function(FriendErrorState value)? error,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FriendInitState value)? init,
    TResult Function(FriendLoadingState value)? loading,
    TResult Function(FriendLoadedState value)? loaded,
    TResult Function(FriendErrorState value)? error,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class FriendInitState implements FriendState {
  const factory FriendInitState() = _$FriendInitStateImpl;
}

/// @nodoc
abstract class _$$FriendLoadingStateImplCopyWith<$Res> {
  factory _$$FriendLoadingStateImplCopyWith(_$FriendLoadingStateImpl value,
          $Res Function(_$FriendLoadingStateImpl) then) =
      __$$FriendLoadingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FriendLoadingStateImplCopyWithImpl<$Res>
    extends _$FriendStateCopyWithImpl<$Res, _$FriendLoadingStateImpl>
    implements _$$FriendLoadingStateImplCopyWith<$Res> {
  __$$FriendLoadingStateImplCopyWithImpl(_$FriendLoadingStateImpl _value,
      $Res Function(_$FriendLoadingStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$FriendLoadingStateImpl implements FriendLoadingState {
  const _$FriendLoadingStateImpl();

  @override
  String toString() {
    return 'FriendState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FriendLoadingStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function() loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function()? loaded,
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
    required TResult Function(FriendInitState value) init,
    required TResult Function(FriendLoadingState value) loading,
    required TResult Function(FriendLoadedState value) loaded,
    required TResult Function(FriendErrorState value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FriendInitState value)? init,
    TResult? Function(FriendLoadingState value)? loading,
    TResult? Function(FriendLoadedState value)? loaded,
    TResult? Function(FriendErrorState value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FriendInitState value)? init,
    TResult Function(FriendLoadingState value)? loading,
    TResult Function(FriendLoadedState value)? loaded,
    TResult Function(FriendErrorState value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class FriendLoadingState implements FriendState {
  const factory FriendLoadingState() = _$FriendLoadingStateImpl;
}

/// @nodoc
abstract class _$$FriendLoadedStateImplCopyWith<$Res> {
  factory _$$FriendLoadedStateImplCopyWith(_$FriendLoadedStateImpl value,
          $Res Function(_$FriendLoadedStateImpl) then) =
      __$$FriendLoadedStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FriendLoadedStateImplCopyWithImpl<$Res>
    extends _$FriendStateCopyWithImpl<$Res, _$FriendLoadedStateImpl>
    implements _$$FriendLoadedStateImplCopyWith<$Res> {
  __$$FriendLoadedStateImplCopyWithImpl(_$FriendLoadedStateImpl _value,
      $Res Function(_$FriendLoadedStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$FriendLoadedStateImpl implements FriendLoadedState {
  const _$FriendLoadedStateImpl();

  @override
  String toString() {
    return 'FriendState.loaded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$FriendLoadedStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function() loaded,
    required TResult Function(String message) error,
  }) {
    return loaded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function()? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FriendInitState value) init,
    required TResult Function(FriendLoadingState value) loading,
    required TResult Function(FriendLoadedState value) loaded,
    required TResult Function(FriendErrorState value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FriendInitState value)? init,
    TResult? Function(FriendLoadingState value)? loading,
    TResult? Function(FriendLoadedState value)? loaded,
    TResult? Function(FriendErrorState value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FriendInitState value)? init,
    TResult Function(FriendLoadingState value)? loading,
    TResult Function(FriendLoadedState value)? loaded,
    TResult Function(FriendErrorState value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class FriendLoadedState implements FriendState {
  const factory FriendLoadedState() = _$FriendLoadedStateImpl;
}

/// @nodoc
abstract class _$$FriendErrorStateImplCopyWith<$Res> {
  factory _$$FriendErrorStateImplCopyWith(_$FriendErrorStateImpl value,
          $Res Function(_$FriendErrorStateImpl) then) =
      __$$FriendErrorStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FriendErrorStateImplCopyWithImpl<$Res>
    extends _$FriendStateCopyWithImpl<$Res, _$FriendErrorStateImpl>
    implements _$$FriendErrorStateImplCopyWith<$Res> {
  __$$FriendErrorStateImplCopyWithImpl(_$FriendErrorStateImpl _value,
      $Res Function(_$FriendErrorStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$FriendErrorStateImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FriendErrorStateImpl implements FriendErrorState {
  const _$FriendErrorStateImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'FriendState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendErrorStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendErrorStateImplCopyWith<_$FriendErrorStateImpl> get copyWith =>
      __$$FriendErrorStateImplCopyWithImpl<_$FriendErrorStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() loading,
    required TResult Function() loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? loading,
    TResult Function()? loaded,
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
    required TResult Function(FriendInitState value) init,
    required TResult Function(FriendLoadingState value) loading,
    required TResult Function(FriendLoadedState value) loaded,
    required TResult Function(FriendErrorState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FriendInitState value)? init,
    TResult? Function(FriendLoadingState value)? loading,
    TResult? Function(FriendLoadedState value)? loaded,
    TResult? Function(FriendErrorState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FriendInitState value)? init,
    TResult Function(FriendLoadingState value)? loading,
    TResult Function(FriendLoadedState value)? loaded,
    TResult Function(FriendErrorState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class FriendErrorState implements FriendState {
  const factory FriendErrorState(final String message) = _$FriendErrorStateImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$FriendErrorStateImplCopyWith<_$FriendErrorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
