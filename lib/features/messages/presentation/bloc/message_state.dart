import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_state.freezed.dart';

@freezed
abstract class MessageState<T> with _$MessageState<T> {
  const factory MessageState.initial() = Initial<T>;
  const factory MessageState.success(T value) = Success<T>;
  const factory MessageState.loading() = Loading<T>;
  const factory MessageState.noData() = NoDataFound<T>;
  const factory MessageState.error([String message]) = ErrorDetails<T>;
}
