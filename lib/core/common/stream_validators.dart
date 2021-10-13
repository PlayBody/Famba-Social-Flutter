import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

abstract class StreamValidators<T> {
  Stream<T> get stream;

  TextEditingController get textController;

  FocusNode get focusNode;

  FocusNode get nextFocusNode;

  onDispose();

  onChange(String value);

  bool get isEmpty;

  String get text;

  addError(String error);

  bool get obsecureTextBool;

  changeObsecure(bool value);

  bool get isPasswordField;

  get clear => onChange('');
}

class FieldValidators extends StreamValidators {
  final StreamTransformer<String, String> transformer;

  final FocusNode _nextFocusNode;

  final _controller = BehaviorSubject<String>();

  bool obsecureTextBool;

  final bool passwordField;

  TextEditingController _textController = TextEditingController();

  Function(String) get changeData => _controller.sink.add;

  Stream<String> get data => transformer != null
      ? _controller.stream.transform(transformer)
      : _controller.stream;

  FocusNode _focusNode = FocusNode();

  FieldValidators(this.transformer, this._nextFocusNode,
      {this.obsecureTextBool = false, this.passwordField = false});

  @override
  onDispose() {
    _controller.close();
    _textController.dispose();
  }

  @override
  onChange(String value) {
    changeData(value);
  }

  @override
  Stream<String> get stream => data.asBroadcastStream();

  @override
  TextEditingController get textController => _textController;

  @override
  bool get isEmpty => _textController.text.isEmpty;

  void addError(String error) => _controller.sink.addError(error);

  void drain() => _controller.sink.done;

  @override
  String get text => textController.text;

  @override
  FocusNode get focusNode => _focusNode;

  @override
  FocusNode get nextFocusNode => _nextFocusNode;

  bool get obsecureText => obsecureTextBool;

  @override
  changeObsecure(bool value) {
    obsecureTextBool = value;
  }

  @override
  bool get isPasswordField => passwordField;
}

class BoolStreamValidator {
  final boolController = BehaviorSubject<bool>();
  Function(bool) get changeBool => boolController.sink.add;
  Stream<bool> get stream => boolController.stream;

  void dispose() {
    boolController.close();
  }
}
