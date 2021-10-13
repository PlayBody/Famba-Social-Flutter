import 'dart:async';

import '../../extensions.dart';

final validateEmail =
    StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
  if (email.isValidEmail) {
    sink.add(email);
  } else {
    sink.addError('Please enter a valid email');
  }
});

final validateUrl =
    StreamTransformer<String, String>.fromHandlers(handleData: (url, sink) {
  if (urlPattern.hasMatch(url)) {
    sink.add(url);
  } else {
    sink.addError('Please enter a valid url');
  }
});
validatePassword({String errorText = "Choose a password wisely"}) =>
    StreamTransformer<String, String>.fromHandlers(handleData: (string, sink) {
      try {
        print("password lenght" + string.length.toString());
        if (string.isEmpty) {
          sink.add(string);
        } else if (string.length < 8) {
          print("FIRST");
          sink.addError(errorText);
        } else if (nameRegExp.hasMatch(string).not) {
          print("SECOND");
          sink.addError(errorText);
        } else if (numberRegExp.hasMatch(string).not) {
          print("THIRD");
          sink.addError(errorText);
        } else {
          print("FOURTH");
          sink.add(string);
        }
      } catch (e) {
        print("Exceptio:" + e.toString());
      }
    });
StreamTransformer<String, String> notEmptyValidator(FieldType type) =>
    StreamTransformer<String, String>.fromHandlers(handleData: (string, sink) {
      if (string.trim().isNotEmpty) {
        sink.add(string);
      } else {
        switch (type) {
          case FieldType.FIRST_NAME:
            sink.addError("Your first name is missing! Please try again");
            break;
          case FieldType.LAST_NAME:
            sink.addError("Your last name is missing! Please try again");
            break;
          case FieldType.USERNAME:
            sink.addError("You need a username");
            break;
          case FieldType.NOT_EMPTY:
            sink.addError("Must not be empty");
            break;
        }
      }
    });

final phoneValidator =
    StreamTransformer<String, String>.fromHandlers(handleData: (string, sink) {
  if (string.length >= 10) {
    sink.add(string);
  } else {
    sink.addError("Enter a valid phone");
  }
});

confirmPassValidator(Stream<String> password) =>
    StreamTransformer<String, String>.fromHandlers(handleData: (string, sink) {
      String givenPassword;
      password.listen((event) {
        givenPassword = event;
        print(givenPassword);
      });
      print("actual pass" + givenPassword);
      print("c pass" + string);
      if (string.isNotEmpty && string == givenPassword) {
        sink.add(string);
      } else {
        sink.addError("Password Mismatched");
      }
    });
final RegExp nameRegExp = RegExp('[a-zA-Z]');
final RegExp numberRegExp = RegExp(r'\d');
final RegExp urlPattern = RegExp(
  r"(https?|http)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?",
  caseSensitive: false,
);

enum FieldType { FIRST_NAME, LAST_NAME, USERNAME, NOT_EMPTY }
