import 'package:auto_route/auto_route.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../../core/common/uistate/common_ui_state.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/routes.gr.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/loading_bar.dart';
import '../../../../extensions.dart';
import '../bloc/reset_password_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  ResetPasswordCubit resetPasswordCubit;
  @override
  void initState() {
    super.initState();
    resetPasswordCubit = getIt<ResetPasswordCubit>();
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return BlocProvider<ResetPasswordCubit>(
      create: (c) => resetPasswordCubit,
      child: BlocListener<ResetPasswordCubit, CommonUIState>(
          listener: (_, state) {
            state.maybeWhen(
                orElse: () {},
                success: (message) {
                  ExtendedNavigator.root.pop();
                  context.showSnackBar(message: message);
                },
                error: (e) {
                  context.showOkAlertDialog(desc: e, title: "Alert");
                });
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: BlocBuilder<ResetPasswordCubit, CommonUIState>(
              builder: (c, state) => state.when(
                  initial: buildHome,
                  success: (s) => buildHome(),
                  loading: () => LoadingBar(),
                  error: (e) => buildHome()),
            ),
          )),
    );
  }

  Widget buildHome() {
    return SingleChildScrollView(
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: KeyboardActions(
          config: KeyboardActionsConfig(
            keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
            actions: [
              KeyboardActionsItem(
                displayDoneButton: true,
                focusNode: resetPasswordCubit.emailValidator.focusNode,
              ),
            ],
          ),
          child: SizedBox(
            height: context.getScreenHeight,
            child: [
              [
                AppIcons.appLogo
                    .toContainer(alignment: Alignment.center)
                    .toExpanded(),
                LocaleKeys
                    .please_check_your_email_inbox_mail_we_sent_you_an_email
                    .tr()
                    .toCaption(fontWeight: FontWeight.w600)
                    .toContainer(alignment: Alignment.center),
              ].toColumn().toExpanded(),
              [
                20.toSizedBox,
                LocaleKeys.enter_your_email_address
                    .tr()
                    .toTextField()
                    .toStreamBuilder(
                        validators: resetPasswordCubit.emailValidator),
                20.toSizedBox,
                LocaleKeys.reset_the_password
                    .tr()
                    .toButton()
                    .toStreamBuilderButton(resetPasswordCubit.enableButton,
                        () => resetPasswordCubit.resetPassword()),
              ].toColumn().toExpanded(),
              [
                LocaleKeys.already_have_an_account.tr().toCaption(
                    fontWeight: FontWeight.w600, color: Colors.black54),
                "SIGN IN"
                    .toButton(color: AppColors.colorPrimary)
                    .toUnderLine()
                    .toFlatButton(() =>
                        ExtendedNavigator.root.replace(Routes.loginScreen)),
              ]
                  .toColumn(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center)
                  .toExpanded()
            ]
                .toColumn(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center)
                .toHorizontalPadding(24),
          ),
        ),
      ),
    );
  }
}
