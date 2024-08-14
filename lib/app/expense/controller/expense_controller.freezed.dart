// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExpenseState {
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
    required TResult Function(ExpenseInitState value) init,
    required TResult Function(ExpenseLoadingState value) loading,
    required TResult Function(ExpenseLoadedState value) loaded,
    required TResult Function(ExpenseErrorState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExpenseInitState value)? init,
    TResult? Function(ExpenseLoadingState value)? loading,
    TResult? Function(ExpenseLoadedState value)? loaded,
    TResult? Function(ExpenseErrorState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExpenseInitState value)? init,
    TResult Function(ExpenseLoadingState value)? loading,
    TResult Function(ExpenseLoadedState value)? loaded,
    TResult Function(ExpenseErrorState value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExpenseStateCopyWith<$Res> {
  factory $ExpenseStateCopyWith(
          ExpenseState value, $Res Function(ExpenseState) then) =
      _$ExpenseStateCopyWithImpl<$Res, ExpenseState>;
}

/// @nodoc
class _$ExpenseStateCopyWithImpl<$Res, $Val extends ExpenseState>
    implements $ExpenseStateCopyWith<$Res> {
  _$ExpenseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ExpenseInitStateImplCopyWith<$Res> {
  factory _$$ExpenseInitStateImplCopyWith(_$ExpenseInitStateImpl value,
          $Res Function(_$ExpenseInitStateImpl) then) =
      __$$ExpenseInitStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ExpenseInitStateImplCopyWithImpl<$Res>
    extends _$ExpenseStateCopyWithImpl<$Res, _$ExpenseInitStateImpl>
    implements _$$ExpenseInitStateImplCopyWith<$Res> {
  __$$ExpenseInitStateImplCopyWithImpl(_$ExpenseInitStateImpl _value,
      $Res Function(_$ExpenseInitStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ExpenseInitStateImpl implements ExpenseInitState {
  const _$ExpenseInitStateImpl();

  @override
  String toString() {
    return 'ExpenseState.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ExpenseInitStateImpl);
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
    required TResult Function(ExpenseInitState value) init,
    required TResult Function(ExpenseLoadingState value) loading,
    required TResult Function(ExpenseLoadedState value) loaded,
    required TResult Function(ExpenseErrorState value) error,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExpenseInitState value)? init,
    TResult? Function(ExpenseLoadingState value)? loading,
    TResult? Function(ExpenseLoadedState value)? loaded,
    TResult? Function(ExpenseErrorState value)? error,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExpenseInitState value)? init,
    TResult Function(ExpenseLoadingState value)? loading,
    TResult Function(ExpenseLoadedState value)? loaded,
    TResult Function(ExpenseErrorState value)? error,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class ExpenseInitState implements ExpenseState {
  const factory ExpenseInitState() = _$ExpenseInitStateImpl;
}

/// @nodoc
abstract class _$$ExpenseLoadingStateImplCopyWith<$Res> {
  factory _$$ExpenseLoadingStateImplCopyWith(_$ExpenseLoadingStateImpl value,
          $Res Function(_$ExpenseLoadingStateImpl) then) =
      __$$ExpenseLoadingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ExpenseLoadingStateImplCopyWithImpl<$Res>
    extends _$ExpenseStateCopyWithImpl<$Res, _$ExpenseLoadingStateImpl>
    implements _$$ExpenseLoadingStateImplCopyWith<$Res> {
  __$$ExpenseLoadingStateImplCopyWithImpl(_$ExpenseLoadingStateImpl _value,
      $Res Function(_$ExpenseLoadingStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ExpenseLoadingStateImpl implements ExpenseLoadingState {
  const _$ExpenseLoadingStateImpl();

  @override
  String toString() {
    return 'ExpenseState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseLoadingStateImpl);
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
    required TResult Function(ExpenseInitState value) init,
    required TResult Function(ExpenseLoadingState value) loading,
    required TResult Function(ExpenseLoadedState value) loaded,
    required TResult Function(ExpenseErrorState value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExpenseInitState value)? init,
    TResult? Function(ExpenseLoadingState value)? loading,
    TResult? Function(ExpenseLoadedState value)? loaded,
    TResult? Function(ExpenseErrorState value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExpenseInitState value)? init,
    TResult Function(ExpenseLoadingState value)? loading,
    TResult Function(ExpenseLoadedState value)? loaded,
    TResult Function(ExpenseErrorState value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ExpenseLoadingState implements ExpenseState {
  const factory ExpenseLoadingState() = _$ExpenseLoadingStateImpl;
}

/// @nodoc
abstract class _$$ExpenseLoadedStateImplCopyWith<$Res> {
  factory _$$ExpenseLoadedStateImplCopyWith(_$ExpenseLoadedStateImpl value,
          $Res Function(_$ExpenseLoadedStateImpl) then) =
      __$$ExpenseLoadedStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ExpenseLoadedStateImplCopyWithImpl<$Res>
    extends _$ExpenseStateCopyWithImpl<$Res, _$ExpenseLoadedStateImpl>
    implements _$$ExpenseLoadedStateImplCopyWith<$Res> {
  __$$ExpenseLoadedStateImplCopyWithImpl(_$ExpenseLoadedStateImpl _value,
      $Res Function(_$ExpenseLoadedStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ExpenseLoadedStateImpl implements ExpenseLoadedState {
  const _$ExpenseLoadedStateImpl();

  @override
  String toString() {
    return 'ExpenseState.loaded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ExpenseLoadedStateImpl);
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
    required TResult Function(ExpenseInitState value) init,
    required TResult Function(ExpenseLoadingState value) loading,
    required TResult Function(ExpenseLoadedState value) loaded,
    required TResult Function(ExpenseErrorState value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExpenseInitState value)? init,
    TResult? Function(ExpenseLoadingState value)? loading,
    TResult? Function(ExpenseLoadedState value)? loaded,
    TResult? Function(ExpenseErrorState value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExpenseInitState value)? init,
    TResult Function(ExpenseLoadingState value)? loading,
    TResult Function(ExpenseLoadedState value)? loaded,
    TResult Function(ExpenseErrorState value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ExpenseLoadedState implements ExpenseState {
  const factory ExpenseLoadedState() = _$ExpenseLoadedStateImpl;
}

/// @nodoc
abstract class _$$ExpenseErrorStateImplCopyWith<$Res> {
  factory _$$ExpenseErrorStateImplCopyWith(_$ExpenseErrorStateImpl value,
          $Res Function(_$ExpenseErrorStateImpl) then) =
      __$$ExpenseErrorStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ExpenseErrorStateImplCopyWithImpl<$Res>
    extends _$ExpenseStateCopyWithImpl<$Res, _$ExpenseErrorStateImpl>
    implements _$$ExpenseErrorStateImplCopyWith<$Res> {
  __$$ExpenseErrorStateImplCopyWithImpl(_$ExpenseErrorStateImpl _value,
      $Res Function(_$ExpenseErrorStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ExpenseErrorStateImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ExpenseErrorStateImpl implements ExpenseErrorState {
  const _$ExpenseErrorStateImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'ExpenseState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExpenseErrorStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExpenseErrorStateImplCopyWith<_$ExpenseErrorStateImpl> get copyWith =>
      __$$ExpenseErrorStateImplCopyWithImpl<_$ExpenseErrorStateImpl>(
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
    required TResult Function(ExpenseInitState value) init,
    required TResult Function(ExpenseLoadingState value) loading,
    required TResult Function(ExpenseLoadedState value) loaded,
    required TResult Function(ExpenseErrorState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ExpenseInitState value)? init,
    TResult? Function(ExpenseLoadingState value)? loading,
    TResult? Function(ExpenseLoadedState value)? loaded,
    TResult? Function(ExpenseErrorState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ExpenseInitState value)? init,
    TResult Function(ExpenseLoadingState value)? loading,
    TResult Function(ExpenseLoadedState value)? loaded,
    TResult Function(ExpenseErrorState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ExpenseErrorState implements ExpenseState {
  const factory ExpenseErrorState(final String message) =
      _$ExpenseErrorStateImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ExpenseErrorStateImplCopyWith<_$ExpenseErrorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
