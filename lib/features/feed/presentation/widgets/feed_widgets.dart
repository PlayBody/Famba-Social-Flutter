import 'package:auto_route/auto_route.dart';
import '../../../../core/common/widget/common_divider.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../../core/common/add_thumbnail/check_link.dart';
import '../../../../core/common/social_share/social_share.dart';
import '../../../../core/common/widget/menu_item_widget.dart';
import '../../../../core/constants/appconstants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/routes.gr.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/slider.dart';
import '../../../../extensions.dart';
import '../../domain/entity/post_entity.dart';
import '../pages/feed_screen.dart';
import '../../../posts/domain/entiity/reply_entity.dart';
import '../../../posts/presentation/bloc/post_cubit.dart';
import '../../../posts/presentation/pages/create_post.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remove_emoji/remove_emoji.dart';
import 'package:easy_localization/easy_localization.dart';

class PostItem extends StatefulWidget {
  final bool isComeHome;
  final bool showThread;
  final bool showArrowIcon;
  final bool otherUser;
  final bool isLiked;
  final PostEntity postEntity;
  final VoidCallback onLikeTap;
  final VoidCallback onTapRepost;
  final StringToVoidFunc onPostOptionItem;
  final bool detailedPost;
  final VoidCallback onRefresh;
  final ValueChanged<String> onTapMention;

  final ValueChanged<bool> replyCountIncreased;

  final bool insideSearchScreen;

  final ProfileNavigationEnum profileNavigationEnum;
  const PostItem({
    Key key,
    this.isComeHome = true,
    this.showThread = true,
    this.showArrowIcon = false,
    this.detailedPost = false,
    this.otherUser = false,
    this.isLiked = false,
    this.postEntity,
    this.onLikeTap,
    this.onRefresh,
    this.onTapRepost,
    this.onPostOptionItem,
    this.onTapMention,
    this.profileNavigationEnum = ProfileNavigationEnum.FROM_FEED,
    this.insideSearchScreen = false,
    this.replyCountIncreased,
  }) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState(otherUser: otherUser);
}

class _PostItemState extends State<PostItem> {
  final bool otherUser;
  MySocialShare mySocialShare;
  _PostItemState({this.otherUser = false});

  int currentIndex = 0;

  bool isKeyBoardShow = false;

  ScrollController _controller = new ScrollController();

  String url1 = "";

  @override
  void initState() {
    super.initState();
    mySocialShare = getIt<MySocialShare>();
    checkIsKeyBoardShow();
  }

