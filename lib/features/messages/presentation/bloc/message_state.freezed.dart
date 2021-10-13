// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'message_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$MessageStateTearOff {
  const _$MessageStateTearOff();

// ignore: unused_element
  Initial<T> initial<T>() {
    return Initial<T>();
  }

// ignore: unused_element
  Success<T> success<T>(T value) {
    return Success<T>(
      value,
    );
  }

// ignore: unused_element
  Loading<T> loading<T>() {
    return Loading<T>();
  }

// ignore: unused_element
  NoDataFound<T> noData<T>() {
    return NoDataFound<T>();
  }

// ignore: unused_element
  ErrorDetails<T> error<T>([String message]) {
    return ErrorDetails<T>(
      message,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $MessageState = _$MessageStateTearOff();

/// @nodoc
mixin _$MessageState<T> {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result success(T value),
    @required Result loading(),
    @required Result noData(),
    @required Result error(String message),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result success(T value),
    Result loading(),
    Result noData(),
    Result error(String message),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial<T> value),
    @required Result success(Success<T> value),
    @required Result loading(Loading<T> value),
    @required Result noData(NoDataFound<T> value),
    @required Result error(ErrorDetails<T> value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial<T> value),
    Result success(Success<T> value),
    Result loading(Loading<T> value),
    Result noData(NoDataFound<T> value),
    Result error(ErrorDetails<T> value),
    @required Result orElse(),
  });
}

/// @nodoc
abstract class $MessageStateCopyWith<T, $Res> {
  factory $MessageStateCopyWith(
          MessageState<T> value, $Res Function(MessageState<T>) then) =
      _$MessageStateCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$MessageStateCopyWithImpl<T, $Res>
    implements $MessageStateCopyWith<T, $Res> {
  _$MessageStateCopyWithImpl(this._value, this._then);

  final MessageState<T> _value;
  // ignore: unused_field
  final $Res Function(MessageState<T>) _then;
}

/// @nodoc
abstract class $InitialCopyWith<T, $Res> {
  factory $InitialCopyWith(Initial<T> value, $Res Function(Initial<T>) then) =
      _$InitialCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$InitialCopyWithImpl<T, $Res> extends _$MessageStateCopyWithImpl<T, $Res>
    implements $InitialCopyWith<T, $Res> {
  _$InitialCopyWithImpl(Initial<T> _value, $Res Function(Initial<T>) _then)
      : super(_value, (v) => _then(v as Initial<T>));

  @override
  Initial<T> get _value => super._value as Initial<T>;
}

/// @nodoc
class _$Initial<T> implements Initial<T> {
  const _$Initial();

