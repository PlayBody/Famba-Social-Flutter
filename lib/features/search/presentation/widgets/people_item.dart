import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/routes/routes.gr.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../extensions.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../domain/entity/people_entity.dart';

class PeopleItem extends StatelessWidget {
  final PeopleEntity peopleEntity;
  final VoidCallback onFollowTap;

  const PeopleItem({Key key, this.peopleEntity, this.onFollowTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return [
      20.toSizedBoxHorizontal,
      peopleEntity.profileUrl.toRoundNetworkImage(radius: 11),
      20.toSizedBoxHorizontal,
      [
        [
          peopleEntity.fullName
              .toSubTitle2(fontWeight: FontWeight.w600)
              .toEllipsis
              .toFlexible(),
          5.toSizedBoxHorizontal,
          AppIcons.verifiedIcons.toVisibility(peopleEntity.isVerified),
          5.toSizedBoxHorizontal
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
        peopleEntity.userName.toCaption(
            fontSize: 10.toSp,
            fontWeight: FontWeight.w600,
            color: Colors.black54)
      ].toColumn().toExpanded(),
      [
        if (peopleEntity.buttonText == 'Unfollow')
          peopleEntity.buttonText
              .toSubTitle2(color: Colors.white, fontWeight: FontWeight.w600)
              .toVerticalPadding(2)
              .toMaterialButton(() {
            context.showOkCancelAlertDialog(
                desc: LocaleKeys
                    .please_note_that_if_you_unsubscribe_then_this_user_s_posts_will_n
                    .tr(),
                title: LocaleKeys.please_confirm_your_actions.tr(),
                onTapOk: () {
                  ExtendedNavigator.root.pop();
                  onFollowTap.call();
                },
                okButtonTitle: "UnFollow");
          })
        else
          peopleEntity.buttonText
              .toSubTitle2(
                color: AppColors.colorPrimary,
                fontWeight: FontWeight.w600,
              )
              .toVerticalPadding(2)
              .toOutlinedBorder(
            () {
              onFollowTap.call();
            },
          ).toContainer(
            height: 30,
            alignment: Alignment.topCenter,
          )
      ]
          .toRow(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center)
          .toContainer(alignment: Alignment.center)
          .toVisibility(!peopleEntity.isCurrentLoggedInUser),
      20.toSizedBoxHorizontal,
    ].toRow(crossAxisAlignment: CrossAxisAlignment.center).onTapWidget(
      () {
        ExtendedNavigator.root.push(
          peopleEntity.isCurrentLoggedInUser ? null : Routes.profileScreen,
          arguments: ProfileScreenArguments(
            otherUserId: peopleEntity.id,
          ),
        );
      },
    );
  }
}
