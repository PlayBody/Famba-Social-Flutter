import 'package:auto_route/auto_route.dart';
import '../../../../translations/locale_keys.g.dart';
import 'package:flutter/services.dart';
import '../../../../core/common/static_data/all_countries.dart';
import '../../../../core/common/uistate/common_ui_state.dart';
import '../../../../core/datasource/local_data_source.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/routes.gr.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/strings.dart';
import '../../../../core/widgets/loading_bar.dart';
import '../../../../extensions.dart';
import '../../domain/entity/setting_entity.dart';
import '../bloc/settings/user_setting_cubit.dart';
import 'settings/update_user_settings.dart';
import '../pagination/privacy_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:video_compress/video_compress.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatefulWidget {
  final bool fromProfile;

  const SettingsScreen({Key key, this.fromProfile = false}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserSettingCubit userSettingCubit;

  @override
  void initState() {
    super.initState();
    userSettingCubit = getIt<UserSettingCubit>()..getUserSettings();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (VideoCompress.compressProgress$.notSubscribed) {
        listenCompressions();
      } else {
        // dispose already subscribed stream
        VideoCompress.dispose();
        listenCompressions();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.white,
        title: LocaleKeys.profile_settings.tr().toSubTitle1(
              color: AppColors.textColor,
              fontWeight: FontWeight.bold,
              fontFamily1: 'CeraPro',
            ),
        centerTitle: true,
        leading: widget.fromProfile
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  ExtendedNavigator.root.pop();
                },
              )
            : null,
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await userSettingCubit.getUserSettings();
          return Future.value();
        },
        child: BlocListener<UserSettingCubit, CommonUIState>(
          bloc: userSettingCubit,
          listener: (c, state) {
            state.maybeWhen(
                orElse: () {},
                success: (s) {
                  if (s == "Deleted") {
                    ExtendedNavigator.root.pushAndRemoveUntil(
                        Routes.loginScreen, (route) => false);
                  }
                  context.showSnackBar(message: s);
                },
                error: (e) => context.showSnackBar(message: e, isError: true));
          },
          listenWhen: (c, s) => s.maybeWhen(
              orElse: () => false,
              success: (s) => s is String,
              error: (e) => true),
          child: BlocBuilder<UserSettingCubit, CommonUIState>(
            bloc: userSettingCubit,
            builder: (_, state) {
              return state.when(
                initial: () => LoadingBar(),
                success: (settingEntity) => StreamBuilder<SettingEntity>(
                  stream: userSettingCubit.settingEntity,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return buildHomeUI(snapshot.data);
                    } else if (snapshot.hasError)
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    else
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                  },
                ),
                loading: () => LoadingBar(),
                error: (e) => StreamBuilder<SettingEntity>(
                  stream: userSettingCubit.settingEntity,
                  builder: (context, snapshot) {
                    return snapshot.data == null
                        ? const SizedBox()
                        : buildHomeUI(snapshot.data);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildHomeUI(SettingEntity settingEntity) {
    String _level;
    if (settingEntity.level == "M") _level = "MS";
    if (settingEntity.level == "H") _level = "HS";
    if (settingEntity.level == "C") _level = "College";
    if (settingEntity.level == "P") _level = "Pro";
    return [
//    Social - 300 points
      header(LocaleKeys.social_300points.tr(), context),
      profileItem(
          LocaleKeys.username.tr(),
          "${settingEntity.name} - ${settingEntity.userName}",
          context, onTap: () {
        // context.showSnackBar(message: settingEntity.userName);
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.USERNAME);
      }),
      profileItem(
          LocaleKeys.phone_number.tr(), settingEntity.phoneNumber, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.PHONENUMBER);
      }),
      profileItem(LocaleKeys.email_address.tr(), settingEntity.email, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.EMAIL);
      }),
      profileItem(LocaleKeys.birthday.tr(), settingEntity.birthday, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.BIRTHDAY);
      }),
      profileItem(LocaleKeys.instagram.tr(), settingEntity.instagram, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.INSTAGRAM);
      }),
      profileItem(LocaleKeys.tictok.tr(), settingEntity.ticTok, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.TICTOK);
      }),
      profileItem(LocaleKeys.twitter.tr(), settingEntity.twitter, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.TWITTER);
      }),
      profileItem(LocaleKeys.snapchat.tr(), settingEntity.snapchat, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.SNAPCHAT);
      }),

