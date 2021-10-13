import 'dart:async';

import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../../core/common/uistate/common_ui_state.dart';
import '../../../../core/constants/appconstants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/routes.gr.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../extensions.dart';
import '../../../authentication/data/models/login_response.dart';
import '../bloc/feed_cubit.dart';
import '../core/my_border_shape.dart';
import 'redeem_confirmation_screen.dart';
import '../widgets/all_home_screens.dart';
import '../widgets/get_drawer_menu.dart';
import '../../../messages/presentation/pages/message_screen.dart';
import '../../../notifications/presentation/pages/notification_screen.dart';
import '../../../posts/presentation/bloc/createpost_cubit.dart';
import '../../../posts/presentation/widgets/post_pagination_widget.dart';
import '../../../profile/domain/entity/profile_entity.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../../../profile/presentation/pages/settings_page.dart';
import '../../../search/presentation/pages/searh_screen.dart';
import '../../../../main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import '../../../profile/presentation/pages/bookmark_screen.dart';
import 'package:easy_localization/easy_localization.dart';

StreamController<double> controller = StreamController<double>.broadcast();
LoginResponse loginResponseFeed;

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FeedCubit feedCubit;
  CreatePostCubit createPostCubit;

  int prevIndex = 0;
  int currentIndex = 0;

  bool _isVisible = true;
  ScrollController _hideButtonController =
      ScrollController(keepScrollOffset: true);

  bool isKeyBoardShow = false;

  SearchScreen searScreen = const SearchScreen();

  bool isMessageShow = false;
  bool isNotificationShow = false;

  @override
  void initState() {
    super.initState();
    feedCubit = getIt<FeedCubit>()
      ..getUserData()
      ..saveNotificationToken();
    createPostCubit = getIt<CreatePostCubit>();

    _hideButtonController = ScrollController(keepScrollOffset: true);

    loginData();

    loginUserData();
    blurDotDataGet();
    updateData();
    checkIsKeyBoardShow();
  }

  loginData() {
    Future.delayed(
      Duration(seconds: 1),
      () async {
        AC.loginResponse = await localDataSource.getUserAuth();
      },
    );
  }

  loginUserData() async {
    loginResponseFeed = await localDataSource.getUserData();
  }

  blurDotDataGet() {
    if (AC.prefs.containsKey("message")) {
      isMessageShow = AC.prefs.getBool("message");
    } else {
      AC.prefs.setBool("message", false);
    }

    if (AC.prefs.containsKey("notification")) {
      isNotificationShow = AC.prefs.getBool("notification");
    } else {
      AC.prefs.setBool("notification", false);
    }
    setState(() {});
  }

  updateData() {
    Stream stream = controller.stream;
    stream.listen((value) {
      isMessageShow = AC.prefs.getBool("message");
      isNotificationShow = AC.prefs.getBool("notification");

      setState(() {});
    });
  }

  checkIsKeyBoardShow() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        isKeyBoardShow = visible;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();

    return MultiBlocProvider(
      providers: [
        BlocProvider<FeedCubit>(create: (c) => feedCubit),
        BlocProvider<CreatePostCubit>(create: (c) => createPostCubit)
      ],
      child: BlocListener<FeedCubit, CommonUIState>(
        listener: (_, state) {
          state.maybeWhen(
            orElse: () {},
            error: (e) => context.showSnackBar(message: e, isError: true),
            success: (s) {
              if (s is String) {
                if (s.toLowerCase().contains(LocaleKeys.logout.tr())) {
                  ExtendedNavigator.root.pushAndRemoveUntil(
                    Routes.loginScreen,
                    (route) => false,
                  );
                }
                context.showSnackBar(message: s, isError: false);
              }
            },
          );
        },
        child: StreamBuilder<ScreenType>(
            stream: feedCubit.currentPage,
            initialData: const ScreenType.home(),
            builder: (context, snapshot) {
              return WillPopScope(
                onWillPop: () async {
                  if (currentIndex != 0) {
                    onTapBottomBar(0);
                    return false;
                  } else
                    return context.willPopScopeDialog();
                },
                child: Scaffold(
                  key: scaffoldKey,
                  extendBody: true,
                  drawer: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: scaffoldKey?.currentState?.isDrawerOpen != null &&
                              scaffoldKey.currentState.isDrawerOpen
                          ? Color(0xFF1D88F0).withOpacity(0.6)
                          : Colors.transparent,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: Container(
                        color: Colors.white,
                        height: context.getScreenHeight,
                        width: context.getScreenWidth / 1.3,
                        child: StreamBuilder<ProfileEntity>(
                          stream: feedCubit.drawerEntity,
                          builder: (context, snapshot) {
                            if (snapshot.data == null)
                              return Container(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(),
                                  ],
                                ),
                              );
                            return GetDrawerMenu(
                              profileEntity: snapshot.data,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  appBar: appBarShow(snapshot.data),
                  body: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      SafeArea(
                        bottom: false,
                        child: PageTransitionSwitcher(
                          reverse: doReverse(),
                          child: getSelectedHomeScreen(snapshot.data),
                          transitionBuilder: (Widget child,
                                  Animation<double> primaryAnimation,
                                  Animation<double> secondaryAnimation) =>
                              SharedAxisTransition(
                            animation: primaryAnimation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.horizontal,
                            child: child,
                          ),
                        ),
                      ),
                      currentIndex == 2
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              color: AppColors.alertBg.withOpacity(0.5),
                            )
                          : Container(),
                    ],
                  ),
                  bottomNavigationBar: Transform.translate(
                    offset: const Offset(0, -13),
                    child: Container(
                      height: _isVisible ? 51 : 0,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 5,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: MyBorderShape(),
                        shadows: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 2.0,
                            offset: Offset(1, 1),
                          )
                        ],
                      ),
                      child: Row(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              prevIndex = currentIndex;
                              currentIndex = 0;
                              feedCubit.onRefresh();
                              feedCubit
                                  .changeCurrentPage(const ScreenType.home());
                            },
                            child: Icon(
                              // TODO This is home icon
                              Icons.home_outlined,
                              color: snapshot.data == const ScreenType.home()
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, right: 5),
                            child: SizedBox(
                              height: 26,
                              width: 26,
                              child: InkWell(
                                onTap: () {
                                  // PushNotificationHelper.isMessageShow = false;
                                  isMessageShow = false;
                                  AC.prefs.setBool("message", false);
                                  prevIndex = currentIndex;
                                  currentIndex = 1;
                                  feedCubit.changeCurrentPage(
                                      const ScreenType.message());
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 1),
                                  child: Stack(
                                    children: [
                                      Icon(
                                        // TODO This is Messages icon
                                        Icons.mail_outline,
                                        color: snapshot.data ==
                                                ScreenType.message()
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      Positioned(
                                        left: !context.isArabic() ? 40 : 0,
                                        right: context.isArabic() ? 40 : 0,
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          child: isMessageShow
                                              ? Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: AppColors.bottomMenu,
                                                    shape: BoxShape.circle,
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: !context.isArabic() ? 40 : 0,
                              right: context.isArabic() ? 40 : 0,
                            ),
                            child: SizedBox(
                              height: 26,
                              width: 26,
                              child: InkWell(
                                onTap: () {
                                  isNotificationShow = false;
                                  AC.prefs.setBool("notification", false);
                                  prevIndex = currentIndex;
                                  currentIndex = 3;
                                  feedCubit.changeCurrentPage(
                                    const ScreenType.notification(),
                                  );
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 1),
                                  child: Stack(
                                    children: [
                                      Icon(
                                        // TODO This is notifications icon
                                        Icons.notifications_outlined,
                                        color: snapshot.data ==
                                                ScreenType.notification()
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                      Positioned(
                                        right: !context.isArabic() ? 3 : null,
                                        top: 0,
                                        left: context.isArabic() ? 3 : null,
                                        child: Container(
                                          height: 5,
                                          width: 5,
                                          child: isNotificationShow
                                              ? Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.blue,
                                                    shape: BoxShape.circle,
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              prevIndex = currentIndex;
                              currentIndex = 4;
                              feedCubit.changeCurrentPage(
                                const ScreenType.search(),
                              );
                            },
                            child: Icon(
                              // TODO This is search icon
                              Icons.search_outlined,
                              color: snapshot.data == ScreenType.search()
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  floatingActionButton: isKeyBoardShow
                      ? Container()
                      : Transform.translate(
                          offset: const Offset(0, -22),
                          child: Container(
                            // height: 65,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              // TODO This is blue color behind the big button
                              color: Colors.blue.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: FloatingActionButton(
                              backgroundColor: AppColors.bottomMenu,
                              onPressed: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    opaque: true,
                                    pageBuilder:
                                        (BuildContext context, _, __) =>
                                            RedeemConfirmationScreen(
                                      backRefresh: () {
                                        // prevIndex=currentIndex;
                                        // currentIndex = index;
                                        feedCubit.onRefresh();
                                        // widget.backRefresh();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );

                                setState(() {});
                              },
                              child: Icon(
                                currentIndex == 2 ? Icons.close : Icons.add,
                                size: (_hideButtonController
                                                ?.positions.isNotEmpty &&
                                            _hideButtonController.position
                                                    .userScrollDirection ==
                                                ScrollDirection.reverse) ||
                                        (_hideButtonController
                                                ?.positions.isNotEmpty &&
                                            _hideButtonController.position
                                                    .userScrollDirection ==
                                                ScrollDirection.forward)
                                    ? 1
                                    : 30,
                              ),
                              elevation: 2.0,
                            ),
                          ),
                        ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                ),
              );
            }),
      ),
    );
  }

  Widget getHomeWidget() {
    return RefreshIndicator(
      onRefresh: () {
        feedCubit.onRefresh();
        feedCubit.getUserData();
        return Future.value();
      },
      // Scrollbar
      child: Scrollbar(
        child: CustomScrollView(
          controller: _hideButtonController,
          slivers: [
            SliverToBoxAdapter(),
            PostPaginationWidget(
              isComeHome: true,
              pagingController: feedCubit.pagingController,
              onTapLike: feedCubit.likeUnlikePost,
              onTapRepost: feedCubit.repost,
              onOptionItemTap: feedCubit.onOptionItemSelected,
            )
          ],
        ),
      ),
    );
  }

  onTapBottomBar(int index) {
    if (index == 0) {
      currentIndex = 0;
      feedCubit.changeCurrentPage(const ScreenType.home());
    } else if (index == 1) {
      currentIndex = 1;
      feedCubit.changeCurrentPage(const ScreenType.message());
    } else if (index == 2) {
      currentIndex = 2;
      feedCubit.changeCurrentPage(const ScreenType.notification());
    } else {
      currentIndex = 3;
      feedCubit.changeCurrentPage(const ScreenType.search());
    }
  }

  Widget getSelectedHomeScreen(ScreenType data) {
    return data.when(
      home: getHomeWidget,
      message: () => MessageScreen(),
      notification: () => NotificationScreen(),
      search: () => searScreen,
      profile: (args) => ProfileScreen(
          otherUserId: args.otherUserId,
          profileUrl: args.profileUrl,
          coverUrl: args.coverUrl,
          profileNavigationEnum: args.profileNavigationEnum),
      settings: (args) => SettingsScreen(
        fromProfile: args,
      ),
      bookmarks: () => BlocProvider.value(
        value: feedCubit,
        child: BookMarkScreen(),
      ),
    );
  }

  bool doReverse() {
    if (prevIndex == currentIndex) return false;
    return currentIndex < prevIndex;
  }

  appBarShow(ScreenType data) {
    // && currentIndex != 2
    return data == const ScreenType.home()
        ? AppBar(
            elevation: 0.0,
            brightness: Brightness.light,
            actions: [
              currentIndex == 2
                  ? IconButton(
                      icon:
                          Icon(Icons.close, color: AppColors.alertBg, size: 30),
                      onPressed: () {},
                    )
                  : Container()
            ],
            leading: [
              currentIndex == 2
                  ? Container()
                  : Container(
                      height: 3,
                      width: 25,
                      margin: EdgeInsets.only(bottom: 2, left: 13),
                      decoration: BoxDecoration(
                        color: AppColors.sideMenu,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
              3.toSizedBox,
              currentIndex == 2
                  ? Container()
                  : Container(
                      height: 3,
                      width: 14,
                      margin: EdgeInsets.only(bottom: 2, left: 13),
                      decoration: BoxDecoration(
                        color: AppColors.sideMenu,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
            ]
                .toColumn(mainAxisAlignment: MainAxisAlignment.center)
                .toPadding(0)
                .onTapWidget(() {
              scaffoldKey.currentState.openDrawer();
            }).toPadding(context.isArabic() ? 10 : 4),
            backgroundColor: Colors.white,
            title: AppIcons.appLogo.toContainer(height: 35, width: 35),
            centerTitle: true,
          )
        : null;
  }
}
