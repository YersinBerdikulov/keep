// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_in_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SignInState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(bool isGoogle) loading,
    required TResult Function() loaded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(bool isGoogle)? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(bool isGoogle)? loading,
    TResult Function()? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignInInitState value) init,
    required TResult Function(SignInLoadingState value) loading,
    required TResult Function(SignInLoadedState value) loaded,
    required TResult Function(SignInErrorState value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInInitState value)? init,
    TResult? Function(SignInLoadingState value)? loading,
    TResult? Function(SignInLoadedState value)? loaded,
    TResult? Function(SignInErrorState value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInInitState value)? init,
    TResult Function(SignInLoadingState value)? loading,
    TResult Function(SignInLoadedState value)? loaded,
    TResult Function(SignInErrorState value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignInStateCopyWith<$Res> {
  factory $SignInStateCopyWith(
          SignInState value, $Res Function(SignInState) then) =
      _$SignInStateCopyWithImpl<$Res, SignInState>;
}

/// @nodoc
class _$SignInStateCopyWithImpl<$Res, $Val extends SignInState>
    implements $SignInStateCopyWith<$Res> {
  _$SignInStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SignInInitStateImplCopyWith<$Res> {
  factory _$$SignInInitStateImplCopyWith(_$SignInInitStateImpl value,
          $Res Function(_$SignInInitStateImpl) then) =
      __$$SignInInitStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignInInitStateImplCopyWithImpl<$Res>
    extends _$SignInStateCopyWithImpl<$Res, _$SignInInitStateImpl>
    implements _$$SignInInitStateImplCopyWith<$Res> {
  __$$SignInInitStateImplCopyWithImpl(
      _$SignInInitStateImpl _value, $Res Function(_$SignInInitStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SignInInitStateImpl implements SignInInitState {
  const _$SignInInitStateImpl();

  @override
  String toString() {
    return 'SignInState.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignInInitStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(bool isGoogle) loading,
    required TResult Function() loaded,
    required TResult Function(String message) error,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(bool isGoogle)? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? error,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(bool isGoogle)? loading,
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
    required TResult Function(SignInInitState value) init,
    required TResult Function(SignInLoadingState value) loading,
    required TResult Function(SignInLoadedState value) loaded,
    required TResult Function(SignInErrorState value) error,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInInitState value)? init,
    TResult? Function(SignInLoadingState value)? loading,
    TResult? Function(SignInLoadedState value)? loaded,
    TResult? Function(SignInErrorState value)? error,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInInitState value)? init,
    TResult Function(SignInLoadingState value)? loading,
    TResult Function(SignInLoadedState value)? loaded,
    TResult Function(SignInErrorState value)? error,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class SignInInitState implements SignInState {
  const factory SignInInitState() = _$SignInInitStateImpl;
}

/// @nodoc
abstract class _$$SignInLoadingStateImplCopyWith<$Res> {
  factory _$$SignInLoadingStateImplCopyWith(_$SignInLoadingStateImpl value,
          $Res Function(_$SignInLoadingStateImpl) then) =
      __$$SignInLoadingStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool isGoogle});
}

/// @nodoc
class __$$SignInLoadingStateImplCopyWithImpl<$Res>
    extends _$SignInStateCopyWithImpl<$Res, _$SignInLoadingStateImpl>
    implements _$$SignInLoadingStateImplCopyWith<$Res> {
  __$$SignInLoadingStateImplCopyWithImpl(_$SignInLoadingStateImpl _value,
      $Res Function(_$SignInLoadingStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isGoogle = null,
  }) {
    return _then(_$SignInLoadingStateImpl(
      isGoogle: null == isGoogle
          ? _value.isGoogle
          : isGoogle // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SignInLoadingStateImpl implements SignInLoadingState {
  const _$SignInLoadingStateImpl({this.isGoogle = false});

  @override
  @JsonKey()
  final bool isGoogle;

  @override
  String toString() {
    return 'SignInState.loading(isGoogle: $isGoogle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInLoadingStateImpl &&
            (identical(other.isGoogle, isGoogle) ||
                other.isGoogle == isGoogle));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isGoogle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignInLoadingStateImplCopyWith<_$SignInLoadingStateImpl> get copyWith =>
      __$$SignInLoadingStateImplCopyWithImpl<_$SignInLoadingStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(bool isGoogle) loading,
    required TResult Function() loaded,
    required TResult Function(String message) error,
  }) {
    return loading(isGoogle);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(bool isGoogle)? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call(isGoogle);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(bool isGoogle)? loading,
    TResult Function()? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(isGoogle);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SignInInitState value) init,
    required TResult Function(SignInLoadingState value) loading,
    required TResult Function(SignInLoadedState value) loaded,
    required TResult Function(SignInErrorState value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInInitState value)? init,
    TResult? Function(SignInLoadingState value)? loading,
    TResult? Function(SignInLoadedState value)? loaded,
    TResult? Function(SignInErrorState value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInInitState value)? init,
    TResult Function(SignInLoadingState value)? loading,
    TResult Function(SignInLoadedState value)? loaded,
    TResult Function(SignInErrorState value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SignInLoadingState implements SignInState {
  const factory SignInLoadingState({final bool isGoogle}) =
      _$SignInLoadingStateImpl;

  bool get isGoogle;
  @JsonKey(ignore: true)
  _$$SignInLoadingStateImplCopyWith<_$SignInLoadingStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SignInLoadedStateImplCopyWith<$Res> {
  factory _$$SignInLoadedStateImplCopyWith(_$SignInLoadedStateImpl value,
          $Res Function(_$SignInLoadedStateImpl) then) =
      __$$SignInLoadedStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignInLoadedStateImplCopyWithImpl<$Res>
    extends _$SignInStateCopyWithImpl<$Res, _$SignInLoadedStateImpl>
    implements _$$SignInLoadedStateImplCopyWith<$Res> {
  __$$SignInLoadedStateImplCopyWithImpl(_$SignInLoadedStateImpl _value,
      $Res Function(_$SignInLoadedStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SignInLoadedStateImpl implements SignInLoadedState {
  const _$SignInLoadedStateImpl();

  @override
  String toString() {
    return 'SignInState.loaded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignInLoadedStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(bool isGoogle) loading,
    required TResult Function() loaded,
    required TResult Function(String message) error,
  }) {
    return loaded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(bool isGoogle)? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(bool isGoogle)? loading,
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
    required TResult Function(SignInInitState value) init,
    required TResult Function(SignInLoadingState value) loading,
    required TResult Function(SignInLoadedState value) loaded,
    required TResult Function(SignInErrorState value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInInitState value)? init,
    TResult? Function(SignInLoadingState value)? loading,
    TResult? Function(SignInLoadedState value)? loaded,
    TResult? Function(SignInErrorState value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInInitState value)? init,
    TResult Function(SignInLoadingState value)? loading,
    TResult Function(SignInLoadedState value)? loaded,
    TResult Function(SignInErrorState value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class SignInLoadedState implements SignInState {
  const factory SignInLoadedState() = _$SignInLoadedStateImpl;
}

/// @nodoc
abstract class _$$SignInErrorStateImplCopyWith<$Res> {
  factory _$$SignInErrorStateImplCopyWith(_$SignInErrorStateImpl value,
          $Res Function(_$SignInErrorStateImpl) then) =
      __$$SignInErrorStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SignInErrorStateImplCopyWithImpl<$Res>
    extends _$SignInStateCopyWithImpl<$Res, _$SignInErrorStateImpl>
    implements _$$SignInErrorStateImplCopyWith<$Res> {
  __$$SignInErrorStateImplCopyWithImpl(_$SignInErrorStateImpl _value,
      $Res Function(_$SignInErrorStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SignInErrorStateImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SignInErrorStateImpl implements SignInErrorState {
  const _$SignInErrorStateImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SignInState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignInErrorStateImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignInErrorStateImplCopyWith<_$SignInErrorStateImpl> get copyWith =>
      __$$SignInErrorStateImplCopyWithImpl<_$SignInErrorStateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function(bool isGoogle) loading,
    required TResult Function() loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function(bool isGoogle)? loading,
    TResult? Function()? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function(bool isGoogle)? loading,
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
    required TResult Function(SignInInitState value) init,
    required TResult Function(SignInLoadingState value) loading,
    required TResult Function(SignInLoadedState value) loaded,
    required TResult Function(SignInErrorState value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SignInInitState value)? init,
    TResult? Function(SignInLoadingState value)? loading,
    TResult? Function(SignInLoadedState value)? loaded,
    TResult? Function(SignInErrorState value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SignInInitState value)? init,
    TResult Function(SignInLoadingState value)? loading,
    TResult Function(SignInLoadedState value)? loaded,
    TResult Function(SignInErrorState value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SignInErrorState implements SignInState {
  const factory SignInErrorState(final String message) = _$SignInErrorStateImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$SignInErrorStateImplCopyWith<_$SignInErrorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