//    Education - 100 points
      header(LocaleKeys.education_100points.tr(), context),
      profileItem(
          LocaleKeys.school_name.tr(), settingEntity.schoolName, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.SCHOOLNAME);
      }),
      profileItem(LocaleKeys.division_conference.tr(),
          settingEntity.divisionConference, context, onTap: () {
        openUpdateBottomSheet(
            settingEntity, UpdateSettingEnum.DIVISIONCONFERENCE);
      }),
      profileItem(LocaleKeys.awards.tr(), settingEntity.eduAwards, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.EDUAWARDS);
      }),
      profileItem(LocaleKeys.gpa.tr(), settingEntity.gpa, context, onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.GPA);
      }),
//    performance - 200 points
      header(LocaleKeys.performance_200points.tr(), context),
      profileItem(LocaleKeys.sports.tr(), settingEntity.sports, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.SPORTS);
      }),
      profileItem(LocaleKeys.city.tr(), settingEntity.city, context, onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.CITY);
      }),
      profileItem(
          LocaleKeys.state_str.tr(), settingEntity.stateProfile, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.STATEPROFILE);
      }),
      profileItem(LocaleKeys.level_str.tr(), _level, context, onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.LEVEL);
      }),
      profileItem(LocaleKeys.monetization_appearance_endorsement.tr(),
          settingEntity.monetization.toString(), context, onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.MONETIZATION);
      }),
//    Community - 100 points
      header(LocaleKeys.community_100points.tr(), context),
      profileItem(
          LocaleKeys.service_hours.tr(), settingEntity.serviceHours, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.SERVICEHOUR);
      }),
      profileItem(LocaleKeys.awards.tr(), settingEntity.awards, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.AWARDS);
      }),