  checkIsKeyBoardShow() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        if (visible) {
          scrollAnimated(1000);
        }
        isKeyBoardShow = visible;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _postItem(otherUser: this.otherUser);
  }

  Widget _postItem({otherUser = false}) {
    return Container(
      child: Column(children: [
        widget?.postEntity?.showRepostedText ?? false
            ? Padding(
                padding: EdgeInsets.only(
                  left: context.isArabic() ? 0 : 73,
                  right: !context.isArabic() ? 10 : 40,
                  top: AC.getDeviceHeight(context) * 0.018,
                ),
                child: Row(
                  children: [
                    AppIcons.repostIcon(),
                    12.toSizedBox,
                    "${widget.postEntity.reposterFullname.toString().toUpperCase()} REPOSTED"
                        .toSubTitle2(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          fontFamily1: "CeraPro",
                        )
                        .toEllipsis
                        .toFlexible()
                  ],
                ),
              )
            : Container(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            [
              Padding(
                padding: EdgeInsets.only(
                  top: AC.getDeviceHeight(context) * 0.013,
                  right: !context.isArabic() ? 10 : 0,
                  left: context.isArabic() ? 10 : 0,
                ),
                child: widget.postEntity.profileUrl
                    .toRoundNetworkImage(radius: 11)
                    .toContainer(alignment: Alignment.topRight)
                    .toVerticalPadding(0)
                    .onTapWidget(
                  () {
                    navigateToProfile();
                  },
                ),
              ),
            ]
                .toRow(mainAxisAlignment: MainAxisAlignment.end)
                .toVisibility(widget.detailedPost),
            [
              widget?.detailedPost ?? false
                  ? SizedBox(height: AC.getDeviceHeight(context) * 0.010)
                  : Container(),
              [
                [
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                    strutStyle: StrutStyle.disabled,
                    textWidthBasis: TextWidthBasis.longestLine,
                    text: TextSpan(
                      text: widget.postEntity.name,
                      style: context.subTitle1.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: AC.device17(context),
                        fontFamily: "CeraPro",
                      ),
                    ),
                  ).onTapWidget(() {
                    navigateToProfile();
                  }).toFlexible(flex: 2),
                  5.toSizedBoxHorizontal,
                  AppIcons.verifiedIcons
                      .toVisibility(widget.postEntity.postOwnerVerified),
                  5.toSizedBoxHorizontal,
                  Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Text(
                      widget.postEntity.time,
                      style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: AC.getDeviceHeight(context) * 0.015,
                        fontWeight: FontWeight.w400,
                        fontFamily: "CeraPro",
                      ),
                    ),
                  )
                ]
                    .toRow(crossAxisAlignment: CrossAxisAlignment.center)
                    .toFlexible(),
                6.toSizedBoxHorizontal
              ]
                  .toRow(crossAxisAlignment: CrossAxisAlignment.center)
                  .toContainer(),
              3.toSizedBoxVertical,
              InkWell(
                onTap: () {
                  navigateToProfile();
                },
                child: SizedBox(
                  height: 15,
                  child: Text(
                    widget.postEntity.userName,
                    style: TextStyle(
                      color: const Color(0xFF737880),
                      fontSize: AC.getDeviceHeight(context) * 0.015,
                      fontWeight: FontWeight.w400,
                      fontFamily: "CeraPro",
                    ),
                  ),
                ),
              ),
              5.toSizedBox.toVisibility(widget.postEntity.responseTo != null),
              [
                "In response to".toCaption(
                    fontSize: 13,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    color: AppColors.greyText),
                if (widget.postEntity.responseTo != null)
                  InkWell(
                    onTap: () {
                      ExtendedNavigator.root.push(
                        Routes.profileScreen,
                        arguments: ProfileScreenArguments(
                          otherUserId: widget.postEntity.isOtherUser
                              ? widget.postEntity.responseToUserId
                              : null,
                        ),
                      );
                    },
                    child: widget.postEntity.responseTo.toCaption(
                        color: AppColors.colorPrimary,
                        fontWeight: FontWeight.w600,
                        textOverflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ),
                LocaleKeys.post.tr().toCaption(
                    fontSize: 13,
                    textOverflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    color: AppColors.greyText)
              ].toWrap().toVisibility(widget.postEntity.responseTo != null &&
                  widget.postEntity.responseTo.isNotEmpty),
            ]
                .toColumn(mainAxisAlignment: MainAxisAlignment.center)
                .toExpanded(flex: 8),
            [
              InkWell(
                onTap: () {
                  bottomSheet();
                },
                child: Container(
                  height: 30,
                  width: 15,
                  margin: const EdgeInsets.only(top: 3, right: 10),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey.withOpacity(0.6),
                    size: 25,
                  ),
                ),
              )
            ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
          ],
        ).toHorizontalPadding(20),
        [
          if (!widget.detailedPost)
            20.toSizedBoxHorizontal
          else
            75.toSizedBoxHorizontal,
          [
            5.toSizedBox.toVisibility(widget.postEntity.responseTo != null),
            // TODO Important
            if (widget.postEntity.description.isNotEmpty)
              widget.postEntity.description.toSubTitle1(
                  fontWeight: FontWeight.w400,
                  align: TextAlign.left,
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily1: "CeraPro",
                  onTapHashtag: (hTag) {
                    if (!widget.insideSearchScreen)
                      ExtendedNavigator.root.push(
                        Routes.searchScreen,
                        arguments: SearchScreenArguments(
                          searchedText: RemoveEmoji().removemoji(hTag),
                        ),
                      );
                    else
                      BlocProvider.of<PostCubit>(context).searchedText = hTag;
                  },
                  onTapMention: (mention) {
                    ExtendedNavigator.root.push(Routes.profileScreen,
                        arguments:
                            ProfileScreenArguments(otherUserId: mention));
                  }),
            5.toSizedBox.toVisibility(widget.postEntity.description.isNotEmpty),
            const SizedBox(height: 5),
            // TODO Uncomment this when the developer responds
            // if (widget.postEntity.type == 'poll')
            //   PollContainer(widget.postEntity.poll)
            //  else
            Container(
              child: imageVideoSliderData(),
            ),
            5.toSizedBox.toVisibility(widget.postEntity.media.isNotEmpty),
            [
              [
                InkWell(
                  onTap: () async {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (c) => DraggableScrollableSheet(
                              initialChildSize: 1,
                              maxChildSize: 1,
                              minChildSize: 1,
                              expand: true,
                              builder: (BuildContext context,
                                      ScrollController scrollController) =>
                                  Container(
                                margin: EdgeInsets.only(
                                    top: MediaQueryData.fromWindow(
                                  WidgetsBinding.instance.window,
                                ).padding.top),
                                child: CreatePost(
                                  title: LocaleKeys.post_a_reply.tr(),
                                  replyTo: widget.postEntity.userName,
                                  threadId: widget.postEntity.postId,
                                  replyEntity: ReplyEntity.fromPostEntity(
                                    postEntity: widget.postEntity,
                                  ),
                                ),
                              ),
                            )).then((value) {
                      if (value != null && value)
                        widget.replyCountIncreased(true);
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Image(
                          height: 20,
                          width: 20,
                          image: AssetImage("images/png_image/message.png"),
                          color: Color(0xFF737880),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0, left: 5),
                        child: Text(
                          widget.postEntity.commentCount ?? "",
                          style: const TextStyle(
                              color: Color(0xFF737880),
                              fontFamily: "CeraPro",
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.onLikeTap.call();
                    print(widget.postEntity.postId);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Image(
                          height: 20,
                          width: 20,
                          image: AssetImage(widget.postEntity.isLiked
                              ? "images/png_image/heart.png"
                              : "images/png_image/like.png"),
                          color: widget.postEntity.isLiked
                              ? Colors.red
                              : Color(0xFF737880),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0, left: 5),
                        child: Text(
                          widget.postEntity.likeCount ?? "0",
                          style: TextStyle(
                              color: widget.postEntity.isLiked
                                  ? Colors.red
                                  : Color(0xFF737880),
                              fontFamily: "CeraPro",
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.onTapRepost.call();
                    if (!widget.postEntity.isReposted) {
                      context.showSnackBar(
                          message: LocaleKeys.reposted
                              .tr(namedArgs: {'@uname@': 'Post'}));
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Image(
                          height: widget.postEntity.isReposted ? 17 : 20,
                          width: widget.postEntity.isReposted ? 17 : 20,
                          image: AssetImage(widget.postEntity.isReposted
                              ? "images/png_image/blur_share.png"
                              : "images/png_image/re_post.png"),
                          color: widget.postEntity.isReposted
                              ? AppColors.alertBg
                              : Color(0xFF737880),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0, left: 5),
                        child: Text(
                          widget.postEntity.repostCount ?? "",
                          style: TextStyle(
                              color: widget.postEntity.isReposted
                                  ? AppColors.alertBg
                                  : Color(0xFF737880),
                              fontFamily: "CeraPro",
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
                const Image(
                  height: 20,
                  width: 20,
                  image: const AssetImage("images/png_image/share.png"),
                  color: const Color(0xFF737880),
                ).toPadding(0).onTapWidget(() {
                  mySocialShare.shareToOtherPlatforms(
                      text: widget.postEntity.urlForSharing);
                })
              ]
                  .toRow(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center)
                  .toExpanded(),
            ].toRow(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly),
            Container(
              height: 2,
            )
          ]
              .toColumn(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start)
              .toExpanded(flex: 10),
          10.toSizedBox.toExpanded(flex: 1)
        ].toRow(),
        commonDivider.toVisibility(widget.postEntity.isConnected),
        7.toSizedBox,
      ]),
      // TODO Change this visibility when developer responds
    ).toVisibility(widget.postEntity.type != 'poll');
  }

  Widget getPostOptionMenu(
      bool showThread, bool showArrowIcon, bool otherUser) {
    return [
      MenuItemWidget(
        text: !widget.postEntity.isSaved
            ? LocaleKeys.bookmark.tr()
            : LocaleKeys.unbookmark.tr(),
        icon: AppIcons.bookmarkOption(size: 16).toHorizontalPadding(2),
      ),
      MenuItemWidget(
        icon: AppIcons.likeOption(size: 14),
        text: LocaleKeys.show_likes.tr(),
      ),
      if (!widget.postEntity.isOtherUser)
        MenuItemWidget(
          text: LocaleKeys.delete.tr(),
          icon: AppIcons.deleteOption(size: 14).toHorizontalPadding(1),
        ),
    ]
        .toPopWithMenuItems((value) {
          widget.onPostOptionItem(value);
        },
            icon: showArrowIcon
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey.withOpacity(.8),
                    ),
                  )
                : AppIcons.optionIcon)
        .toContainer(
          alignment: Alignment.topCenter,
        )
        .toExpanded(flex: 1);
  }

  void navigateToProfile() {
    if (widget.postEntity.isOtherUser) {
      ExtendedNavigator.root.push(
        Routes.profileScreen,
        arguments: ProfileScreenArguments(
          otherUserId: widget.postEntity.userName.split("@")[0],
        ),
      );
    } else
      ExtendedNavigator.root.push(Routes.profileScreen);
  }

  bottomSheet() {
    print(widget.postEntity.isOtherUser);
    print(widget.postEntity.otherUserId);
    print(loginResponseFeed.data.user.userName);

    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
              height: widget.postEntity.isOtherUser &&
                      widget.postEntity.userName !=
                          "@${loginResponseFeed.data.user.userName}"
                  ? 150
                  : 150,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                left: 30,
                right: 30,
                top: 15,
                bottom: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff0e8df1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 6,
                    width: 37,
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                      color: const Color(0xff0560b2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        widget.postEntity.isOtherUser &&
                                widget.postEntity.userName !=
                                    "@${loginResponseFeed.data.user.userName}"
                            ? InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.onPostOptionItem('Show likes');
                                },
                                child: Container(
                                  height: 25,
                                  margin: const EdgeInsets.only(top: 30),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "images/png_image/white_like.png",
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        LocaleKeys.show_likes.tr(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "CeraPro",
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        InkWell(
                          onTap: () {
                            widget.onPostOptionItem(
                              !widget.postEntity.isSaved
                                  ? 'Bookmark'
                                  : "UnBookmark",
                            );
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 25,
                            margin: const EdgeInsets.only(top: 15),
                            child: Row(
                              children: [
                                Image.asset("images/png_image/book_mark.png"),
                                const SizedBox(width: 20),
                                Text(
                                  !widget.postEntity.isSaved
                                      ? 'Bookmark'
                                      : "UnBookmark",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "CeraPro",
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // TODO uncomment this when the developer responds
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //     widget.onPostOptionItem('Report Post');
                        //   },
                        //   child: Container(
                        //     height: 25,
                        //     margin: const EdgeInsets.only(top: 15),
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.report_outlined,
                        //           color: Colors.white,
                        //         ),
                        //         const SizedBox(width: 20),
                        //         Text(
                        //           LocaleKeys.report_post.tr(),
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.w400,
                        //             fontFamily: "CeraPro",
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        widget.postEntity.isOtherUser &&
                                widget.postEntity.userName !=
                                    "@${loginResponseFeed.data.user.userName}"
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  print("Hel");
                                  Navigator.pop(context);
                                  widget.onPostOptionItem('Delete');
                                },
                                child: Container(
                                  height: 25,
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          "images/png_image/delete_trash.png"),
                                      const SizedBox(width: 20),
                                      Text(
                                        LocaleKeys.delete.tr(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "CeraPro",
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  reportBottomSheet() {
    return showMaterialModalBottomSheet(
      context: context,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: 525,
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
            decoration: const BoxDecoration(
              color: const Color(0xFFFFFFFF),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(-1, 1),
                )
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Color(0xFF1D88F0).withOpacity(0.09),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 6,
                          width: 37,
                          margin: EdgeInsets.only(bottom: 5, top: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF045CB1).withOpacity(0.1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          LocaleKeys.report_this_post.tr(),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "CeraPro",
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  controller: _controller,
                  padding: EdgeInsets.only(
                      left: 15,
                      right: 10,
                      top: 5,
                      bottom: isKeyBoardShow ? 310 : 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 25,
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                LocaleKeys.what_is_the_problem.tr(),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "CeraPro",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            )),
                      ),
                      const SizedBox(height: 15),
                      radioSelection(LocaleKeys.this_is_spam.tr(), 0, setState),
                      const SizedBox(height: 20),
                      radioSelection(
                        LocaleKeys.misleading_or_fraudulent.tr(),
                        1,
                        setState,
                      ),
                      const SizedBox(height: 20),
                      radioSelection(
                        LocaleKeys.publication_of_private_information.tr(),
                        2,
                        setState,
                      ),
                      const SizedBox(height: 20),
                      radioSelection(
                        LocaleKeys.threats_of_violence_or_physical_harm.tr(),
                        3,
                        setState,
                      ),
                      const SizedBox(height: 20),
                      radioSelection(
                        LocaleKeys.i_am_not_interested_in_this_post.tr(),
                        4,
                        setState,
                      ),
                      const SizedBox(height: 20),
                      radioSelection("Other", 5, setState),
                      Container(
                        height: 2,
                        width: MediaQuery.of(context).size.width - 100,
                        margin: const EdgeInsets.only(top: 15, bottom: 20),
                        decoration: BoxDecoration(
                            color: const Color(0xFFE0EDF6),
                            borderRadius: BorderRadius.circular(1)),
                      ),
                      Text(
                        LocaleKeys.message_to_reviewer.tr(),
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "CeraPro",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        height: 80,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            color: Color(0xFFD8D8D8).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8)),
                        child: TextField(
                          maxLines: 5,
                          textInputAction: TextInputAction.newline,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: "CeraPro"),
                          decoration: InputDecoration(
                            hintText: LocaleKeys
                                .please_write_briefly_about_the_problem_with_this_post
                                .tr(),
                            hintStyle: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              fontFamily: "CeraPro",
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 32,
                          width: 88,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Color(0xFF1D89F1),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            LocaleKeys.send_report.tr(),
                            style: TextStyle(
                              color: Color(0xFF1D89F1),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
              ],
            ),
          );
        },
      ),
    );
  }

  radioSelection(String title, int index, StateSetter updateState) {
    return InkWell(
      onTap: () {
        currentIndex = index;
        updateState(() {});
      },
      child: Row(
        children: [
          Container(
            height: 15,
            width: 15,
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: currentIndex == index ? Color(0xFF1D89F1) : Colors.black,
                width: 1,
              ),
            ),
            child: currentIndex == index
                ? Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  )
                : Container(),
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: "CeraPro",
              ),
            ),
          )
        ],
      ),
    );
  }

  void scrollAnimated(double position) {
    _controller.animateTo(position,
        curve: Curves.ease, duration: Duration(seconds: 1));
  }

  checkLinkBool() {
    if (CheckLink.checkYouTubeLink(widget.postEntity.description) != null) {
      return true;
    } else if (widget?.postEntity?.ogData != null &&
        widget?.postEntity?.ogData != "") {
      if (CheckLink.checkYouTubeLink(widget?.postEntity?.ogData['url'] ?? "") !=
          null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  imageVideoSliderData() {
    print(widget?.postEntity?.ogData);

    if (widget.postEntity.media.length != 0 ||
        (widget?.postEntity?.ogData != null &&
            widget?.postEntity?.ogData != "" &&
            widget.postEntity.ogData.length != 0 &&
            widget?.postEntity?.ogData['url'] != null &&
            widget.postEntity.ogData['url'] != "")) {
      return CustomSlider(
        isComeHome: widget.isComeHome,
        mediaItems: widget?.postEntity?.media,
        postEntity: widget?.postEntity,
        ogData: widget.postEntity.ogData,
        isOnlySocialLink: checkLinkBool(),
        onClickAction: (int index) {
          if (index == 0) {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (c) => DraggableScrollableSheet(
                      initialChildSize: 1,
                      maxChildSize: 1,
                      minChildSize: 1,
                      expand: true,
                      builder: (BuildContext context,
                              ScrollController scrollController) =>
                          Container(
                        margin: EdgeInsets.only(
                            top: MediaQueryData.fromWindow(
                                    WidgetsBinding.instance.window)
                                .padding
                                .top),
                        child: CreatePost(
                          title: "Reply",
                          replyTo: widget.postEntity.userName,
                          backData: (value) {
                            if (value != null && value)
                              widget.replyCountIncreased(true);
                          },
                          threadId: widget.postEntity.postId,
                          replyEntity: ReplyEntity.fromPostEntity(
                              postEntity: widget.postEntity),
                        ),
                      ),
                    )).then((value) {
              if (value != null && value) widget.replyCountIncreased(true);
            });
          } else if (index == 1) {
            widget.onLikeTap.call();
          } else if (index == 2) {
            widget.onTapRepost.call();
            if (!widget.postEntity.isReposted) {
              context.showSnackBar(message: LocaleKeys.reposted.tr());
            }
          } else if (index == 3) {
            mySocialShare.shareToOtherPlatforms(
                text: widget.postEntity.urlForSharing);
          }
        },
      );
    } else
      Container();
  }
}

enum PostOptionsEnum { SHOW_LIKES, BOOKMARK, DELETE, REPORT }

Widget buildPostButton(Widget icon, String count,
    {bool isLiked = false, Color color}) {
  return [
    icon,
    5.toSizedBox,
    count.toBody2(
        fontWeight: FontWeight.w600,
        color: isLiked ? color : AppColors.textColor)
  ].toRow(crossAxisAlignment: CrossAxisAlignment.center);
}

Widget getShareOptionMenu(
    {MySocialShare share, String text, List<String> files}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: [
      "Facebook",
      "Twitter",
      "LinkedIn",
      "Pinterest",
      "Reddit",
      "Copy Link"
    ].toPopUpMenuButton((value) {
      share?.shareToOtherPlatforms(text: text, files: files);
    }, icon: AppIcons.shareIcon).toContainer(height: 15, width: 15),
  );
}