  @override
  String toString() {
    return 'MessageState<$T>.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Initial<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result success(T value),
    @required Result loading(),
    @required Result noData(),
    @required Result error(String message),
  }) {
    assert(initial != null);
    assert(success != null);
    assert(loading != null);
    assert(noData != null);
    assert(error != null);
    return initial();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result success(T value),
    Result loading(),
    Result noData(),
    Result error(String message),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial<T> value),
    @required Result success(Success<T> value),
    @required Result loading(Loading<T> value),
    @required Result noData(NoDataFound<T> value),
    @required Result error(ErrorDetails<T> value),
  }) {
    assert(initial != null);
    assert(success != null);
    assert(loading != null);
    assert(noData != null);
    assert(error != null);
    return initial(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial<T> value),
    Result success(Success<T> value),
    Result loading(Loading<T> value),
    Result noData(NoDataFound<T> value),
    Result error(ErrorDetails<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class Initial<T> implements MessageState<T> {
  const factory Initial() = _$Initial<T>;
}

/// @nodoc
abstract class $SuccessCopyWith<T, $Res> {
  factory $SuccessCopyWith(Success<T> value, $Res Function(Success<T>) then) =
      _$SuccessCopyWithImpl<T, $Res>;
  $Res call({T value});
}

/// @nodoc
class _$SuccessCopyWithImpl<T, $Res> extends _$MessageStateCopyWithImpl<T, $Res>
    implements $SuccessCopyWith<T, $Res> {
  _$SuccessCopyWithImpl(Success<T> _value, $Res Function(Success<T>) _then)
      : super(_value, (v) => _then(v as Success<T>));

  @override
  Success<T> get _value => super._value as Success<T>;

  @override
  $Res call({
    Object value = freezed,
  }) {
    return _then(Success<T>(
      value == freezed ? _value.value : value as T,
    ));
  }
}

/// @nodoc
class _$Success<T> implements Success<T> {
  const _$Success(this.value) : assert(value != null);

  @override
  final T value;

  @override
  String toString() {
    return 'MessageState<$T>.success(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Success<T> &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(value);

  @override
  $SuccessCopyWith<T, Success<T>> get copyWith =>
      _$SuccessCopyWithImpl<T, Success<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result success(T value),
    @required Result loading(),
    @required Result noData(),
    @required Result error(String message),
  }) {
    assert(initial != null);
    assert(success != null);
    assert(loading != null);
    assert(noData != null);
    assert(error != null);
    return success(value);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result success(T value),
    Result loading(),
    Result noData(),
    Result error(String message),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (success != null) {
      return success(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial<T> value),
    @required Result success(Success<T> value),
    @required Result loading(Loading<T> value),
    @required Result noData(NoDataFound<T> value),
    @required Result error(ErrorDetails<T> value),
  }) {
    assert(initial != null);
    assert(success != null);
    assert(loading != null);
    assert(noData != null);
    assert(error != null);
    return success(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial<T> value),
    Result success(Success<T> value),
    Result loading(Loading<T> value),
    Result noData(NoDataFound<T> value),
    Result error(ErrorDetails<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class Success<T> implements MessageState<T> {
  const factory Success(T value) = _$Success<T>;

  T get value;
  $SuccessCopyWith<T, Success<T>> get copyWith;
}

/// @nodoc
abstract class $LoadingCopyWith<T, $Res> {
  factory $LoadingCopyWith(Loading<T> value, $Res Function(Loading<T>) then) =
      _$LoadingCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$LoadingCopyWithImpl<T, $Res> extends _$MessageStateCopyWithImpl<T, $Res>
    implements $LoadingCopyWith<T, $Res> {
  _$LoadingCopyWithImpl(Loading<T> _value, $Res Function(Loading<T>) _then)
      : super(_value, (v) => _then(v as Loading<T>));

  @override
  Loading<T> get _value => super._value as Loading<T>;
}

/// @nodoc
class _$Loading<T> implements Loading<T> {
  const _$Loading();

  @override
  String toString() {
    return 'MessageState<$T>.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is Loading<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result success(T value),
    @required Result loading(),
    @required Result noData(),
    @required Result error(String message),
  }) {
    assert(initial != null);
    assert(success != null);
    assert(loading != null);
    assert(noData != null);
    assert(error != null);
    return loading();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result success(T value),
    Result loading(),
    Result noData(),
    Result error(String message),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial<T> value),
    @required Result success(Success<T> value),
    @required Result loading(Loading<T> value),
    @required Result noData(NoDataFound<T> value),
    @required Result error(ErrorDetails<T> value),
  }) {
    assert(initial != null);
    assert(success != null);
    assert(loading != null);
    assert(noData != null);
    assert(error != null);
    return loading(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial<T> value),
    Result success(Success<T> value),
    Result loading(Loading<T> value),
    Result noData(NoDataFound<T> value),
    Result error(ErrorDetails<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading<T> implements MessageState<T> {
  const factory Loading() = _$Loading<T>;
}

/// @nodoc
abstract class $NoDataFoundCopyWith<T, $Res> {
  factory $NoDataFoundCopyWith(
          NoDataFound<T> value, $Res Function(NoDataFound<T>) then) =
      _$NoDataFoundCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$NoDataFoundCopyWithImpl<T, $Res>
    extends _$MessageStateCopyWithImpl<T, $Res>
    implements $NoDataFoundCopyWith<T, $Res> {
  _$NoDataFoundCopyWithImpl(
      NoDataFound<T> _value, $Res Function(NoDataFound<T>) _then)
      : super(_value, (v) => _then(v as NoDataFound<T>));

  @override
  NoDataFound<T> get _value => super._value as NoDataFound<T>;
}

/// @nodoc
class _$NoDataFound<T> implements NoDataFound<T> {
  const _$NoDataFound();

  @override
  String toString() {
    return 'MessageState<$T>.noData()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is NoDataFound<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result success(T value),
    @required Result loading(),
    @required Result noData(),
    @required Result error(String message),
  }) {
    assert(initial != null);
    assert(success != null);
    assert(loading != null);
    assert(noData != null);
    assert(error != null);
    return noData();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result success(T value),
    Result loading(),
    Result noData(),
    Result error(String message),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (noData != null) {
      return noData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial<T> value),
    @required Result success(Success<T> value),
    @required Result loading(Loading<T> value),
    @required Result noData(NoDataFound<T> value),
    @required Result error(ErrorDetails<T> value),
  }) {
    assert(initial != null);
    assert(success != null);
    assert(loading != null);
    assert(noData != null);
    assert(error != null);
    return noData(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial<T> value),
    Result success(Success<T> value),
    Result loading(Loading<T> value),
    Result noData(NoDataFound<T> value),
    Result error(ErrorDetails<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (noData != null) {
      return noData(this);
    }
    return orElse();
  }
}

abstract class NoDataFound<T> implements MessageState<T> {
  const factory NoDataFound() = _$NoDataFound<T>;
}

/// @nodoc
abstract class $ErrorDetailsCopyWith<T, $Res> {
  factory $ErrorDetailsCopyWith(
          ErrorDetails<T> value, $Res Function(ErrorDetails<T>) then) =
      _$ErrorDetailsCopyWithImpl<T, $Res>;
  $Res call({String message});
}

/// @nodoc
class _$ErrorDetailsCopyWithImpl<T, $Res>
    extends _$MessageStateCopyWithImpl<T, $Res>
    implements $ErrorDetailsCopyWith<T, $Res> {
  _$ErrorDetailsCopyWithImpl(
      ErrorDetails<T> _value, $Res Function(ErrorDetails<T>) _then)
      : super(_value, (v) => _then(v as ErrorDetails<T>));

  @override
  ErrorDetails<T> get _value => super._value as ErrorDetails<T>;

  @override
  $Res call({
    Object message = freezed,
  }) {
    return _then(ErrorDetails<T>(
      message == freezed ? _value.message : message as String,
    ));
  }
}

/// @nodoc
class _$ErrorDetails<T> implements ErrorDetails<T> {
  const _$ErrorDetails([this.message]);

  @override
  final String message;

  @override
  String toString() {
    return 'MessageState<$T>.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ErrorDetails<T> &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(message);

  @override
  $ErrorDetailsCopyWith<T, ErrorDetails<T>> get copyWith =>
      _$ErrorDetailsCopyWithImpl<T, ErrorDetails<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result initial(),
    @required Result success(T value),
    @required Result loading(),
    @required Result noData(),
    @required Result error(String message),
  }) {
    assert(initial != null);
    assert(success != null);
    assert(loading != null);
    assert(noData != null);
    assert(error != null);
    return error(message);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result initial(),
    Result success(T value),
    Result loading(),
    Result noData(),
    Result error(String message),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result initial(Initial<T> value),
    @required Result success(Success<T> value),
    @required Result loading(Loading<T> value),
    @required Result noData(NoDataFound<T> value),
    @required Result error(ErrorDetails<T> value),
  }) {
    assert(initial != null);
    assert(success != null);
    assert(loading != null);
    assert(noData != null);
    assert(error != null);
    return error(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result initial(Initial<T> value),
    Result success(Success<T> value),
    Result loading(Loading<T> value),
    Result noData(NoDataFound<T> value),
    Result error(ErrorDetails<T> value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ErrorDetails<T> implements MessageState<T> {
  const factory ErrorDetails([String message]) = _$ErrorDetails<T>;

  String get message;
  $ErrorDetailsCopyWith<T, ErrorDetails<T>> get copyWith;
}
