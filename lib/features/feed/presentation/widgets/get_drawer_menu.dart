import 'package:colibri/features/feed/presentation/widgets/drawer_list_tile.dart';
import 'package:colibri/features/feed/presentation/widgets/drawer_properties.dart';
import '../../../../core/common/widget/common_divider.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../../core/constants/appconstants.dart';
import '../../../../core/routes/routes.gr.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/strings.dart';
import '../bloc/feed_cubit.dart';
import 'all_home_screens.dart';
import '../../../profile/domain/entity/profile_entity.dart';
import '../../../profile/presentation/pages/followers_following_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/extensions/widget_extensions.dart';
import 'package:auto_route/src/extended_navigator.dart';
import '../../../../extensions.dart';
import 'package:easy_localization/easy_localization.dart';

class GetDrawerMenu extends StatefulWidget {
  final ProfileEntity profileEntity;

  const GetDrawerMenu({Key key, this.profileEntity}) : super(key: key);

  @override
  _GetDrawerMenuState createState() => _GetDrawerMenuState();
}

class _GetDrawerMenuState extends State<GetDrawerMenu> {
  @override
  Widget build(BuildContext context) {
    //return getDrawerMenu();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.profileEntity.profileUrl
                .toRoundNetworkImage(radius: 17)
                .onTapWidget(() {
              ExtendedNavigator.root.pop();
              ExtendedNavigator.root.push(Routes.profileScreen,
                  arguments: ProfileScreenArguments(otherUserId: null));
            }),
            SizedBox(height: AC.getDeviceHeight(context) * 0.005),
            Row(
              children: [
                widget.profileEntity.fullName.toSubTitle1(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontFamily1: "CeraPro",
                  fontSize: AC.getDeviceHeight(context) * 0.03,
                ),
                AppIcons.verifiedIcons
                    .toContainer()
                    .toVisibility(widget.profileEntity.isVerified),
              ],
            ),
            2.toSizedBox,
            Text(
              widget.profileEntity.userName,
              style: TextStyle(
                fontSize: AC.getDeviceHeight(context) * 0.02,
                color: Color(0xFF737880),
                fontWeight: FontWeight.w400,
                fontFamily: "CeraPro",
              ),
            ),
            20.toSizedBox,
            Row(
              children: [
                // Expanded(
                //   flex: 3,
                //   child: DrawerProperties(
                //     number: widget.profileEntity.postCounts,
                //     text: LocaleKeys.posts.tr(),
                //     function: () {
                //       ExtendedNavigator.root.push(Routes.profileScreen);
                //     },
                //   ),
                // ),
                DrawerProperties(
                    number: widget.profileEntity.followingCount,
                    text: LocaleKeys.following.tr(),
                    function: () {
                      ExtendedNavigator.root.pop();
                      ExtendedNavigator.root.push(
                        Routes.followingFollowersScreen,
                        arguments: FollowingFollowersScreenArguments(
                          followScreenEnum: FollowUnFollowScreenEnum.FOLLOWING,
                        ),
                      );
                    }),
                10.toSizedBoxHorizontal,
                DrawerProperties(
                  number: widget.profileEntity.followerCount,
                  text: LocaleKeys.followers.tr(),
                  function: () {
                    ExtendedNavigator.root.pop();
                    ExtendedNavigator.root.push(
                      Routes.followingFollowersScreen,
                      arguments: FollowingFollowersScreenArguments(
                        followScreenEnum: FollowUnFollowScreenEnum.FOLLOWERS,
                      ),
                    );
                  },
                ),
              ],
            ),
            20.toSizedBox,
            commonDivider,
            20.toSizedBox,
            SingleChildScrollView(
              child: Column(
                children: [
                  DrawerListTile(
                      icon: AppIcons.drawerHome1,
                      text: LocaleKeys.home.tr(),
                      onTap: () {
                        ExtendedNavigator.root.pop();
                        BlocProvider.of<FeedCubit>(context)
                            .changeCurrentPage(const ScreenType.home());
                      }),
                  20.toSizedBox,
                  DrawerListTile(
                      icon: AppIcons.drawerMessage1,
                      text: LocaleKeys.messages.tr(),
                      onTap: () {
                        ExtendedNavigator.root.pop();
                        BlocProvider.of<FeedCubit>(context)
                            .changeCurrentPage(const ScreenType.message());
                      }),
                  20.toSizedBox,
                  DrawerListTile(
                      icon: AppIcons.drawerBookmark1,
                      text: LocaleKeys.bookmarks.tr(),
                      onTap: () {
                        ExtendedNavigator.root.pop();
                        BlocProvider.of<FeedCubit>(context)
                            .changeCurrentPage(const ScreenType.bookmarks());
                      }),
                  20.toSizedBox,
                  DrawerListTile(
                      icon: AppIcons.drawerProfile1,
                      text: LocaleKeys.profile.tr(),
                      onTap: () {
                        ExtendedNavigator.root.pop();
                        ExtendedNavigator.root.push(Routes.profileScreen);
                      }),
                  20.toSizedBox,
                  DrawerListTile(
                      icon: AppIcons.drawerAdvertising,
                      text: LocaleKeys.advertising.tr(),
                      onTap: () {
                        ExtendedNavigator.root.pop();
                        ExtendedNavigator.root.push(
                          Routes.webViewScreen,
                          arguments: WebViewScreenArguments(
                            url: Strings.adsShow,
                            name: Strings.ads,
                          ),
                        );
                      }),
                  20.toSizedBox,
                  DrawerListTile(
                      icon: AppIcons.drawerAffiliates,
                      text: LocaleKeys.affiliates.tr(),
                      onTap: () {
                        ExtendedNavigator.root.pop();
                        ExtendedNavigator.root.push(
                          Routes.webViewScreen,
                          arguments: WebViewScreenArguments(
                            url: Strings.affiliates,
                            name: Strings.affiliatesStr,
                          ),
                        );
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget getDrawerMenu() {
  //   return Container(
  //     width: 100,
  //     height: 300,
  //     color: Colors.white,
  //     child: Stack(
  //       children: <Widget>[
  //         SizedBox(
  //           height: MediaQuery.of(context).size.height - 50,
  //           child: ListView(
  //             padding: EdgeInsets.only(top: AC.getDeviceHeight(context) * 0.3),
  //             children: [
  //               commonDivider,
  //               Padding(
  //                 padding: EdgeInsets.only(
  //                     left: 20,
  //                     right: 17,
  //                     top: AC.getDeviceHeight(context) * 0.03,
  //                     bottom: AC.getDeviceHeight(context) * 0.03),
  //                 child: InkWell(
  //                   onTap: () {
  //                     ExtendedNavigator.root.pop();
  //                     BlocProvider.of<FeedCubit>(context)
  //                         .changeCurrentPage(const ScreenType.home());
  //                   },
  //                   child: Row(
  //                     children: [
  //                       SizedBox(
  //                         height: AC.getDeviceHeight(context) * 0.030,
  //                         width: AC.getDeviceHeight(context) * 0.025,
  //                         child: AppIcons.drawerHome1,
  //                       ),
  //                       SizedBox(width: 15),
  //                       AutoSizeText(LocaleKeys.home.tr(),
  //                           style: TextStyle(
  //                               fontFamily: "CeraPro",
  //                               fontSize: AC.getDeviceHeight(context) * 0.022,
  //                               color: Colors.black,
  //                               fontWeight: FontWeight.w400))
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(
  //                     left: 19,
  //                     right: 20,
  //                     top: 0,
  //                     bottom: AC.getDeviceHeight(context) * 0.03),
  //                 child: InkWell(
  //                   onTap: () {
  //                     ExtendedNavigator.root.pop();
  //                     BlocProvider.of<FeedCubit>(context)
  //                         .changeCurrentPage(const ScreenType.message());
  //                   },
  //                   child: Row(
  //                     children: [
  //                       SizedBox(
  //                         height: AC.getDeviceHeight(context) * 0.030,
  //                         width: AC.getDeviceHeight(context) * 0.030,
  //                         child: AppIcons.drawerMessage1,
  //                       ),
  //                       SizedBox(width: 13),
  //                       AutoSizeText(
  //                         LocaleKeys.messages.tr(),
  //                         style: TextStyle(
  //                           fontFamily: "CeraPro",
  //                           fontSize: AC.getDeviceHeight(context) * 0.022,
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(
  //                     left: 20,
  //                     right: 20,
  //                     top: 0,
  //                     bottom: AC.getDeviceHeight(context) * 0.03),
  //                 child: InkWell(
  //                   onTap: () {
  //                     ExtendedNavigator.root.pop();
  //                     BlocProvider.of<FeedCubit>(context)
  //                         .changeCurrentPage(const ScreenType.bookmarks());
  //                   },
  //                   child: Row(
  //                     children: [
  //                       SizedBox(
  //                         height: AC.getDeviceHeight(context) * 0.030,
  //                         width: AC.getDeviceHeight(context) * 0.030,
  //                         child: AppIcons.drawerBookmark1,
  //                       ),
  //                       SizedBox(width: 12),
  //                       AutoSizeText(
  //                         LocaleKeys.bookmarks.tr(),
  //                         style: TextStyle(
  //                           fontFamily: "CeraPro",
  //                           fontSize: AC.getDeviceHeight(context) * 0.022,
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(
  //                     left: 20,
  //                     right: 20,
  //                     top: 0,
  //                     bottom: AC.getDeviceHeight(context) * 0.03),
  //                 child: InkWell(
  //                   onTap: () {
  //                     ExtendedNavigator.root.pop();
  //                     ExtendedNavigator.root.push(Routes.profileScreen);
  //                   },
  //                   child: Row(
  //                     children: [
  //                       SizedBox(
  //                         height: AC.getDeviceHeight(context) * 0.030,
  //                         width: AC.getDeviceHeight(context) * 0.030,
  //                         child: AppIcons.drawerProfile1,
  //                       ),
  //                       SizedBox(width: 13),
  //                       AutoSizeText(
  //                         LocaleKeys.profile.tr(),
  //                         style: TextStyle(
  //                           fontFamily: "CeraPro",
  //                           fontSize: AC.getDeviceHeight(context) * 0.022,
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(
  //                     left: 17,
  //                     right: 20,
  //                     top: 0,
  //                     bottom: AC.getDeviceHeight(context) * 0.03),
  //                 child: InkWell(
  //                   onTap: () {
  //                     ExtendedNavigator.root.pop();
  //                     ExtendedNavigator.root.push(
  //                       Routes.webViewScreen,
  //                       arguments: WebViewScreenArguments(
  //                         url: Strings.adsShow,
  //                         name: Strings.ads,
  //                       ),
  //                     );
  //                   },
  //                   child: Row(
  //                     children: [
  //                       SizedBox(
  //                         height: AC.getDeviceHeight(context) * 0.035,
  //                         width: AC.getDeviceHeight(context) * 0.035,
  //                         child: AppIcons.drawerAdvertising,
  //                       ),
  //                       const SizedBox(width: 11),
  //                       AutoSizeText(
  //                         LocaleKeys.advertising.tr(),
  //                         style: TextStyle(
  //                           fontFamily: "CeraPro",
  //                           fontSize: AC.getDeviceHeight(context) * 0.022,
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Padding(
  //                 padding: EdgeInsets.only(
  //                     left: 17,
  //                     right: 20,
  //                     top: 0,
  //                     bottom: AC.getDeviceHeight(context) * 0.03),
  //                 child: InkWell(
  //                   onTap: () {
  //                     ExtendedNavigator.root.pop();
  //                     ExtendedNavigator.root.push(
  //                       Routes.webViewScreen,
  //                       arguments: WebViewScreenArguments(
  //                         url: Strings.affiliates,
  //                         name: Strings.affiliatesStr,
  //                       ),
  //                     );
  //                   },
  //                   child: Row(
  //                     children: [
  //                       SizedBox(
  //                         height: AC.getDeviceHeight(context) * 0.035,
  //                         width: AC.getDeviceHeight(context) * 0.035,
  //                         child: AppIcons.drawerAffiliates,
  //                       ),
  //                       const SizedBox(width: 11),
  //                       AutoSizeText(
  //                         LocaleKeys.affiliates.tr(),
  //                         style: TextStyle(
  //                           fontFamily: "CeraPro",
  //                           fontSize: AC.getDeviceHeight(context) * 0.022,
  //                           color: Colors.black,
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         [
  //           [
  //             widget.profileEntity.profileUrl
  //                 .toRoundNetworkImage(radius: 17)
  //                 .onTapWidget(() {
  //               ExtendedNavigator.root.pop();
  //               ExtendedNavigator.root.push(Routes.profileScreen,
  //                   arguments: ProfileScreenArguments(otherUserId: null));
  //             })
  //           ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
  //           SizedBox(height: AC.getDeviceHeight(context) * 0.005),
  //           [
  //             widget.profileEntity.fullName
  //                 .toSubTitle1(
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.w400,
  //                     fontFamily1: "CeraPro",
  //                     fontSize: AC.getDeviceHeight(context) * 0.03)
  //                 .toFlexible(),
  //             5.toSizedBoxHorizontal,
  //             AppIcons.verifiedIcons
  //                 .toContainer()
  //                 .toVisibility(widget.profileEntity.isVerified)
  //           ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
  //           2.toSizedBox,
  //           Text(
  //             widget.profileEntity.userName,
  //             style: TextStyle(
  //               fontSize: AC.getDeviceHeight(context) * 0.02,
  //               color: Color(0xFF737880),
  //               fontWeight: FontWeight.w400,
  //               fontFamily: "CeraPro",
  //             ),
  //           ),
  //           20.toSizedBox,
  //           [
  //             [
  //               [
  //                 widget.profileEntity.postCounts.toSubTitle1(
  //                     color: AppColors.colorPrimary,
  //                     fontWeight: FontWeight.w400,
  //                     fontFamily1: "CeraPro",
  //                     fontSize: AC.getDeviceHeight(context) * 0.02),
  //                 SizedBox(height: AC.getDeviceHeight(context) * 0.002),
  //                 LocaleKeys.posts
  //                     .tr()
  //                     .toSubTitle2(
  //                       fontWeight: FontWeight.w400,
  //                       fontFamily1: "CeraPro",
  //                       fontSize: AC.getDeviceHeight(context) * 0.02,
  //                       color: const Color(0xFF8A8E95),
  //                     )
  //                     .onTapWidget(() {
  //                   ExtendedNavigator.root.push(Routes.profileScreen);
  //                 }),
  //               ].toColumn(crossAxisAlignment: CrossAxisAlignment.start),
  //               SizedBox(width: AC.getDeviceWidth(context) * 0.06),
  //               [
  //                 widget.profileEntity.followingCount.toSubTitle1(
  //                     color: AppColors.colorPrimary,
  //                     fontWeight: FontWeight.w400,
  //                     fontFamily1: "CeraPro",
  //                     fontSize: AC.getDeviceHeight(context) * 0.02),
  //                 SizedBox(height: AC.getDeviceHeight(context) * 0.002),
  //                 LocaleKeys.following.tr().toSubTitle2(
  //                       fontWeight: FontWeight.w400,
  //                       fontFamily1: "CeraPro",
  //                       color: const Color(0xFF8A8E95),
  //                       fontSize: AC.getDeviceHeight(context) * 0.02,
  //                     ),
  //               ]
  //                   .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
  //                   .onTapWidget(() {
  //                 ExtendedNavigator.root.pop();
  //                 ExtendedNavigator.root.push(
  //                   Routes.followingFollowersScreen,
  //                   arguments: FollowingFollowersScreenArguments(
  //                     followScreenEnum: FollowUnFollowScreenEnum.FOLLOWING,
  //                   ),
  //                 );
  //               }),
  //               SizedBox(width: AC.getDeviceWidth(context) * 0.06),
  //               [
  //                 widget.profileEntity.followerCount.toSubTitle1(
  //                     color: AppColors.colorPrimary,
  //                     fontWeight: FontWeight.w400,
  //                     fontFamily1: "CeraPro",
  //                     fontSize: AC.getDeviceHeight(context) * 0.02),
  //                 SizedBox(height: AC.getDeviceHeight(context) * 0.002),
  //                 LocaleKeys.followers.tr().toSubTitle2(
  //                       fontWeight: FontWeight.w400,
  //                       fontFamily1: "CeraPro",
  //                       fontSize: AC.getDeviceHeight(context) * 0.02,
  //                       color: const Color(0xFF8A8E95),
  //                     )
  //               ]
  //                   .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
  //                   .onTapWidget(() {
  //                 ExtendedNavigator.root.pop();
  //                 ExtendedNavigator.root.push(
  //                   Routes.followingFollowersScreen,
  //                   arguments: FollowingFollowersScreenArguments(
  //                     followScreenEnum: FollowUnFollowScreenEnum.FOLLOWERS,
  //                   ),
  //                 );
  //               }),
  //             ].toRow(mainAxisAlignment: MainAxisAlignment.start).toContainer(),
  //           ].toRow(),
  //         ].toColumn().toSymmetricPadding(16, 12).toContainer(
  //             height: AC.getDeviceHeight(context) * 0.3, color: Colors.white),
  //       ],
  //     ),
  //   ).toSafeArea;
  // }

}
