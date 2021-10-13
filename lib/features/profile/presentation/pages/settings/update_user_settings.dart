import 'package:auto_route/auto_route.dart';
import '../../../../../translations/locale_keys.g.dart';
import '../../../../../core/common/buttons/custom_button.dart';
import '../../../../../core/common/static_data/all_countries.dart';
import '../../../../../core/common/uistate/common_ui_state.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/theme/strings.dart';
import '../../../../../core/widgets/loading_bar.dart';
import '../../../../../core/widgets/media_picker.dart';
import '../../../../feed/presentation/widgets/create_post_card.dart';
import '../../../domain/entity/setting_entity.dart';
import '../../bloc/settings/user_setting_cubit.dart';
import 'package:flutter/cupertino.dart';
import '../../../../../extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_select/smart_select.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class UpdateUserProfile extends StatefulWidget {
  final UpdateSettingEnum updateSettingEnum;
  final Function() onTapSave;

  const UpdateUserProfile(
      {Key key, @required this.updateSettingEnum, this.onTapSave})
      : super(key: key);

  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  UserSettingCubit userSettingCubit;

  @override
  void initState() {
    super.initState();
    userSettingCubit = BlocProvider.of<UserSettingCubit>(context);
  }

  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate:
          userSettingCubit.birthdayValidator.textController.text.isEmpty
              ? DateTime.now()
              : DateTime.parse(
                  userSettingCubit.birthdayValidator.textController.text),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null &&
        selected !=
            DateTime.parse(
                userSettingCubit.birthdayValidator.textController.text))
      setState(() {
        userSettingCubit.birthdayValidator.textController.text =
            DateFormat('yyyy-MM-dd').format(selected);
      });
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          userSettingCubit.resetAllData();
          ExtendedNavigator.root.pop();
          return Future.value(true);
        },
        child: BlocBuilder<UserSettingCubit, CommonUIState>(
          bloc: userSettingCubit,
          builder: (context, state) => state.maybeWhen(
            orElse: () => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: [
                  ListTile(
                    leading: const BackButton(),
                    title: _getTitle(widget.updateSettingEnum)
                        .toSubTitle1(fontWeight: FontWeight.w600)
                        .toHorizontalPadding(8),
                    tileColor: AppColors.sfBgColor,
                  ),
                  getHomeWidget(widget.updateSettingEnum).toPadding(16),
                  10.toSizedBox,
                  CustomButton(
                    text: _getButtonText(
                      widget.updateSettingEnum,
                    ),
                    onTap: () {
                      widget.onTapSave.call();
                    },
                    color: widget.updateSettingEnum ==
                            UpdateSettingEnum.DELETE_ACCOUNT
                        ? Colors.red
                        : AppColors.colorPrimary,
                  ).toPadding(16),
                ].toColumn(
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
            ),
            loading: () => LoadingBar(),
          ),
        ),
      ),
    );
  }

  Widget getHomeWidget(UpdateSettingEnum updateSettingEnum) {
    switch (updateSettingEnum) {
      case UpdateSettingEnum.USERNAME:
        return _updateUsername();
        break;
      case UpdateSettingEnum.EMAIL:
        return _updateEmail();
        break;
      case UpdateSettingEnum.PHONENUMBER:
        return _updatePhonNumber();
        break;
      case UpdateSettingEnum.BIRTHDAY:
        return _updateBirthday();
        break;
      case UpdateSettingEnum.INSTAGRAM:
        return _updateInstagram();
        break;
      case UpdateSettingEnum.TICTOK:
        return _updateTicTok();
        break;
      case UpdateSettingEnum.TWITTER:
        return _updateTwitter();
        break;
      case UpdateSettingEnum.SNAPCHAT:
        return _updateSnapchat();
        break;
      case UpdateSettingEnum.SCHOOLNAME:
        return _updateSchoolName();
        break;
      case UpdateSettingEnum.DIVISIONCONFERENCE:
        return _updateDivisionConference();
        break;
      case UpdateSettingEnum.EDUAWARDS:
        return _updateEducationAwards();
        break;
      case UpdateSettingEnum.GPA:
        return _updateGpa();
        break;
      case UpdateSettingEnum.SPORTS:
        return _updateSports();
        break;
      case UpdateSettingEnum.CITY:
        return _updateCity();
        break;
      case UpdateSettingEnum.LEVEL:
        return _updateLevel();
        break;
      case UpdateSettingEnum.MONETIZATION:
        return _updateMonetization();
        break;
      case UpdateSettingEnum.STATEPROFILE:
        return _updateState();
        break;
      case UpdateSettingEnum.SERVICEHOUR:
        return _updateServiceHours();
        break;
      case UpdateSettingEnum.AWARDS:
        return _updateAwards();
        break;
      case UpdateSettingEnum.WEBSITE:
        return _updateWebsite();
        break;
      case UpdateSettingEnum.ABOUT_YOU:
        return _updateAbout();
        break;
      case UpdateSettingEnum.GENDER:
        return _updateGender();
        break;
      case UpdateSettingEnum.COUNTRY:
        return _updateCountry();
        break;
      case UpdateSettingEnum.PASSWORD:
        return _updatePassword();
        break;
      case UpdateSettingEnum.VERIFY_MY_ACCOUNT:
        return _verifyMyAccount();
        break;
      case UpdateSettingEnum.DELETE_ACCOUNT:
        return _deleteAccount();
      case UpdateSettingEnum.CHANGE_LANGUAGE:
        return _changeLanguage();
        break;
      default:
        return const SizedBox();
    }
  }

  String _getTitle(UpdateSettingEnum updateSettingEnum) {
    String title = "";
    switch (updateSettingEnum) {
      case UpdateSettingEnum.USERNAME:
        title = LocaleKeys.username.tr();
        break;
      case UpdateSettingEnum.EMAIL:
        title = LocaleKeys.user_e_mail.tr();
        break;
      case UpdateSettingEnum.PHONENUMBER:
        title = LocaleKeys.phone_number.tr();
        break;
      case UpdateSettingEnum.BIRTHDAY:
        title = LocaleKeys.birthday.tr();
        break;
      case UpdateSettingEnum.INSTAGRAM:
        title = LocaleKeys.instagram.tr();
        break;
      case UpdateSettingEnum.TICTOK:
        title = LocaleKeys.tictok.tr();
        break;
      case UpdateSettingEnum.TWITTER:
        title = LocaleKeys.twitter.tr();
        break;
      case UpdateSettingEnum.SNAPCHAT:
        title = LocaleKeys.snapchat.tr();
        break;
      case UpdateSettingEnum.SCHOOLNAME:
        title = LocaleKeys.school_name.tr();
        break;
      case UpdateSettingEnum.DIVISIONCONFERENCE:
        title = LocaleKeys.division_conference.tr();
        break;
      case UpdateSettingEnum.EDUAWARDS:
        title = LocaleKeys.awards.tr();
        break;
      case UpdateSettingEnum.GPA:
        title = LocaleKeys.gpa.tr();
        break;
      case UpdateSettingEnum.SPORTS:
        title = LocaleKeys.sports.tr();
        break;
      case UpdateSettingEnum.CITY:
        title = LocaleKeys.city.tr();
        break;
      case UpdateSettingEnum.LEVEL:
        title = LocaleKeys.level_str.tr();
        break;
      case UpdateSettingEnum.MONETIZATION:
        title = LocaleKeys.monetization_appearance_endorsement.tr();
        break;
      case UpdateSettingEnum.STATEPROFILE:
        title = LocaleKeys.state_str.tr();
        break;
      case UpdateSettingEnum.SERVICEHOUR:
        title = LocaleKeys.service_hours.tr();
        break;
      case UpdateSettingEnum.AWARDS:
        title = LocaleKeys.awards.tr();
        break;
      case UpdateSettingEnum.WEBSITE:
        title = LocaleKeys.user_site_url.tr();
        break;
      case UpdateSettingEnum.ABOUT_YOU:
        title = LocaleKeys.about_you.tr();
        break;
      case UpdateSettingEnum.GENDER:
        title = LocaleKeys.user_gender.tr();
        break;
      case UpdateSettingEnum.COUNTRY:
        title = LocaleKeys.change_country.tr();
        break;
      case UpdateSettingEnum.PASSWORD:
        title = LocaleKeys.profile_password.tr();
        break;
      case UpdateSettingEnum.VERIFY_MY_ACCOUNT:
        title = LocaleKeys.verify_my_account.tr();
        break;
      case UpdateSettingEnum.DELETE_ACCOUNT:
        title = LocaleKeys.delete_account.tr();
        break;
      case UpdateSettingEnum.CHANGE_LANGUAGE:
        title = LocaleKeys.display_language.tr();
        break;
    }
    return title;
  }

  Widget _updateUsername() {
    return Column(
      children: [
        11.toSizedBox,
        Strings.firstName
            .toTextField()
            .toStreamBuilder(validators: userSettingCubit.firstNameValidator),
        11.toSizedBox,
        Strings.lastName
            .toTextField()
            .toStreamBuilder(validators: userSettingCubit.lastNameValidator),
        10.toSizedBox,
        Strings.userName
            .toTextField()
            .toStreamBuilder(validators: userSettingCubit.userNameValidator),
      ],
    );
  }

  Widget _updateEmail() {
    return [
      11.toSizedBox,
      Strings.emailAddress
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.emailValidator),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_after_changing_the_email_address_the_email_addre
          .tr()
          .toCaption(
              fontWeight: FontWeight.w600,
              color: AppColors.colorPrimary,
              maxLines: 5)
          .toFlexible()
    ].toColumn();
  }

  Widget _updatePhonNumber() {
    return [
      11.toSizedBox,
      Strings.userPhoneNumber
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.phoneNumberValidator),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_phone_number_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateBirthday() {
    return [
      11.toSizedBox,
      [
        Flexible(
            child: Strings.userBirthday.toTextField().toStreamBuilder(
                validators: userSettingCubit.birthdayValidator)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16)),
          onPressed: () {
            _selectDate(context);
          },
          child: Text("Choose Date"),
        )
      ].toRow(),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_birthday_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateInstagram() {
    return [
      11.toSizedBox,
      Strings.userInstagram
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.instagramValidator),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_instagram_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateTicTok() {
    return [
      11.toSizedBox,
      Strings.userTicTok
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.ticTokValidator),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_tic_tok_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateTwitter() {
    return [
      11.toSizedBox,
      Strings.userTwitter
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.twitterValidator),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_twitter_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateSnapchat() {
    return [
      11.toSizedBox,
      Strings.userSnapchat
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.snapchatValidator),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_snapchat_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateLevel() {
    return [
      DropdownButtonFormField(
        value: userSettingCubit.levelValidators.textController.text.isEmpty
            ? null
            : userSettingCubit.levelValidators.textController.text,
        items: [
          DropdownMenuItem(child: Text('MS'), value: 'M'),
          DropdownMenuItem(child: Text('HS'), value: 'H'),
          DropdownMenuItem(child: Text('College'), value: 'C'),
          DropdownMenuItem(child: Text('PRO'), value: 'P'),
        ],
        onChanged: (v) {
          userSettingCubit.levelValidators.textController.text = v.toString();
        },
      ),
      // Strings.userLevel
      //     .toTextField()
      //     .toStreamBuilder(validators: userSettingCubit.levelValidators),
      11.toSizedBox,
      LocaleKeys.please_note_that_level_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateMonetization() {
    double i = double.parse(
        userSettingCubit.monetizationValidators.textController.text);
    return [
      11.toSizedBox,
      SfSlider(
        min: 0,
        max: 50,
        value: i,
        stepSize: 1,
        showLabels: true,
        enableTooltip: true,
        minorTicksPerInterval: 1,
        onChanged: (dynamic value) {
          setState(() {
            i = value;
            userSettingCubit.monetizationValidators.textController.text =
                i.toInt().toString();
          });
        },
      ),
      // Strings.userMonezation
      //     .toTextField()
      //     .toStreamBuilder(validators: userSettingCubit.monetizationValidators),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_monetization_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateSchoolName() {
    return [
      11.toSizedBox,
      Strings.userschoolName
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.schoolNameValidators),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_school_name_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateDivisionConference() {
    return [
      11.toSizedBox,
      Strings.userDivisionConference.toTextField().toStreamBuilder(
          validators: userSettingCubit.divisionConferenceValidators),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_division_conference_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateEducationAwards() {
    return [
      11.toSizedBox,
      Strings.userEduAwards
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.eduAwardsValidators),
      11.toSizedBox,
      LocaleKeys.please_note_that_edu_awards_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateGpa() {
    return [
      11.toSizedBox,
      Strings.userGpa
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.gpaValidators),
      11.toSizedBox,
      LocaleKeys.please_note_that_gpa_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateSports() {
    return [
      11.toSizedBox,
      Strings.userSports
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.sportsValidators),
      11.toSizedBox,
      LocaleKeys.please_note_that_sports_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateCity() {
    return [
      11.toSizedBox,
      Strings.userCity
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.cityValidators),
      11.toSizedBox,
      LocaleKeys.please_note_that_city_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateState() {
    return [
      11.toSizedBox,
      Strings.userStateProfile
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.stateValidators),
      11.toSizedBox,
      LocaleKeys.please_note_that_state_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateServiceHours() {
    return [
      11.toSizedBox,
      Strings.userServiceHours
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.serviceHoursValidators),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_service_hours_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateAwards() {
    return [
      11.toSizedBox,
      Strings.userAwards
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.awardsValidators),
      11.toSizedBox,
      LocaleKeys.please_note_that_awards_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateWebsite() {
    return [
      11.toSizedBox,
      Strings.userSiteUrl
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.websiteValidators),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_this_url_will_appear_on_your_profile_page_if_you
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateAbout() {
    return [
      11.toSizedBox,
      Strings.aboutYou
          .toTextField(maxLength: 140)
          .toStreamBuilder(validators: userSettingCubit.aboutYouValidators),
      11.toSizedBox,
      LocaleKeys
          .please_enter_a_brief_description_of_yourself_with_a_maximum_of_14
          .tr()
          .toCaption(
            fontWeight: FontWeight.w600,
            color: AppColors.colorPrimary,
            maxLines: 5,
          )
          .toFlexible()
    ].toColumn();
  }

  Widget _updateGender() {
    return StreamBuilder<SettingEntity>(
      stream: userSettingCubit.settingEntity,
      builder: (context, snapshot) {
        return snapshot.data == null
            ? const SizedBox()
            : [
                11.toSizedBox,
                SmartSelect<String>.single(
                  choiceStyle: S2ChoiceStyle(
                      titleStyle: context.subTitle2
                          .copyWith(fontWeight: FontWeight.w600)),
                  modalConfig: S2ModalConfig(
                    title: LocaleKeys.your_gender.tr(),
                    headerStyle: S2ModalHeaderStyle(
                      textStyle: context.subTitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  modalType: S2ModalType.bottomSheet,
                  value: snapshot.data.gender.split('')[0],
                  onChange: (s) {
                    userSettingCubit
                      ..changeSettingEntity(snapshot.data.copyWith(
                          updatedGender: s.value == "M" ? "Male" : "Female"))
                      ..gender = s.value;
                  },
                  tileBuilder: (c, s) => ListTile(
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 14,
                    ),
                    onTap: () {
                      s.showModal();
                    },
                    title: LocaleKeys.your_gender
                        .tr()
                        .toSubTitle2(fontWeight: FontWeight.w600),
                    subtitle: snapshot.data.gender
                        .toCaption(fontWeight: FontWeight.w600),
                  ),
                  choiceItems: ["Male", "Female"]
                      .toList()
                      .map(
                        (e) => S2Choice(
                          value: e.split('')[0],
                          title: e,
                        ),
                      )
                      .toList(),
                ),
                11.toSizedBox,
                LocaleKeys
                    .please_choose_your_gender_this_is_necessary_for_a_more_complete_i
                    .tr()
                    .toCaption(
                        fontWeight: FontWeight.w600,
                        color: AppColors.colorPrimary,
                        maxLines: 5)
                    .toFlexible()
              ].toColumn();
      },
    );
  }

  Widget _updatePassword() {
    return [
      11.toSizedBox,
      Strings.currentPassword
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.oldPasswordValidator),
      11.toSizedBox,
      Strings.newPassword
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.newPasswordValidator),
      11.toSizedBox,
      Strings.confirmNewPassword.toTextField().toStreamBuilder(
          validators: userSettingCubit.confirmPasswordValidator),
      11.toSizedBox,
      LocaleKeys
          .before_changing_your_current_password_please_follow_these_tips_in
          .tr()
          .toCaption(
              fontWeight: FontWeight.w600,
              color: AppColors.colorPrimary,
              maxLines: 5)
          .toFlexible()
    ].toColumn();
  }

  Widget _verifyMyAccount() {
    return [
      11.toSizedBox,
      Strings.fullName.toTextField().toStreamBuilder(
          validators: userSettingCubit.verifyFullNameValidator),
      11.toSizedBox,
      Strings.messageToReceiver
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.verifyMessageValidator),
      15.toSizedBox,
      LocaleKeys.video_message.tr().toSubTitle2(fontWeight: FontWeight.w600),
      5.toSizedBox,
      LocaleKeys.please_select_a_video_appeal_to_the_reviewer
          .tr()
          .toSubTitle2(align: TextAlign.center)
          .toTextStreamBuilder(
              userSettingCubit.videoPath.map((event) => event.split('/').last))
          .toPadding(18)
          .toContainer(color: AppColors.sfBgColor, alignment: Alignment.center)
          .onTapWidget(() async {
        await openMediaPicker(context, (media) {
          if (media != null && media.isNotEmpty)
            userSettingCubit.changeVideoPath(media);
        }, mediaType: MediaTypeEnum.VIDEO);
      }),
      15.toSizedBox,
      LocaleKeys
          .please_note_that_this_material_will_not_be_published_or_shared_wi
          .tr()
          .toCaption(
              fontWeight: FontWeight.w600,
              color: AppColors.colorPrimary,
              maxLines: 10)
          .toFlexible()
    ].toColumn();
  }

  Widget _deleteAccount() {
    return [
      11.toSizedBox,
      Strings.password
          .toTextField()
          .toStreamBuilder(validators: userSettingCubit.deleteAccountValidator),
      11.toSizedBox,
      LocaleKeys
          .please_note_that_after_deleting_your_account_all_your_publication
          .tr()
          .toCaption(
              fontWeight: FontWeight.w600,
              color: AppColors.colorPrimary,
              maxLines: 5)
          .toFlexible()
    ].toColumn();
  }

  Widget _updateCountry() {
    return StreamBuilder<SettingEntity>(
      stream: userSettingCubit.settingEntity,
      builder: (context, snapshot) {
        return snapshot.data == null
            ? const SizedBox()
            : StreamBuilder<List<String>>(
                stream: userSettingCubit.countries,
                initialData: [],
                builder: (context, countrySnapshot) {
                  return [
                    11.toSizedBox,
                    SmartSelect<String>.single(
                      modalFilter: true,
                      modalFilterBuilder: (ctx, cont) => TextField(
                        decoration: InputDecoration(
                          hintStyle: context.subTitle1
                              .copyWith(fontWeight: FontWeight.w600),
                          hintText: "Search Country",
                          border: InputBorder.none,
                        ),
                        onChanged: (s) {
                          cont.apply(s);
                        },
                      ),
                      choiceStyle: S2ChoiceStyle(
                          titleStyle: context.subTitle2
                              .copyWith(fontWeight: FontWeight.w600)),
                      modalConfig: S2ModalConfig(
                        title: "Country",
                        headerStyle: S2ModalHeaderStyle(
                          textStyle: context.subTitle1.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      modalType: S2ModalType.fullPage,
                      value: snapshot.data.country,
                      onChange: (s) {
                        userSettingCubit
                          ..changeSettingEntity(
                            snapshot.data.copyWith(
                              country: s.value,
                            ),
                          );
                        //   ..gender = s.value;
                      },
                      tileBuilder: (c, s) => ListTile(
                        trailing: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 14,
                        ),
                        onTap: () {
                          s.showModal();
                        },
                        title: LocaleKeys.logout
                            .tr()
                            .toSubTitle2(fontWeight: FontWeight.w600),
                        subtitle: snapshot.data.country
                            .toCaption(fontWeight: FontWeight.w600),
                      ),
                      choiceItems: countrySnapshot.data
                          .toList()
                          .map((e) => S2Choice(
                                value: e,
                                title: e,
                              ))
                          .toList(),
                    ),
                    11.toSizedBox,
                    ListTile(
                      title: LocaleKeys
                          .choose_the_country_in_which_you_live_this_information_will_be_pub
                          .tr()
                          .toCaption(
                              fontWeight: FontWeight.w600,
                              color: AppColors.colorPrimary,
                              maxLines: 5),
                    ).toFlexible()
                  ].toColumn();
                },
              );
      },
    );
  }

  String _getButtonText(UpdateSettingEnum updateSettingEnum) {
    String title = "";
    switch (updateSettingEnum) {
      case UpdateSettingEnum.VERIFY_MY_ACCOUNT:
        title = LocaleKeys.submit_request.tr();
        break;
      case UpdateSettingEnum.DELETE_ACCOUNT:
        title = LocaleKeys.delete_account.tr();
        break;
      default:
        title = LocaleKeys.save_changes.tr();
        break;
    }
    return title;
  }

  Widget _changeLanguage() {
    return StreamBuilder<SettingEntity>(
      stream: userSettingCubit.settingEntity,
      builder: (context, snapshot) {
        return snapshot.data == null
            ? const SizedBox()
            : StreamBuilder<List<String>>(
                stream: userSettingCubit.languages,
                initialData: [],
                builder: (context, countrySnapshot) => [
                  11.toSizedBox,
                  SmartSelect<String>.single(
                    modalFilter: true,
                    modalFilterBuilder: (ctx, cont) => TextField(
                      decoration: InputDecoration(
                        hintStyle: context.subTitle1
                            .copyWith(fontWeight: FontWeight.w600),
                        hintText: "Search Language",
                        border: InputBorder.none,
                      ),
                      onChanged: (s) {
                        cont.apply(s);
                      },
                    ),
                    choiceStyle: S2ChoiceStyle(
                      titleStyle: context.subTitle2.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // title
                    modalConfig: S2ModalConfig(
                      title: LocaleKeys.language.tr(),
                      headerStyle: S2ModalHeaderStyle(
                        textStyle: context.subTitle1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    modalType: S2ModalType.fullPage,
                    value: snapshot.data.displayLanguage,
                    onChange: (s) => userSettingCubit
                      ..changeSettingEntity(
                        snapshot.data.copyWith(
                          displayLang: s.value,
                        ),
                      )
                      ..changeSelectedLang(s.value),
                    // Tile before choice
                    tileBuilder: (c, s) => ListTile(
                      trailing: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 14,
                      ),
                      onTap: () => s.showModal(),
                      title: LocaleKeys.select_display_language
                          .tr()
                          .toSubTitle2(fontWeight: FontWeight.w600),
                      subtitle: allLanguagesMap[snapshot.data.displayLanguage]
                          .toCaption(fontWeight: FontWeight.w600),
                    ),

                    choiceItems: countrySnapshot.data
                        .toList()
                        .map(
                          (e) => S2Choice(
                            value: e,
                            title: allLanguagesMap[e],
                          ),
                        )
                        .toList(),
                  ),
                  11.toSizedBox,
                  ListTile(
                    title: LocaleKeys
                        .choose_your_preferred_language_for_your_account_interface_this_do
                        .tr()
                        .toCaption(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorPrimary,
                            maxLines: 5),
                  ).toFlexible()
                ].toColumn(),
              );
      },
    );
  }

  @override
  void dispose() {
    userSettingCubit.resetAllData();
    userSettingCubit.newPasswordValidator..textController.clear();
    userSettingCubit.oldPasswordValidator..textController.clear();
    userSettingCubit.confirmPasswordValidator..textController.clear();
    super.dispose();
  }
}

enum UpdateSettingEnum {
  USERNAME,
  EMAIL,
  PHONENUMBER,
  BIRTHDAY,
  INSTAGRAM,
  TICTOK,
  TWITTER,
  SNAPCHAT,
  SCHOOLNAME,
  DIVISIONCONFERENCE,
  EDUAWARDS,
  GPA,
  SPORTS,
  CITY,
  STATEPROFILE,
  LEVEL,
  MONETIZATION,
  SERVICEHOUR,
  AWARDS,
  WEBSITE,
  ABOUT_YOU,
  GENDER,
  COUNTRY,
  PASSWORD,
  VERIFY_MY_ACCOUNT,
  CHANGE_LANGUAGE,
  DELETE_ACCOUNT,
}
