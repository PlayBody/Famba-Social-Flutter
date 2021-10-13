import 'package:auto_route/auto_route.dart';
import '../../../../core/common/buttons/custom_button.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entity/setting_entity.dart';
import '../bloc/settings/user_setting_cubit.dart';
import '../pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_select/smart_select.dart';
import '../../../../extensions.dart';

class PrivacyScreen extends StatefulWidget {
  final List<PrivacyWidgetModel> privacyModels;

  const PrivacyScreen({Key key, this.privacyModels}) : super(key: key);

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  UserSettingCubit userSettingCubit;
  @override
  void initState() {
    super.initState();
    userSettingCubit = BlocProvider.of<UserSettingCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: "Account Privacy".toSubTitle1(fontWeight: FontWeight.w600),
              tileColor: AppColors.sfBgColor,
            ),
            // generating lists with title and options
            _generateItem(widget.privacyModels.sublist(0, 2)),
            _generateItem(widget.privacyModels.sublist(2, 4)),
            _generateItem(widget.privacyModels.sublist(4, 6)),
            CustomButton(
                text: "Save",
                onTap: () {
                  ExtendedNavigator.root.pop();
                  userSettingCubit.updateUserPrivacy();
                }).toPadding(16)
          ],
        ),
      ),
    );
  }

  _generateItem(List<PrivacyWidgetModel> items) {
    return StreamBuilder<SettingEntity>(
        stream: userSettingCubit.settingEntity,
        builder: (context, snapshot) {
          return snapshot.data == null
              ? const SizedBox()
              : SmartSelect.single(
                  value:
                      items.firstWhere((element) => element.isSelected)?.value,
                  modalStyle: const S2ModalStyle(
                      clipBehavior: Clip.hardEdge,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10)))),
                  choiceConfig: S2ChoiceConfig(
                      isGrouped: true,
                      style: S2ChoiceStyle(
                          titleStyle: context.subTitle2
                              .copyWith(fontWeight: FontWeight.w600)),
                      useDivider: true),
                  modalConfig: S2ModalConfig(
                      headerStyle: S2ModalHeaderStyle(
                          textStyle: context.subTitle1
                              .copyWith(fontWeight: FontWeight.w600))),
                  modalType: S2ModalType.bottomSheet,
                  choiceGrouped: false,
                  title: PrivacyWidgetModel.getEnumValue(
                      items[0].privacyOptionEnum),
                  choiceItems: items
                      .map((e) => S2Choice(
                          value: e.value,
                          title: e.value,
                          group: PrivacyWidgetModel.getEnumValue(
                              e.privacyOptionEnum)))
                      .toList(),
                  onChange: (s) {
                    var settingItem = snapshot.data;
                    // getting item 0 enum value to update the settings accordingly
                    switch (items[0].privacyOptionEnum) {
                      case PrivacyOptionEnum.PROFILE_VISIBILITY:
                        userSettingCubit.changeSettingEntity(
                            settingItem.copyWith(
                                accountPrivacyEntity: settingItem
                                    .accountPrivacyEntity
                                    .copyWith(canSeeMyPosts: s.value)));
                        break;
                      case PrivacyOptionEnum.CONTACT_PRIVACY:
                        userSettingCubit.changeSettingEntity(
                            settingItem.copyWith(
                                accountPrivacyEntity: settingItem
                                    .accountPrivacyEntity
                                    .copyWith(canFollowMe: s.value)));
                        break;
                      case PrivacyOptionEnum.SEARCH_VISIBILITY:
                        userSettingCubit.changeSettingEntity(
                            settingItem.copyWith(
                                accountPrivacyEntity:
                                    settingItem.accountPrivacyEntity.copyWith(
                                        showProfileInSearchEngine: s.value)));
                        break;
                    }
                  },
                  choiceHeaderBuilder: (c, choice, text) => ListTile(
                    onTap: () {
                      // text
                    },
                    title: choice.name.toSubTitle1(fontWeight: FontWeight.w600),
                    tileColor: AppColors.sfBgColor,
                  ),
                  tileBuilder: (c, s) => ListTile(
                    onTap: () {
                      s.showModal();
                    },
                    title: PrivacyWidgetModel.getEnumValue(
                            items[0].privacyOptionEnum)
                        .toSubTitle2(fontWeight: FontWeight.w600),
                    subtitle: (s.value as String)
                        .toCaption(fontWeight: FontWeight.w600),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 14,
                    ),
                  ),
                );
        });
    // return SmartSelect.single(
    //   choiceGrouped: false,
    //
    //     title: PrivacyWidgetModel.getEnumValue(items[0].privacyOptionEnum),
    //     choiceItems: items.map((e) => S2Choice(value: e.value, title: e.value)).toList(), onChange: (s){}, value: null,);
  }
}
