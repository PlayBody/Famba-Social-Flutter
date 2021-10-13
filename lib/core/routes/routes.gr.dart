// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:colibri/features/welcome/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../features/authentication/presentation/pages/login_screen.dart';
import '../../features/authentication/presentation/pages/reset_password_screen.dart';
import '../../features/authentication/presentation/pages/signup_screen.dart';
import '../../features/feed/domain/entity/post_entity.dart';
import '../../features/feed/presentation/pages/feed_screen.dart';
import '../../features/messages/presentation/pages/chat_screen.dart';
import '../../features/posts/domain/entiity/reply_entity.dart';
import '../../features/posts/presentation/pages/create_post.dart';
import '../../features/posts/presentation/pages/view_post_screen.dart';
import '../../features/profile/presentation/pages/followers_following_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/search/presentation/pages/searh_screen.dart';
import '../common/error_screen.dart';
import '../common/widget/web_view_screen.dart';

class Routes {
  static const String welcomeScreen = '/welcome-screen';
  static const String signUpScreen = '/sign-up-screen';
  static const String loginScreen = '/login-screen';
  static const String resetPasswordScreen = '/reset-password-screen';
  static const String webViewScreen = '/web-view-screen';
  static const String errorScreen = '/error-screen';
  static const String feedScreen = '/feed-screen';
  static const String profileScreen = '/profile-screen';
  static const String createPost = '/create-post';
  static const String chatScreen = '/chat-screen';
  static const String viewPostScreen = '/view-post-screen';
  static const String followingFollowersScreen = '/following-followers-screen';
  static const String searchScreen = '/search-screen';
  static const String settingsScreen = '/settings-screen';
  static const all = <String>{
    welcomeScreen,
    signUpScreen,
    loginScreen,
    resetPasswordScreen,
    webViewScreen,
    errorScreen,
    feedScreen,
    profileScreen,
    createPost,
    chatScreen,
    viewPostScreen,
    followingFollowersScreen,
    searchScreen,
    settingsScreen,
  };
}

class MyRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.welcomeScreen, page: WelcomeScreen),
    RouteDef(Routes.signUpScreen, page: SignUpScreen),
    RouteDef(Routes.loginScreen, page: LoginScreen),
    RouteDef(Routes.resetPasswordScreen, page: ResetPasswordScreen),
    RouteDef(Routes.webViewScreen, page: WebViewScreen),
    RouteDef(Routes.errorScreen, page: ErrorScreen),
    RouteDef(Routes.feedScreen, page: FeedScreen),
    RouteDef(Routes.profileScreen, page: ProfileScreen),
    RouteDef(Routes.createPost, page: CreatePost),
    RouteDef(Routes.chatScreen, page: ChatScreen),
    RouteDef(Routes.viewPostScreen, page: ViewPostScreen),
    RouteDef(Routes.followingFollowersScreen, page: FollowingFollowersScreen),
    RouteDef(Routes.searchScreen, page: SearchScreen),
    RouteDef(Routes.settingsScreen, page: SettingsScreen),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    WelcomeScreen: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => WelcomeScreen(),
        settings: data,
      );
    },
    SignUpScreen: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => SignUpScreen(),
        settings: data,
      );
    },
    LoginScreen: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => LoginScreen(),
        settings: data,
      );
    },
    ResetPasswordScreen: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => ResetPasswordScreen(),
        settings: data,
      );
    },
    WebViewScreen: (data) {
      final args = data.getArgs<WebViewScreenArguments>(
        orElse: () => WebViewScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => WebViewScreen(
          key: args.key,
          url: args.url,
          name: args.name,
        ),
        settings: data,
      );
    },
    ErrorScreen: (data) {
      final args = data.getArgs<ErrorScreenArguments>(
        orElse: () => ErrorScreenArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => ErrorScreen(
          key: args.key,
          error: args.error,
        ),
        settings: data,
      );
    },
    FeedScreen: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => FeedScreen(),
        settings: data,
      );
    },
    ProfileScreen: (data) {
      final args = data.getArgs<ProfileScreenArguments>(
        orElse: () => ProfileScreenArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => ProfileScreen(
          key: args.key,
          otherUserId: args.otherUserId,
          profileUrl: args.profileUrl,
          coverUrl: args.coverUrl,
          profileNavigationEnum: args.profileNavigationEnum,
        ),
        settings: data,
      );
    },
    CreatePost: (data) {
      final args = data.getArgs<CreatePostArguments>(
        orElse: () => CreatePostArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => CreatePost(
          key: args.key,
          title: args.title,
          replyTo: args.replyTo,
          threadId: args.threadId,
          replyEntity: args.replyEntity,
        ),
        settings: data,
        fullscreenDialog: true,
      );
    },
    ChatScreen: (data) {
      final args = data.getArgs<ChatScreenArguments>(
        orElse: () => ChatScreenArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => ChatScreen(
          key: args.key,
          otherPersonUserId: args.otherPersonUserId,
          otherUserFullName: args.otherUserFullName,
          otherPersonProfileUrl: args.otherPersonProfileUrl,
        ),
        settings: data,
      );
    },
    ViewPostScreen: (data) {
      final args = data.getArgs<ViewPostScreenArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => ViewPostScreen(
          key: args.key,
          threadID: args.threadID,
          postEntity: args.postEntity,
        ),
        settings: data,
      );
    },
    FollowingFollowersScreen: (data) {
      final args = data.getArgs<FollowingFollowersScreenArguments>(
        orElse: () => FollowingFollowersScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => FollowingFollowersScreen(
          key: args.key,
          followScreenEnum: args.followScreenEnum,
          userId: args.userId,
        ),
        settings: data,
        fullscreenDialog: true,
      );
    },
    SearchScreen: (data) {
      final args = data.getArgs<SearchScreenArguments>(
        orElse: () => SearchScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SearchScreen(
          key: args.key,
          searchedText: args.searchedText,
        ),
        settings: data,
      );
    },
    SettingsScreen: (data) {
      final args = data.getArgs<SettingsScreenArguments>(
        orElse: () => SettingsScreenArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SettingsScreen(
          key: args.key,
          fromProfile: args.fromProfile,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// WebViewScreen arguments holder class
class WebViewScreenArguments {
  final Key key;
  final String url;
  final String name;
  WebViewScreenArguments({this.key, this.url, this.name});
}

/// ErrorScreen arguments holder class
class ErrorScreenArguments {
  final Key key;
  final String error;
  ErrorScreenArguments({this.key, this.error});
}

/// ProfileScreen arguments holder class
class ProfileScreenArguments {
  final Key key;
  final String otherUserId;
  final String profileUrl;
  final String coverUrl;
  final ProfileNavigationEnum profileNavigationEnum;
  ProfileScreenArguments(
      {this.key,
      this.otherUserId,
      this.profileUrl,
      this.coverUrl,
      this.profileNavigationEnum = ProfileNavigationEnum.FROM_FEED});
}

/// CreatePost arguments holder class
class CreatePostArguments {
  final Key key;
  final String title;
  final String replyTo;
  final String threadId;
  final ReplyEntity replyEntity;
  CreatePostArguments(
      {this.key,
      this.title = "Create Post",
      this.replyTo = "",
      this.threadId,
      this.replyEntity});
}

/// ChatScreen arguments holder class
class ChatScreenArguments {
  final Key key;
  final String otherPersonUserId;
  final String otherUserFullName;
  final String otherPersonProfileUrl;
  ChatScreenArguments(
      {this.key,
      this.otherPersonUserId,
      this.otherUserFullName,
      this.otherPersonProfileUrl});
}

/// ViewPostScreen arguments holder class
class ViewPostScreenArguments {
  final Key key;
  final int threadID;
  final PostEntity postEntity;
  ViewPostScreenArguments({this.key, this.threadID, @required this.postEntity});
}

/// FollowingFollowersScreen arguments holder class
class FollowingFollowersScreenArguments {
  final Key key;
  final FollowUnFollowScreenEnum followScreenEnum;
  final String userId;
  FollowingFollowersScreenArguments(
      {this.key,
      this.followScreenEnum = FollowUnFollowScreenEnum.FOLLOWERS,
      this.userId});
}

/// SearchScreen arguments holder class
class SearchScreenArguments {
  final Key key;
  final String searchedText;
  SearchScreenArguments({this.key, this.searchedText});
}

/// SettingsScreen arguments holder class
class SettingsScreenArguments {
  final Key key;
  final bool fromProfile;
  SettingsScreenArguments({this.key, this.fromProfile = false});
}
