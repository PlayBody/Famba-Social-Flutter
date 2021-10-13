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
import '../bloc/login_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginCubit loginCubit;
  @override
  void initState() {
    super.initState();
    loginCubit = getIt<LoginCubit>();
    // EasyLoading.show();
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return GestureDetector(
      onTap: () => context.removeFocus(),
      child: SafeArea(
        child: BlocProvider<LoginCubit>(
          create: (c) => loginCubit,
          child: BlocListener<LoginCubit, CommonUIState>(
            listener: (_, state) {
              state.maybeWhen(
                orElse: () {},
                success: (message) {
                  ExtendedNavigator.root
                      .pushAndRemoveUntil(Routes.feedScreen, (route) => false);
                  context.showSnackBar(message: "Login Successfully");
                },
                error: (e) {
                  if (e.isNotEmpty) {
                    context.showOkAlertDialog(desc: e, title: "Alert");
                  }
                },
              );
            },
            child: BlocBuilder<LoginCubit, CommonUIState>(
              builder: (c, state) => state.when(
                initial: buildHome,
                success: (s) => buildHome(),
                loading: () => LoadingBar(),
                error: (e) => buildHome(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHome() {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: KeyboardActions(
              config: KeyboardActionsConfig(
                keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
                actions: [
                  KeyboardActionsItem(
                    focusNode: loginCubit.emailValidators.focusNode,
                  ),
                  KeyboardActionsItem(
                    displayDoneButton: true,
                    toolbarButtons: [
                      (node) {
                        return GestureDetector(
                          onTap: () => node.unfocus(),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.close),
                          ),
                        );
                      }
                    ],
                    focusNode: loginCubit.passwordValidator.focusNode,
                  ),
                ],
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: [
                  buildTopView().toExpanded(flex: 3),
                  buildMiddleView(context).toExpanded(flex: 3),
                  buildBottomView().toExpanded(flex: 1),
                ]
                    .toColumn(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center)
                    .toContainer(
                        alignment: Alignment.center, color: Colors.white)
                    .toHorizontalPadding(24.0),
              ),
            ),
          ),
        )
        // .toFadeAnimation(animationController).toSlideAnimation(animationController),
        );
  }

  Widget buildTopView() {
    return [
      AppIcons.appLogo.toContainer(alignment: Alignment.center).toExpanded(),
      [
        Strings.emailAddress
            .toTextField(keyboardType: TextInputType.emailAddress)
            .toStreamBuilder(
              validators: loginCubit.emailValidators,
              keyboardType: TextInputType.emailAddress,
            ),
        10.toSizedBox,
        Strings.password.toTextField(
          onSubmit: (value) {
            loginCubit.loginUser();
          },
        ).toStreamBuilder(validators: loginCubit.passwordValidator),
        Strings.forgotPassword
            .toCaption(fontWeight: FontWeight.w600)
            .toContainer(alignment: Alignment.centerRight)
            .toVerticalPadding(12.0)
            .onTapWidget(() {
          ExtendedNavigator.root.push(Routes.resetPasswordScreen);
        }),
        // "The email and password you entered does not match. Please double-check and try again".toCaption(color: Colors.red,fontWeight: FontWeight.w600).toVisibilityStreamBuilder(loginCubit.errorTextStream.stream)
      ].toColumn()
    ]
        .toColumn(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center)
        .toContainer(alignment: Alignment.bottomCenter);
  }

  Widget buildMiddleView(BuildContext context) {
    return [
      25.toSizedBox,
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
              url: Strings.privacyUrl,
              name: Strings.privacy,
            ),
          );
        })
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
      35.toSizedBox,
      Strings.login.toText.toStreamBuilderButton(loginCubit.validForm,
          () async {
        await loginCubit.loginUser();
      }),
      35.toSizedBox,
      [
        Images.facebook
            .toSvg()
            .toFlatButton(() async => loginCubit.facebookLogin(),
                color: AppColors.fbBlue)
            .toSizedBox(height: 40, width: 55),
        10.toSizedBox,
        Images.google
            .toSvg()
            .toFlatButton(
              () => loginCubit.googleLogin(),
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
              () => loginCubit.twitterLogin(),
              color: AppColors.twitterBlue,
            )
            .toSizedBox(height: 40, width: 55)
            .toVisibility(false),
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
    ]
        .toColumn(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center)
        .toContainer(alignment: Alignment.topCenter);
  }

  Widget buildBottomView() {
    return [
      Strings.dontHaveAnAccount
          .toCaption(fontWeight: FontWeight.w600, color: Colors.black54),
      Strings.signUpCaps
          .toButton(color: AppColors.colorPrimary)
          .toUnderLine()
          .toFlatButton(
              () => ExtendedNavigator.root.replace(Routes.signUpScreen)),
    ]
        .toColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )
        .toContainer(
          alignment: Alignment.center,
        );
  }
}
