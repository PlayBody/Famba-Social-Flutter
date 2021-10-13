import 'package:auto_route/auto_route.dart';
import '../../../../core/common/uistate/common_ui_state.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/routes.gr.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/images.dart';
import '../../../../core/theme/strings.dart';
import '../../../../core/widgets/loading_bar.dart';
import '../../../../extensions.dart';
import '../bloc/sign_up_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  SignUpCubit signUpCubit;

  @override
  void initState() {
    super.initState();
    signUpCubit = getIt<SignUpCubit>();
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return BlocProvider<SignUpCubit>(
      create: (c) => signUpCubit,
      child: BlocListener<SignUpCubit, CommonUIState>(
        listener: (_, state) {
          state.maybeWhen(
            orElse: () {},
            error: (e) {
              if (e.isNotEmpty) {
                context.showOkAlertDialog(
                  desc: e,
                  title: "Information",
                );
              }
            },
            success: (isSocial) {
              // If logged in using social media buttons
              if (isSocial) {
                ExtendedNavigator.root
                    .pushAndRemoveUntil(Routes.feedScreen, (route) => false);
              } else {
                context.showOkAlertDialog(
                  desc: "Sign up successfully",
                  title: "Information",
                  onTapOk: () {
                    ExtendedNavigator.root.replace(Routes.loginScreen);
                  },
                );
              }
            },
          );
        },
        child: BlocBuilder<SignUpCubit, CommonUIState>(
          builder: (context, state) {
            return state.when(
              initial: buildHome,
              success: (s) => buildHome(),
              loading: () => LoadingBar(),
              error: (e) => buildHome(),
            );
          },
        ),
      ),
    );
  }

  Widget buildHome() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: KeyboardActions(
            config: KeyboardActionsConfig(
              keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
              actions: [
                KeyboardActionsItem(
                  focusNode: signUpCubit.firstNameValidator.focusNode,
                ),
                KeyboardActionsItem(
                  focusNode: signUpCubit.lastNameValidator.focusNode,
                ),
                KeyboardActionsItem(
                  focusNode: signUpCubit.userNameValidator.focusNode,
                ),
                KeyboardActionsItem(
                  focusNode: signUpCubit.emailValidator.focusNode,
                ),
                KeyboardActionsItem(
                  focusNode: signUpCubit.passwordValidator.focusNode,
                ),
                KeyboardActionsItem(
                  displayDoneButton: true,
                  focusNode: signUpCubit.confirmPasswordValidator.focusNode,
                ),
              ],
            ),
            child: [buildTopView(), buildMiddleView(), buildBottomView()]
                .toColumn(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center)
                .makeScrollable()
                .toContainer(alignment: Alignment.center, color: Colors.white)
                .toHorizontalPadding(24.0),
          ),
        ));
  }

  Widget buildTopView() {
    return [
      60.toSizedBox,
      AppIcons.appLogo.toContainer(alignment: Alignment.center),
      30.toSizedBox,
      Strings.firstName
          .toTextField()
          .toStreamBuilder(validators: signUpCubit.firstNameValidator),
      11.toSizedBox,
      Strings.lastName
          .toTextField()
          .toStreamBuilder(validators: signUpCubit.lastNameValidator),
      10.toSizedBox,
      Strings.userName
          .toTextField()
          .toStreamBuilder(validators: signUpCubit.userNameValidator),
      10.toSizedBox,
      Strings.emailAddress
          .toTextField()
          .toStreamBuilder(validators: signUpCubit.emailValidator),
      10.toSizedBox,
      Strings.password
          .toTextField()
          .toStreamBuilder(validators: signUpCubit.passwordValidator),
      10.toSizedBox,
      Strings.confirmPassword
          .toTextField()
          .toStreamBuilder(validators: signUpCubit.confirmPasswordValidator)
    ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end);
  }

  Widget buildMiddleView() {
    return [
      40.toSizedBox,
      Strings.byClickingAgree
          .toButton(fontSize: 12.0, color: AppColors.greyText),
      [
        Strings.termsOfUse
            .toButton(fontSize: 12.0, color: AppColors.colorPrimary)
            .onTapWidget(() {
          context.removeFocus();
          ExtendedNavigator.root.push(Routes.webViewScreen,
              arguments: WebViewScreenArguments(
                  url: Strings.termsUrl, name: Strings.termsOfUse));
        }),
        " and ".toButton(fontSize: 12.0, color: AppColors.greyText),
        Strings.privacy
            .toButton(fontSize: 12.0, color: AppColors.colorPrimary)
            .onTapWidget(() {
          context.removeFocus();
          ExtendedNavigator.root.push(
            Routes.webViewScreen,
            arguments: WebViewScreenArguments(
                url: Strings.privacyUrl, name: Strings.privacy),
          );
        })
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
      25.toSizedBox,
      Strings.signUp.toText.toStreamBuilderButton(signUpCubit.validForm,
          () async {
        await signUpCubit.signUp();
      }),
      25.toSizedBox,
      [
        Images.facebook
            .toSvg()
            .toFlatButton(() => {signUpCubit.facebookLogin()},
                color: AppColors.fbBlue)
            .toSizedBox(height: 40, width: 55),
        10.toSizedBox,
        Images.google
            .toSvg()
            .toFlatButton(
              () => {signUpCubit.googleLogin()},
            )
            .toSizedBox(height: 40, width: 55)
            .toContainer(
                decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey.withOpacity(.1)),
              shape: BoxShape.rectangle,
            )),
        10.toSizedBox,
        Images.twitter
            .toSvg()
            .toFlatButton(
                () => {context.showSnackBar(message: Strings.twitterComing)},
                color: AppColors.twitterBlue)
            .toSizedBox(height: 40, width: 55)
            .toVisibility(false),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
    ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center);
  }

  Widget buildBottomView() {
    return [
      10.toSizedBox,
      Strings.haveAlreadyAccount.toCaption(),
      Strings.signIn
          .toButton(color: AppColors.colorPrimary)
          .toUnderLine()
          .toFlatButton(
              () => {ExtendedNavigator.root.replace(Routes.loginScreen)}),
    ].toColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center);
  }
}
