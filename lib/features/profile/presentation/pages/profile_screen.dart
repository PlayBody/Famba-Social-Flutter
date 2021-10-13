import 'package:auto_route/auto_route.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../../core/common/uistate/common_ui_state.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/loading_bar.dart';
import '../../../../core/widgets/media_picker.dart';
import '../../../../extensions.dart';
import '../../../feed/presentation/widgets/create_post_card.dart';
import '../../../feed/presentation/widgets/feed_widgets.dart';
import '../../../feed/presentation/widgets/no_data_found_screen.dart';
import '../../../posts/presentation/widgets/post_pagination_widget.dart';
import '../../domain/entity/profile_entity.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/user_likes/user_likes_cubit.dart';
import '../bloc/user_media/user_media_cubit.dart';
import '../bloc/user_posts/user_post_cubit.dart';
import '../widgets/profile_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileScreen extends StatefulWidget {
  // ignore: deprecated_member_use_from_same_package
  final ProfileNavigationEnum profileNavigationEnum;
  final String otherUserId;
  final String profileUrl;
  final String coverUrl;
  const ProfileScreen({
    Key key,
    this.otherUserId,
    this.profileUrl,
    this.coverUrl,
    this.profileNavigationEnum = ProfileNavigationEnum.FROM_FEED,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  ProfileCubit _profileCubit;
  UserPostCubit userPostCubit;
  UserMediaCubit userMediaCubit;
  UserLikesCubit userLikesCubit;
  TabController tabController;
  Size size;
  @override
  void initState() {
    _profileCubit = getIt<ProfileCubit>();
    tabController = TabController(length: 3, vsync: this);
    userPostCubit = getIt<UserPostCubit>();
    userMediaCubit = getIt<UserMediaCubit>();
    userLikesCubit = getIt<UserLikesCubit>();
    _profileCubit.profileEntity.listen((event) {
      userLikesCubit.userId = event.id;
      userMediaCubit.userId = event.id;
      userPostCubit.userId = event.id;
    });

    super.initState();
    _profileCubit.getUserProfile(
        widget.otherUserId, widget.coverUrl, widget.profileUrl);
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return Scaffold(
      body: BlocProvider(
        create: (c) => _profileCubit,
        child: BlocBuilder<ProfileCubit, CommonUIState>(
          bloc: _profileCubit,
          builder: (_, state) {
            return state.when(
              initial: () => LoadingBar(),
              success: (s) => getHomeWidget(),
              loading: () => LoadingBar(),
              error: (e) => Center(
                child: NoDataFoundScreen(
                  onTapButton: ExtendedNavigator.root.pop,
                  icon: AppIcons.personOption(
                      color: AppColors.colorPrimary, size: 40),
                  title: 'Profile Not found',
                  message: e.contains("invalid")
                      ? LocaleKeys
                          .sorry_we_cannot_find_the_page_you_are_looking_for_if_you_still_ne
                          .tr()
                      : e,
                  buttonText: LocaleKeys.go_back.tr(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getHomeWidget() {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              StreamBuilder<ProfileEntity>(
                stream: _profileCubit.profileEntity,
                builder: (context, snapshot) {
                  return SliverAppBar(
                    automaticallyImplyLeading: false,
                    leading: null,
                    brightness: Brightness.light,
                    elevation: 0.0,
                    expandedHeight: calculateHeight(snapshot.data),
                    floating: true,
                    pinned: true,
                    actions: [
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await openMediaPicker(
                              context,
                              (media) async {
                                _profileCubit.changeProfileEntity(
                                  snapshot.data
                                      .copyWith(backgroundImage: media),
                                );
                                await _profileCubit.updateProfileCover(media);
                              },
                              mediaType: MediaTypeEnum.IMAGE,
                              allowCropping: true,
                            );
                          }).toVisibility(widget.otherUserId == null)
                    ],
                    // title: Text('Profile'),
                    backgroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: snapshot.data == null
                          ? Container()
                          : TopAppBar(
                              otherUserId: snapshot.data.id,
                              otherUser: widget.otherUserId != null,
                              profileEntity: snapshot.data,
                              profileNavigationEnum:
                                  widget.profileNavigationEnum,
                            ),
                    ),
                    bottom: PreferredSize(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.2),
                                ),
                              ),
                            ),
                          ),
                          TabBar(
                            indicatorWeight: 1,
                            indicatorSize: TabBarIndicatorSize.label,
                            labelPadding: const EdgeInsets.all(0),
                            labelStyle: TextStyle(
                              fontFamily: 'CeraPro',
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontFamily: 'CeraPro',
                              fontWeight: FontWeight.bold,
                            ),
                            tabs: [
                              Tab(
                                text: LocaleKeys.posts.tr(),
                              ).toContainer(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey,
                                      width: 0.2,
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                text: LocaleKeys.media.tr(),
                              ).toContainer(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey,
                                      width: 0.2,
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                text: LocaleKeys.likes.tr(),
                              ).toContainer(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.grey,
                                      width: 0.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      preferredSize: const Size(500, 56),
                    ),
                  );
                },
              ),
            ];
          },
          body: TabBarView(
            children: [
              Container(
                  child: RefreshIndicator(
                onRefresh: () {
                  userPostCubit.onRefresh();
                  return Future.value();
                },
                child: PostPaginationWidget(
                  isComeHome: false,
                  isFromProfileSearch: true,
                  isPrivateAccount: (value) {
                    _profileCubit.isPrivateUser = value;
                  },
                  isSliverList: false,
                  noDataFoundScreen: NoDataFoundScreen(
                    buttonText: LocaleKeys.go_to_the_homepage.tr(),
                    title: LocaleKeys.no_posts_yet.tr(),
                    message: "",
                    onTapButton: () {
                      ExtendedNavigator.root.pop();
                    },
                  ),
                  pagingController: userPostCubit.pagingController,
                  onTapLike: userPostCubit.likeUnlikePost,
                  onOptionItemTap: userPostCubit.onOptionItemSelected,
                  onTapRepost: userPostCubit.repost,
                ),
              )),
              Container(
                  child: RefreshIndicator(
                onRefresh: () {
                  userMediaCubit.onRefresh();
                  return Future.value();
                },
                child: PostPaginationWidget(
                  isComeHome: false,
                  isPrivateAccount: (value) {
                    _profileCubit.isPrivateUser = value;
                  },
                  isSliverList: false,
                  noDataFoundScreen: NoDataFoundScreen(
                    title: LocaleKeys.no_media_yet.tr(),
                    icon: AppIcons.imageIcon(height: 35, width: 35),
                    buttonText: LocaleKeys.go_to_the_homepage.tr(),
                    message: "",
                    onTapButton: () {
                      ExtendedNavigator.root.pop();
                      // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.home());
                      // ExtendedNavigator.root.push(Routes.createPost);
                    },
                  ),
                  pagingController: userMediaCubit.pagingController,
                  onTapLike: userMediaCubit.likeUnlikePost,
                  onOptionItemTap: (PostOptionsEnum value, int index) async =>
                      await userMediaCubit.onOptionItemSelected(value, index),
                  onTapRepost: userMediaCubit.repost,
                ),
              )),
              Container(
                  child: RefreshIndicator(
                onRefresh: () {
                  userLikesCubit.onRefresh();
                  return Future.value();
                },
                child: PostPaginationWidget(
                  isComeHome: false,
                  isPrivateAccount: (value) {
                    _profileCubit.isPrivateUser = value;
                  },
                  isSliverList: false,
                  noDataFoundScreen: NoDataFoundScreen(
                    title: LocaleKeys.no_likes_yet.tr(),
                    icon: AppIcons.likeOption(
                        size: 35, color: AppColors.colorPrimary),
                    buttonText: LocaleKeys.go_to_the_homepage.tr(),
                    message: LocaleKeys
                        .you_don_t_have_any_favorite_posts_yet_all_posts_that_you_like_wil
                        .tr(),
                    onTapButton: () {
                      ExtendedNavigator.root.pop();
                      // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.home());
                      // ExtendedNavigator.root.push(Routes.createPost);
                    },
                  ),
                  pagingController: userLikesCubit.pagingController,
                  onTapLike: userLikesCubit.likeUnlikePost,
                  onOptionItemTap: userLikesCubit.onOptionItemSelected,
                  onTapRepost: userLikesCubit.repost,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  /// TODO Important
  num calculateHeight(ProfileEntity data) {
    if (data == null)
      return 0.toHeight;

    /// we will have to give static height to app bar
    /// in case of about is more than 40 chars we will increase height
    else if (data.about.isNotEmpty) {
      /// handling large sizes
      if (context.getScreenWidth > 320)
        return 420.toHeight + ((data.about.length / 10) * 5);
      else
        return 420.toHeight;
    } else {
      if (data.website.isNotEmpty) {
        return context.getScreenWidth > 320 ? 410.toHeight : 390.toHeight;
      } else
        return context.getScreenWidth > 320 ? 380.toHeight : 360.toHeight;
    }
  }
}

/// helps to determine from where user navigated to profile
/// so that on back press of the profile screen we can go back the correct page

/// we're using this because according to the UI we will have the keep the bottom navigation bar under the profile page
enum ProfileNavigationEnum {
  FROM_BOOKMARKS,
  FROM_FEED,
  FROM_SEARCH,
  FROM_VIEW_POST,
  FROM_MY_PROFILE,
  FROM_OTHER_PROFILE,
  FROM_MESSAGES,
  FROM_NOTIFICATION
}
