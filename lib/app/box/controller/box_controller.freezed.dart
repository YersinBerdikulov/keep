// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'box_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BoxState {
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
    required TResult Function(BoxInitState value) init,
    required TResult Function(BoxLoadingState value) loading,
    required TResult Function(BoxLoadedState value) loaded,
    required TResult Function(BoxErrorState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BoxInitState value)? init,
    TResult? Function(BoxLoadingState value)? loading,
    TResult? Function(BoxLoadedState value)? loaded,
    TResult? Function(BoxErrorState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BoxInitState value)? init,
    TResult Function(BoxLoadingState value)? loading,
    TResult Function(BoxLoadedState value)? loaded,
    TResult Function(BoxErrorState value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoxStateCopyWith<$Res> {
  factory $BoxStateCopyWith(BoxState value, $Res Function(BoxState) then) =
      _$BoxStateCopyWithImpl<$Res, BoxState>;
}

/// @nodoc
class _$BoxStateCopyWithImpl<$Res, $Val extends BoxState>
    implements $BoxStateCopyWith<$Res> {
  _$BoxStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$BoxInitStateImplCopyWith<$Res> {
  factory _$$BoxInitStateImplCopyWith(
          _$BoxInitStateImpl value, $Res Function(_$BoxInitStateImpl) then) =
      __$$BoxInitStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BoxInitStateImplCopyWithImpl<$Res>
    extends _$BoxStateCopyWithImpl<$Res, _$BoxInitStateImpl>
    implements _$$BoxInitStateImplCopyWith<$Res> {
  __$$BoxInitStateImplCopyWithImpl(
      _$BoxInitStateImpl _value, $Res Function(_$BoxInitStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$BoxInitStateImpl implements BoxInitState {
  const _$BoxInitStateImpl();

  @override
  String toString() {
    return 'BoxState.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BoxInitStateImpl);
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
    required TResult Function(BoxInitState value) init,
    required TResult Function(BoxLoadingState value) loading,
    required TResult Function(BoxLoadedState value) loaded,
    required TResult Function(BoxErrorState value) error,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BoxInitState value)? init,
    TResult? Function(BoxLoadingState value)? loading,
    TResult? Function(BoxLoadedState value)? loaded,
    TResult? Function(BoxErrorState value)? error,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BoxInitState value)? init,
    TResult Function(BoxLoadingState value)? loading,
    TResult Function(BoxLoadedState value)? loaded,
    TResult Function(BoxErrorState value)? error,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class BoxInitState implements BoxState {
  const factory BoxInitState() = _$BoxInitStateImpl;
}

/// @nodoc
abstract class _$$BoxLoadingStateImplCopyWith<$Res> {
  factory _$$BoxLoadingStateImplCopyWith(_$BoxLoadingStateImpl value,
          $Res Function(_$BoxLoadingStateImpl) then) =
      __$$BoxLoadingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BoxLoadingStateImplCopyWithImpl<$Res>
    extends _$BoxStateCopyWithImpl<$Res, _$BoxLoadingStateImpl>
    implements _$$BoxLoadingStateImplCopyWith<$Res> {
  __$$BoxLoadingStateImplCopyWithImpl(
      _$BoxLoadingStateImpl _value, $Res Function(_$BoxLoadingStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$BoxLoadingStateImpl implements BoxLoadingState {
  const _$BoxLoadingStateImpl();

  @override
  String toString() {
    return 'BoxState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BoxLoadingStateImpl);
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
    required TResult Function(BoxInitState value) init,
    required TResult Function(BoxLoadingState value) loading,
    required TResult Function(BoxLoadedState value) loaded,
    required TResult Function(BoxErrorState value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BoxInitState value)? init,
    TResult? Function(BoxLoadingState value)? loading,
    TResult? Function(BoxLoadedState value)? loaded,
    TResult? Function(BoxErrorState value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BoxInitState value)? init,
    TResult Function(BoxLoadingState value)? loading,
    TResult Function(BoxLoadedState value)? loaded,
    TResult Function(BoxErrorState value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class BoxLoadingState implements BoxState {
  const factory BoxLoadingState() = _$BoxLoadingStateImpl;
}

/// @nodoc
abstract class _$$BoxLoadedStateImplCopyWith<$Res> {
  factory _$$BoxLoadedStateImplCopyWith(_$BoxLoadedStateImpl value,
          $Res Function(_$BoxLoadedStateImpl) then) =
      __$$BoxLoadedStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BoxLoadedStateImplCopyWithImpl<$Res>
    extends _$BoxStateCopyWithImpl<$Res, _$BoxLoadedStateImpl>
    implements _$$BoxLoadedStateImplCopyWith<$Res> {
  __$$BoxLoadedStateImplCopyWithImpl(
      _$BoxLoadedStateImpl _value, $Res Function(_$BoxLoadedStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$BoxLoadedStateImpl implements BoxLoadedState {
  const _$BoxLoadedStateImpl();

  @override
  String toString() {
    return 'BoxState.loaded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BoxLoadedStateImpl);
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
    required TResult Function(BoxInitState value) init,
    required TResult Function(BoxLoadingState value) loading,
    required TResult Function(BoxLoadedState value) loaded,
    required TResult Function(BoxErrorState value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BoxInitState value)? init,
    TResult? Function(BoxLoadingState value)? loading,
    TResult? Function(BoxLoadedState value)? loaded,
    TResult? Function(BoxErrorState value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BoxInitState value)? init,
    TResult Function(BoxLoadingState value)? loading,
    TResult Function(BoxLoadedState value)? loaded,
    TResult Function(BoxErrorState value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class BoxLoadedState implements BoxState {
  const factory BoxLoadedState() = _$BoxLoadedStateImpl;
}

/// @nodoc
abstract class _$$BoxErrorStateImplCopyWith<$Res> {
  factory _$$BoxErrorStateImplCopyWith(
          _$BoxErrorStateImpl value, $Res Function(_$BoxErrorStateImpl) then) =
      __$$BoxErrorStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$BoxErrorStateImplCopyWithImpl<$Res>
    extends _$BoxStateCopyWithImpl<$Res, _$BoxErrorStateImpl>
    implements _$$BoxErrorStateImplCopyWith<$Res> {
  __$$BoxErrorStateImplCopyWithImpl(
      _$BoxErrorStateImpl _value, $Res Function(_$BoxErrorStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$BoxErrorStateImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$BoxErrorStateImpl implements BoxErrorState {
  const _$BoxErrorStateImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'BoxState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoxErrorStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BoxErrorStateImplCopyWith<_$BoxErrorStateImpl> get copyWith =>
      __$$BoxErrorStateImplCopyWithImpl<_$BoxErrorStateImpl>(this, _$identity);

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
    required TResult Function(BoxInitState value) init,
    required TResult Function(BoxLoadingState value) loading,
    required TResult Function(BoxLoadedState value) loaded,
    required TResult Function(BoxErrorState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BoxInitState value)? init,
    TResult? Function(BoxLoadingState value)? loading,
    TResult? Function(BoxLoadedState value)? loaded,
    TResult? Function(BoxErrorState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BoxInitState value)? init,
    TResult Function(BoxLoadingState value)? loading,
    TResult Function(BoxLoadedState value)? loaded,
    TResult Function(BoxErrorState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class BoxErrorState implements BoxState {
  const factory BoxErrorState(final String message) = _$BoxErrorStateImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$BoxErrorStateImplCopyWith<_$BoxErrorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
