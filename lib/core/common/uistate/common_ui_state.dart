import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'common_ui_state.freezed.dart';

@freezed
abstract class CommonUIState<T> with _$CommonUIState<T> {
  const factory CommonUIState.initial() = Initial<T>;
  const factory CommonUIState.success(T value) = Success<T>;
  const factory CommonUIState.loading() = Loading<T>;
  const factory CommonUIState.error([String message]) = ErrorDetails<T>;
}
