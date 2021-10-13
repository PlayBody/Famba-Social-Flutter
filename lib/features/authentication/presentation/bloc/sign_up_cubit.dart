import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import '../../../../core/common/stream_validators.dart';
import '../../../../core/common/uistate/common_ui_state.dart';
import '../../../../core/common/validators.dart';
import '../../domain/usecase/sign_up_case.dart';
import '../../domain/usecase/social_login_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'sign_up_state.dart';

@injectable
class SignUpCubit extends Cubit<CommonUIState> {
  FieldValidators emailValidator;

  FieldValidators firstNameValidator;

  FieldValidators userNameValidator;

  FieldValidators lastNameValidator;

  FieldValidators passwordValidator;

  FieldValidators confirmPasswordValidator;

  // page view controller for sign up ui
  final currentPageController = BehaviorSubject<int>.seeded(0);
  Function(int) get changeCurrentPage => currentPageController.sink.add;
  Stream<int> get currentPage => currentPageController.stream;

  // agree terms and conditions

  final agreeTermsController = BehaviorSubject<bool>.seeded(true);
  Function(bool) get changeAgreeTerms => agreeTermsController.sink.add;
  Stream<bool> get agreeTerms => agreeTermsController.stream;

  Stream<bool> get isFirstStepValid => Rx.combineLatest3(
      firstNameValidator.stream,
      lastNameValidator.stream,
      userNameValidator.stream,
      (a, b, c) => true);
  // Stream<bool> get isSecondStepValid=> Rx.combineLatest3(firstNameValidator.stream, lastNameValidator.stream, userNameValidator.stream, (a, b, c) => true);
  Stream<bool> get validForm => Rx.combineLatest7<String, String, String,
          String, String, String, bool, bool>(
      emailValidator.stream,
      firstNameValidator.stream,
      userNameValidator.stream,
      lastNameValidator.stream,
      passwordValidator.stream,
      confirmPasswordValidator.stream,
      agreeTerms,
      (a, b, c, d, e, f, g) => true && g);

  // use cases
  final SignUpUseCase signUpUseCase;
  final SocialLoginUseCase socialLoginUseCase;

  SignUpCubit(this.signUpUseCase, this.socialLoginUseCase)
      : super(const CommonUIState.initial()) {
    initCubit();
  }

  signUp() async {
    emit(const CommonUIState.loading());
    if (emailValidator.isEmpty &&
        firstNameValidator.isEmpty &&
        userNameValidator.isEmpty &&
        lastNameValidator.isEmpty &&
        passwordValidator.isEmpty) {
      emailValidator.onChange("");
      passwordValidator.onChange("");
      firstNameValidator.onChange("");
      userNameValidator.onChange("");
      lastNameValidator.onChange("");
      confirmPasswordValidator.onChange("");
    } else {
      var response = await signUpUseCase(
        HashMap.from(
          {
            "email": emailValidator.text.trim(),
            "first_name": firstNameValidator.text.trim(),
            "last_name": lastNameValidator.text.trim(),
            "username": userNameValidator.text.trim(),
            "password": passwordValidator.text.trim(),
          },
        ),
      );
      emit(response.fold((l) => CommonUIState.error(l.errorMessage),
          (r) => CommonUIState.success(false)));
    }
  }

  void initCubit() {
    confirmPasswordValidator = FieldValidators(
        StreamTransformer.fromHandlers(handleData: (string, sink) {
      if (string.isNotEmpty && string == passwordValidator.text) {
        sink.add(string);
      } else {
        sink.addError("Please make sure password match");
      }
    }), null, obsecureTextBool: true, passwordField: true);
    passwordValidator = FieldValidators(
        validatePassword(), confirmPasswordValidator.focusNode,
        obsecureTextBool: true, passwordField: true);
    emailValidator =
        FieldValidators(validateEmail, passwordValidator.focusNode);
    userNameValidator = FieldValidators(
        notEmptyValidator(FieldType.USERNAME), emailValidator.focusNode);
    lastNameValidator = FieldValidators(
        notEmptyValidator(FieldType.LAST_NAME), userNameValidator.focusNode);
    firstNameValidator = FieldValidators(
        notEmptyValidator(FieldType.FIRST_NAME), lastNameValidator.focusNode);
  }

  void facebookLogin() async {
    var response = await socialLoginUseCase(SocialLogin.FB);
    emit(response.fold((l) => CommonUIState.error(l.errorMessage),
        (r) => CommonUIState.success(true)));
  }

  void googleLogin() async {
    var response = await socialLoginUseCase(SocialLogin.GOOGLE);
    emit(response.fold((l) => CommonUIState.error(l.errorMessage),
        (r) => CommonUIState.success(true)));
  }

  void twitterLogin() async {
    var response = await socialLoginUseCase(SocialLogin.TWITTER);
    emit(response.fold((l) => CommonUIState.error(l.errorMessage),
        (r) => CommonUIState.success(true)));
  }

  @override
  // ignore: missing_return
  Future<void> close() {
    confirmPasswordValidator.onDispose();
    firstNameValidator.onDispose();
    lastNameValidator.onDispose();
    userNameValidator.onDispose();
    emailValidator.onDispose();
    passwordValidator.onDispose();
    currentPageController.close();
    super.close();
  }
}
