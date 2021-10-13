import 'colors.dart';
import 'images.dart';
import '../../extensions.dart';
import '../../features/feed/presentation/widgets/all_home_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppIcons {
  static Image appLogo = Images.logo.toAssetImage(height: 60, width: 60);
  // bottom app bar
  static const bottomBarSize = 18;
  static SvgPicture messageIcon(
          {num height = bottomBarSize,
          num width = bottomBarSize,
          ScreenType screenType}) =>
      Images.message.toSvg(
          height: height,
          width: width,
          color: screenType.maybeWhen(
              orElse: () => null, message: () => AppColors.colorPrimary));
  static SvgPicture notificationIcon({ScreenType screenType}) =>
      Images.notification.toSvg(
          height: bottomBarSize,
          width: bottomBarSize,
          color: screenType.maybeWhen(
              orElse: () => null, notification: () => AppColors.colorPrimary));
  static SvgPicture homeIcon(
          {num height = bottomBarSize,
          num width = bottomBarSize,
          ScreenType screenType}) =>
      Images.home.toSvg(
          height: height,
          width: width,
          color: screenType.maybeWhen(
              orElse: () => null, home: () => AppColors.colorPrimary));
  static SvgPicture searchIcon({ScreenType screenType}) => Images.search.toSvg(
      height: bottomBarSize,
      width: bottomBarSize,
      color: screenType.maybeWhen(
          orElse: () => null, search: () => AppColors.colorPrimary));
  static SvgPicture addIcon =
      Images.add.toSvg(height: bottomBarSize, width: bottomBarSize);

  // create post icon
  static SvgPicture gifIcon({bool enabled = true}) => Images.gif.toSvg(
      height: 13,
      width: 13,
      color: enabled
          ? AppColors.colorPrimary
          : AppColors.colorPrimary.withOpacity(.5));
  static SvgPicture videoIcon({bool enabled = true}) => Images.video.toSvg(
      height: 13,
      width: 13,
      color: enabled
          ? AppColors.colorPrimary
          : AppColors.colorPrimary.withOpacity(.5));
  static SvgPicture smileIcon =
      Images.smile.toSvg(height: 18, width: 18, color: AppColors.colorPrimary);
  static SvgPicture imageIcon(
          {bool enabled = true, num height = 18, num width = 18}) =>
      Images.image.toSvg(
          height: height,
          width: width,
          color: enabled
              ? AppColors.colorPrimary
              : AppColors.colorPrimary.withOpacity(.5));
  static SvgPicture pollIcon =
      Images.poll.toSvg(height: 18, width: 18, color: AppColors.colorPrimary);
  static SvgPicture createSearchIcon = Images.createSearch
      .toSvg(height: 18, width: 18, color: AppColors.colorPrimary);

  // social bar
  static Widget drawerIcon({num height = 5, num width = 5}) => Images.drawer
      .toSvg(height: height.toHeight, width: width.toWidth)
      .toPadding(8);
  // static Widget likeIcon = Images.likeOption.toSvg();
  static Widget likeIcon({Color color}) =>
      Images.likeOption.toSvg(height: 14, width: 14, color: color);
  // static Widget heartIcon = Images.heart.toSvg();
  static Widget heartIcon({Color color}) =>
      Images.heart.toSvg(height: 14, width: 14, color: color);
  static Widget commentIcon = Images.comment.toSvg(height: 14, width: 14);
  static Widget repostIcon({Color color}) =>
      Images.repost.toSvg(height: 14, width: 14, color: color);
  static Widget shareIcon = Images.share.toSvg(height: 14, width: 14);

  static Widget messageIcon1 = Images.messageIcon.toSvg();
  static Widget rePostIcon1({Color color}) =>
      Images.rePostIcon.toSvg(height: 14, width: 14, color: color);
  // static Widget rePostIcon1 = Images.rePostIcon.toSvg();
  static Widget shareIcon1 = Images.shareIcon.toSvg();

  //drawer
  static Widget drawerHome =
      Images.drawerHome.toSvg(height: drawerMenuSize, width: drawerMenuSize);
  static Widget drawerHome1 = Images.drawerHome1.toSvg();
  static Widget drawerMessage = Images.drawerMessage.toSvg();
  static Widget drawerMessage1 = Images.drawerMessage1.toSvg();
  static Widget drawerBookmark({double size = drawerMenuSize}) =>
      Images.drawerBookmark
          .toSvg(height: size, width: size, color: AppColors.optionIconColor);
  static Widget drawerBookmark1 = Images.drawerBookmark1.toSvg();
  static Widget drawerProfile =
      Images.drawerProfile.toSvg(height: drawerMenuSize, width: drawerMenuSize);
  static Widget drawerProfile1 =
      Images.drawerUser1.toSvg(height: 30, width: 30);
  static Widget drawerSetting =
      Images.drawerSetting.toSvg(height: drawerMenuSize, width: drawerMenuSize);
  static Widget verifiedIcons =
      Images.verified.toSvg(height: 15.0, width: 15.0);
  static Widget signOut =
      Images.signOut.toSvg(height: drawerMenuSize, width: drawerMenuSize);
  static Widget drawerAdvertising = Images.advertising.toSvg();
  static Widget drawerAffiliates = Images.drawer_affiliates.toSvg();
  static Widget drawerWallet = Images.drawerWallet.toSvg();

  static Widget usIcon = Images.usIcon.toSvg(height: 10, width: 10);
  static Widget folderIcon = Images.folderIcon.toSvg(height: 10, width: 10);
  static Widget optionIcon =
      Images.optionsIcon.toSvg(height: 20, width: 20, color: Colors.black87);
  static Widget messageProfile({num size = 20}) =>
      Images.messageProfileIcon.toSvg(height: size, width: size);

  //option menu
  static Widget deleteOption({double size = drawerMenuSize}) =>
      Images.deleteOption
          .toSvg(height: size, width: size, color: AppColors.optionIconColor);
  static Widget likeOption({double size = drawerMenuSize, Color color}) =>
      Images.likeOption.toSvg(height: size, width: size, color: color);
  static Widget bookmarkOption({double size = drawerMenuSize}) =>
      Images.bookmarkOption
          .toSvg(height: size, width: size, color: AppColors.optionIconColor);
  static Widget personOption(
          {double size = drawerMenuSize,
          Color color = AppColors.optionIconColor}) =>
      Images.personOption.toSvg(height: size, width: size, color: color);
}

const drawerMenuSize = 20.0;