//    General Profile
      header(LocaleKeys.general_profile_settings.tr(), context),
      profileItem(
          LocaleKeys.website_url_address.tr(), settingEntity.website, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.WEBSITE);
      }),
      profileItem(LocaleKeys.about_you.tr(), settingEntity.about, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.ABOUT_YOU);
      }),
      profileItem(LocaleKeys.your_gender.tr(), settingEntity.gender, context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.GENDER);
      }),
      header(LocaleKeys.user_password.tr(), context).toVisibility(
        !settingEntity.socialLogin,
      ),

      profileItem(LocaleKeys.my_password.tr(), "* * * * * *", context,
          onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.PASSWORD);
      }).toVisibility(!settingEntity.socialLogin),
      header(LocaleKeys.language_and_country.tr(), context),
      // profileItem("Display Language", settingEntity.displayLanguage),
      profileItem(
        LocaleKeys.display_language.tr(),
        allLanguagesMap[settingEntity.displayLanguage],
        context,
        onTap: () {
          openUpdateBottomSheet(
              settingEntity, UpdateSettingEnum.CHANGE_LANGUAGE);
        },
      ),
      profileItem(LocaleKeys.the_country_in_which_you_live.tr(),
          settingEntity.country, context, onTap: () {
        openUpdateBottomSheet(settingEntity, UpdateSettingEnum.COUNTRY);
      }),
      header(LocaleKeys.account_verification.tr(), context)
          .toVisibility(!settingEntity.isVerified),
      profileItem(
          LocaleKeys.verify_my_account.tr(),
          LocaleKeys.click_to_submit_a_verification_request.tr(),
          context, onTap: () {
        openUpdateBottomSheet(
            settingEntity, UpdateSettingEnum.VERIFY_MY_ACCOUNT);
      }).toVisibility(!settingEntity.isVerified),
      header(LocaleKeys.account_privacy_settings.tr(), context),
      profileItem(
        LocaleKeys.account_privacy.tr(),
        LocaleKeys.click_to_set_your_account_privacy.tr(),
        context,
        onTap: () {
          showModalBottomSheet(
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: const Radius.circular(10),
              ),
            ),
            context: context,
            builder: (c) {
              return BlocProvider.value(
                value: userSettingCubit,
                child: PrivacyScreen(
                  privacyModels: PrivacyWidgetModel.getPrivacyModels(
                    accountPrivacyEntity: settingEntity.accountPrivacyEntity,
                  ),
                ),
              );
            },
          );
        },
      ),

      header(
        "Company",
        context,
      ),
      profileItem(
          LocaleKeys.terms_of_use.tr(), "Click for our terms of usage", context,
          onTap: () {
        // await launch(link.url);
        ExtendedNavigator.root.push(Routes.webViewScreen,
            arguments: WebViewScreenArguments(
                url: Strings.termsUrl, name: Strings.termsOfUse));
      }),
      profileItem(LocaleKeys.privacy_policy.tr(),
          "Click for our privacy details", context, onTap: () {
        ExtendedNavigator.root.push(Routes.webViewScreen,
            arguments: WebViewScreenArguments(
                url: Strings.privacyUrl, name: Strings.privacy));
      }),
      profileItem(
        LocaleKeys.cookies.tr(),
        "Click for our cookies",
        context,
        onTap: () {
          ExtendedNavigator.root.push(
            Routes.webViewScreen,
            arguments: WebViewScreenArguments(
              url: Strings.cookiesPolicy,
              name: Strings.cookie,
            ),
          );
        },
      ),
      profileItem(
        LocaleKeys.about_us.tr(),
        "Read about us",
        context,
        onTap: () {
          ExtendedNavigator.root.push(
            Routes.webViewScreen,
            arguments: WebViewScreenArguments(
              url: Strings.aboutUs,
              name: Strings.about,
            ),
          );
        },
      ),
      header(
        LocaleKeys.delete_profile.tr(),
        context,
      ),
      profileItem(
        LocaleKeys.delete.tr(),
        LocaleKeys.click_to_confirm_deletion_of_your_profile.tr(),
        context,
        onTap: () {
          openUpdateBottomSheet(
              settingEntity, UpdateSettingEnum.DELETE_ACCOUNT);
        },
      ),

      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: LocaleKeys.logout
            .tr()
            .toCaption(fontWeight: FontWeight.w600, fontSize: 15)
            .toCenter()
            .onTapWidget(
          () {
            context.showAlertDialog(
              widgets: [
                "Yes".toButton().toFlatButton(
                  () async {
                    var localDataSource = getIt<LocalDataSource>();
                    await localDataSource.clearData();
                    // Fix the issue
                    ExtendedNavigator.root.pop();
                    ExtendedNavigator.root
                        .pushAndRemoveUntil(Routes.loginScreen, (c) => false);
                  },
                ),
                "No".toButton().toFlatButton(
                  () {
                    ExtendedNavigator.root.pop();
                  },
                ),
              ],
              title: LocaleKeys
                  .are_you_sure_that_you_want_to_log_out_from_your_account
                  .tr(),
            );
          },
        ),
      ),

      [
        "Version 2.0.4".toCaption(fontWeight: FontWeight.w600),
      ]
          .toColumn(
            mainAxisAlignment: MainAxisAlignment.center,
          )
          .toContainer(alignment: Alignment.bottomCenter, height: 100),
      10.toSizedBox,
    ].toColumn().makeScrollable().toSafeArea;
  }

  void openUpdateBottomSheet(
      SettingEntity settingEntity, UpdateSettingEnum updateSettingEnum) {
    showModalBottomSheet(
        // enableDrag: true,
        isScrollControlled: true,
        shape: 10.0.toRoundRectTop,
        // clipBehavior: Clip.hardEdge,
        context: context,
        builder: (c) => BlocProvider.value(
              value: userSettingCubit,
              child: UpdateUserProfile(
                updateSettingEnum: updateSettingEnum,
                onTapSave: () {
                  switch (updateSettingEnum) {
                    case UpdateSettingEnum.USERNAME:
                      if (userSettingCubit.firstNameValidator.text.isEmpty) {
                        ExtendedNavigator.root.pop();
                        userSettingCubit.firstNameValidator
                            .changeData(settingEntity.firstName);
                        userSettingCubit.firstNameValidator.textController
                            .text = settingEntity.firstName;
                        context.showSnackBar(
                          message: "First name must not be empty",
                          isError: true,
                        );
                      } else if (userSettingCubit
                          .lastNameValidator.text.isEmpty) {
                        ExtendedNavigator.root.pop();
                        userSettingCubit.lastNameValidator.textController.text =
                            settingEntity.lastName;
                        userSettingCubit.lastNameValidator
                            .changeData(settingEntity.lastName);
                        context.showSnackBar(
                            message: "Last name must not be empty",
                            isError: true);
                      } else if (userSettingCubit
                          .userNameValidator.text.isEmpty) {
                        ExtendedNavigator.root.pop();
                        userSettingCubit.userNameValidator
                            .changeData(settingEntity.userName);
                        userSettingCubit.userNameValidator.textController.text =
                            settingEntity.userName;
                        context.showSnackBar(
                            message: "Username must not be empty",
                            isError: true);
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.EMAIL:
                      if (userSettingCubit.emailValidator.text.isEmpty) {
                        ExtendedNavigator.root.pop();
                        userSettingCubit.emailValidator
                            .changeData(settingEntity.email);
                        userSettingCubit.emailValidator.textController.text =
                            settingEntity.email;
                        context.showSnackBar(
                            message: "Email must not be empty", isError: true);
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.PHONENUMBER:
                      if (userSettingCubit.phoneNumberValidator.text.isEmpty) {
                        userSettingCubit
                            .phoneNumberValidator.textController.text = '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.BIRTHDAY:
                      if (userSettingCubit.birthdayValidator.text.isEmpty) {
                        userSettingCubit.birthdayValidator.textController.text =
                            '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.INSTAGRAM:
                      if (userSettingCubit.instagramValidator.text.isEmpty) {
                        userSettingCubit
                            .instagramValidator.textController.text = '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.TICTOK:
                      if (userSettingCubit.ticTokValidator.text.isEmpty) {
                        userSettingCubit.ticTokValidator.textController.text =
                            '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.TWITTER:
                      if (userSettingCubit.twitterValidator.text.isEmpty) {
                        userSettingCubit.twitterValidator.textController.text =
                            '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.SNAPCHAT:
                      if (userSettingCubit.snapchatValidator.text.isEmpty) {
                        userSettingCubit.snapchatValidator.textController.text =
                            '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.SCHOOLNAME:
                      if (userSettingCubit.schoolNameValidators.text.isEmpty) {
                        userSettingCubit
                            .schoolNameValidators.textController.text = '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.DIVISIONCONFERENCE:
                      if (userSettingCubit
                          .divisionConferenceValidators.text.isEmpty) {
                        userSettingCubit.divisionConferenceValidators
                            .textController.text = '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.EDUAWARDS:
                      if (userSettingCubit.eduAwardsValidators.text.isEmpty) {
                        userSettingCubit
                            .eduAwardsValidators.textController.text = '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.GPA:
                      if (userSettingCubit.gpaValidators.text.isEmpty) {
                        userSettingCubit.gpaValidators.textController.text = '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.SPORTS:
                      if (userSettingCubit.sportsValidators.text.isEmpty) {
                        userSettingCubit.sportsValidators.textController.text =
                            '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.CITY:
                      if (userSettingCubit.cityValidators.text.isEmpty) {
                        userSettingCubit.cityValidators.textController.text =
                            '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.LEVEL:
                      if (userSettingCubit.levelValidators.text.isEmpty) {
                        userSettingCubit.levelValidators.textController.text =
                            '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.MONETIZATION:
                      if (userSettingCubit
                          .monetizationValidators.text.isEmpty) {
                        userSettingCubit
                            .monetizationValidators.textController.text = '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.STATEPROFILE:
                      if (userSettingCubit.stateValidators.text.isEmpty) {
                        userSettingCubit.stateValidators.textController.text =
                            '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.SERVICEHOUR:
                      if (userSettingCubit
                          .serviceHoursValidators.text.isEmpty) {
                        userSettingCubit
                            .serviceHoursValidators.textController.text = '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.AWARDS:
                      if (userSettingCubit.awardsValidators.text.isEmpty) {
                        userSettingCubit.awardsValidators.textController.text =
                            '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.WEBSITE:
                      if (userSettingCubit.websiteValidators.text.isEmpty) {
                        userSettingCubit.websiteValidators.textController.text =
                            '';
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        ExtendedNavigator.root.pop();
                      } else {
                        if (!userSettingCubit
                            .websiteValidators.text.isValidUrl) {
                          userSettingCubit.websiteValidators
                              .changeData(settingEntity.website);
                          userSettingCubit.websiteValidators.textController
                              .text = settingEntity.website;
                          ExtendedNavigator.root.pop();
                          context.showSnackBar(
                            message: "Website address is not valid",
                            isError: true,
                          );
                        } else {
                          userSettingCubit
                              .updateUserSettings(updateSettingEnum);
                          ExtendedNavigator.root.pop();
                        }
                      }
                      break;
                    case UpdateSettingEnum.ABOUT_YOU:
                      userSettingCubit.updateUserSettings(updateSettingEnum);
                      ExtendedNavigator.root.pop();

                      break;
                    case UpdateSettingEnum.GENDER:
                      userSettingCubit.updateUserSettings(updateSettingEnum);
                      ExtendedNavigator.root.pop();
                      break;
                    case UpdateSettingEnum.COUNTRY:
                      userSettingCubit.updateUserSettings(updateSettingEnum);
                      ExtendedNavigator.root.pop();
                      break;
                    case UpdateSettingEnum.PASSWORD:
                      if (userSettingCubit.oldPasswordValidator.text.isEmpty) {
                        context.showSnackBar(
                            message: "Old Password you must not be empty",
                            isError: true);
                      } else if (userSettingCubit
                          .newPasswordValidator.text.isEmpty) {
                        context.showSnackBar(
                            message: "New Password you must not be empty",
                            isError: true);
                      } else if (userSettingCubit
                              .newPasswordValidator.text.isEmpty ||
                          userSettingCubit
                              .confirmPasswordValidator.text.isEmpty ||
                          userSettingCubit.newPasswordValidator.text !=
                              userSettingCubit.confirmPasswordValidator.text) {
                        context.showSnackBar(
                            message: "Please make sure password match",
                            isError: true);
                      } else {
                        // userSettingCubit.oldPasswordValidator.addError("dummy");
                        userSettingCubit.updateUserSettings(updateSettingEnum);
                        // context.router.root.pop();
                      }
                      break;
                    case UpdateSettingEnum.VERIFY_MY_ACCOUNT:
                      userSettingCubit.verifyUserAccount();
                      ExtendedNavigator.root.pop();
                      break;
                    case UpdateSettingEnum.DELETE_ACCOUNT:
                      if (userSettingCubit
                          .deleteAccountValidator.text.isValidPass)
                        userSettingCubit.deleteAccount();
                      else
                        context.showSnackBar(
                            message:
                                userSettingCubit.deleteAccountValidator.text);
                      ExtendedNavigator.root.pop();
                      break;
                    case UpdateSettingEnum.CHANGE_LANGUAGE:
                      userSettingCubit.changeUserLanguage(context);
                      ExtendedNavigator.root.pop();
                      break;
                  }
                },
              ),
            ));
  }

  void listenCompressions() {
    VideoCompress.compressProgress$.subscribe(
      (progress) {
        if (progress < 99.99)
          EasyLoading.showProgress(
            (progress / 100),
            status: 'Compressing ${progress.toInt()}%',
          );
        else
          EasyLoading.dismiss();
      },
    );
  }
}

Widget header(String name, BuildContext context) {
  return [
    name.toCaption(
      fontWeight: FontWeight.bold,
      textAlign: context.isArabic() ? TextAlign.right : TextAlign.left,
    )
  ]
      .toColumn(crossAxisAlignment: CrossAxisAlignment.stretch)
      .toHorizontalPadding(12)
      .toPadding(12)
      .onTapWidget(() {})
      .toContainer(color: AppColors.lightSky.withOpacity(.5))
      .makeBottomBorder;
}

Widget profileItem(String title, String value, BuildContext context,
    {VoidCallback onTap}) {
  return [
    title.toSubTitle2(
      fontWeight: FontWeight.bold,
      align: context.isArabic() ? TextAlign.right : TextAlign.left,
    ),
    5.toSizedBox,
    value.toSubTitle2(
      align: context.isArabic() ? TextAlign.right : TextAlign.left,
    )
  ]
      .toColumn(crossAxisAlignment: CrossAxisAlignment.stretch)
      .toPadding(12)
      .toContainer()
      .makeBottomBorder
      .toFlatButton(
    () {
      onTap?.call();
    },
  );
}

class PrivacyWidgetModel {
  final String value;
  final PrivacyOptionEnum privacyOptionEnum;
  final bool isSelected;
  PrivacyWidgetModel._(this.value, this.privacyOptionEnum,
      {this.isSelected = false});

  static List<PrivacyWidgetModel> getPrivacyModels(
      {AccountPrivacyEntity accountPrivacyEntity}) {
    return [
      PrivacyWidgetModel._(
        LocaleKeys.yes.tr(),
        PrivacyOptionEnum.SEARCH_VISIBILITY,
        isSelected: accountPrivacyEntity.showProfileInSearchEngine ==
            Strings.privacyYes,
      ),
      PrivacyWidgetModel._(
        LocaleKeys.no.tr(),
        PrivacyOptionEnum.SEARCH_VISIBILITY,
        isSelected:
            accountPrivacyEntity.showProfileInSearchEngine == Strings.privacyNo,
      ),
      PrivacyWidgetModel._(
        LocaleKeys.everyone.tr(),
        PrivacyOptionEnum.CONTACT_PRIVACY,
        isSelected: accountPrivacyEntity.canDMMe == Strings.privacyEveryOne,
      ),
      PrivacyWidgetModel._(
        LocaleKeys.the_people_i_follow.tr(),
        PrivacyOptionEnum.CONTACT_PRIVACY,
        isSelected:
            accountPrivacyEntity.canDMMe == Strings.privacyPeopleIFollow,
      ),
      PrivacyWidgetModel._(
        LocaleKeys.everyone.tr(),
        PrivacyOptionEnum.PROFILE_VISIBILITY,
        isSelected:
            accountPrivacyEntity.canSeeMyPosts == Strings.privacyEveryOne,
      ),
      PrivacyWidgetModel._(
        LocaleKeys.my_followers.tr(),
        PrivacyOptionEnum.PROFILE_VISIBILITY,
        isSelected:
            accountPrivacyEntity.canSeeMyPosts == Strings.privacyMyFollowers,
      ),
    ];
  }

  static String getEnumValue(PrivacyOptionEnum privacyOptionEnum) {
    String text = '';
    switch (privacyOptionEnum) {
      case PrivacyOptionEnum.PROFILE_VISIBILITY:
        text = LocaleKeys.who_can_see_my_profile_posts.tr();
        break;
      case PrivacyOptionEnum.CONTACT_PRIVACY:
        text = LocaleKeys.who_can_direct_message_me.tr();
        break;
      case PrivacyOptionEnum.SEARCH_VISIBILITY:
        text = LocaleKeys.show_your_profile_in_search_engines.tr();
        break;
    }
    return text;
  }

  PrivacyWidgetModel copyWith(
      {String value, PrivacyOptionEnum privacyOptionEnum, bool isSelected}) {
    return PrivacyWidgetModel._(
        value ?? this.value, privacyOptionEnum ?? this.privacyOptionEnum,
        isSelected: isSelected ?? this.isSelected);
  }
}

enum PrivacyOptionEnum {
  PROFILE_VISIBILITY,
  CONTACT_PRIVACY,
  SEARCH_VISIBILITY
}
