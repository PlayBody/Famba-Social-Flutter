import 'package:auto_route/auto_route.dart';
import '../../../../translations/locale_keys.g.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/routes/routes.gr.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/images.dart';
import '../../../../core/widgets/animations/fade_widget.dart';
import '../../../feed/presentation/bloc/feed_cubit.dart';
import '../../../feed/presentation/widgets/no_data_found_screen.dart';
import '../../domain/entity/follower_entity.dart';
import '../../domain/entity/profile_entity.dart';
import '../bloc/followers_following_cubit.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import '../../../../extensions.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:easy_localization/easy_localization.dart';

class FollowingFollowersScreen extends StatefulWidget {
  final FollowUnFollowScreenEnum followScreenEnum;
  final String userId;

  const FollowingFollowersScreen(
      {Key key,
      this.followScreenEnum = FollowUnFollowScreenEnum.FOLLOWERS,
      this.userId})
      : super(key: key);

  @override
  _FollowingFollowersScreenState createState() =>
      _FollowingFollowersScreenState();
}

class _FollowingFollowersScreenState extends State<FollowingFollowersScreen>
    with SingleTickerProviderStateMixin {
  FollowersFollowingCubit followersFollowingCubit;
  TabController tabController;
  FeedCubit feedCubit;

  @override
  void initState() {
    super.initState();
    followersFollowingCubit = getIt<FollowersFollowingCubit>()
      ..getProfile(widget.userId)
      ..followerPagination.userId = widget.userId
      ..followingPagination.userId = widget.userId;
    tabController = TabController(length: 2, vsync: this);
    switch (widget.followScreenEnum) {
      case FollowUnFollowScreenEnum.FOLLOWERS:
        tabController.animateTo(0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInBack);
        break;
      case FollowUnFollowScreenEnum.FOLLOWING:
        tabController.animateTo(1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInBack);
        break;
      case FollowUnFollowScreenEnum.PEOPLE:
        tabController.animateTo(
          2,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInBack,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                title: AppIcons.appLogo.toContainer(height: 35, width: 35),
                centerTitle: true,
                automaticallyImplyLeading: true,
                leading: const BackButton(
                  color: AppColors.colorPrimary,
                ),
                brightness: Brightness.light,
                elevation: 0.0,
                floating: true,
                pinned: true,
                backgroundColor: Colors.white,
                bottom: PreferredSize(
                  child: StreamBuilder<ProfileEntity>(
                      stream: followersFollowingCubit.profileEntity,
                      builder: (context, snapshot) {
                        return snapshot.data == null
                            ? const SizedBox()
                            : Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 0.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TabBar(
                                    controller: tabController,
                                    indicatorWeight: 1,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    labelPadding: const EdgeInsets.all(0),
                                    tabs: [
                                      Tab(
                                        text:
                                            "${LocaleKeys.followers.tr()} (${snapshot.data.followerCount})",
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
                                        text:
                                            "${LocaleKeys.following.tr()} (${snapshot.data.followingCount})",
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
                                      )
                                    ],
                                  )
                                ],
                              );
                      }),
                  preferredSize: const Size(500, 56),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: [
              RefreshIndicator(
                onRefresh: () {
                  followersFollowingCubit.getProfile(widget.userId);
                  followersFollowingCubit.followerPagination.onRefresh();
                  return Future.value();
                },
                child: PagedListView.separated(
                  padding: const EdgeInsets.only(bottom: 10),
                  pagingController: followersFollowingCubit
                      .followerPagination.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<FollowerEntity>(
                      noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen(
                            buttonText: LocaleKeys.go_back.tr(),
                            icon: Images.people.toSvg(
                                color: AppColors.colorPrimary,
                                height: 30,
                                width: 30),
                            title: LocaleKeys.no_followers_yet.tr(),
                            message: LocaleKeys
                                .you_have_no_followers_yet_the_list_of_all_people_who_follow_you_w
                                .tr(),
                            onTapButton: () {
                              ExtendedNavigator.root.pop();
                              // BlocProvider.of<FeedCubit>(context).changeCurrentPage(ScreenType.home());
                            },
                          ),
                      itemBuilder: (BuildContext context, item, int index) =>
                          CustomAnimatedWidget(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: index == 0 ? 8 : 0.0),
                              child: followerTile(item, () {
                                followersFollowingCubit.followUnFollow(
                                    index, FollowUnFollowEnums.FOLLOWERS);
                              }).onTapWidget(() {
                                ExtendedNavigator.root.pop();
                              }),
                            ),
                          )),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    thickness: 2,
                    color: AppColors.sfBgColor,
                  ),
                ),
              ),
              RefreshIndicator(
                onRefresh: () {
                  followersFollowingCubit.getProfile(widget.userId);
                  followersFollowingCubit.followingPagination.onRefresh();
                  return Future.value();
                },
                child: PagedListView.separated(
                  padding: const EdgeInsets.only(bottom: 10),
                  pagingController: followersFollowingCubit
                      .followingPagination.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<FollowerEntity>(
                      noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen(
                            buttonText: LocaleKeys.go_back.tr(),
                            icon: AppIcons.personOption(
                                size: 35, color: AppColors.colorPrimary),
                            title: LocaleKeys.not_following_yet.tr(),
                            message: LocaleKeys
                                .you_are_not_following_any_user_yet_the_list_of_all_people_you_fol
                                .tr(),
                            onTapButton: () {
                              ExtendedNavigator.root.pop();
                            },
                          ),
                      itemBuilder: (BuildContext context, item, int index) =>
                          CustomAnimatedWidget(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(top: index == 0 ? 8 : 0.0),
                              child: followerTile(item, () {
                                followersFollowingCubit.followUnFollow(
                                    index, FollowUnFollowEnums.FOLLOWING);
                              }),
                            ),
                          )),
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    thickness: 2,
                    color: AppColors.sfBgColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget followTile() {
    return [
      "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50"
          .toRoundNetworkImage(radius: 12),
      [
        faker.person.name().toSubTitle2(fontWeight: FontWeight.bold),
        faker.person.firstName().toCaption(),
        faker.job.title().toCaption()
      ].toColumn().toHorizontalPadding(8).toExpanded(),
      "follow"
          .toButton(color: AppColors.colorPrimary)
          .toOutlinedBorder(() {})
          .toContainer(height: 25)
    ].toRow(crossAxisAlignment: CrossAxisAlignment.center).toPadding(8);
  }

  Widget followerTile(
      FollowerEntity followerEntity, VoidCallback voidCallback) {
    return [
      followerEntity.profileUrl.toRoundNetworkImage(radius: 12),
      [
        5.toSizedBox,
        followerEntity.fullName.toSubTitle2(fontWeight: FontWeight.bold),
        2.toSizedBox,
        followerEntity.username.toCaption(),
        5.toSizedBox,
        followerEntity.about
            .toCaption()
            .toVisibility(followerEntity.about.isNotEmpty)
      ].toColumn().toHorizontalPadding(8).toExpanded(),
      getFollowUnFollowButton(followerEntity, voidCallback)
          .toVisibility(!followerEntity.isCurrentLoggedInUser),
    ]
        .toRow(crossAxisAlignment: CrossAxisAlignment.start)
        .toHorizontalPadding(8)
        .onTapWidget(() {
      // context.showSnackBar(message: followerEntity.id.toString());
      ExtendedNavigator.root.push(
        Routes.profileScreen,
        arguments: ProfileScreenArguments(
          otherUserId: followerEntity.isCurrentLoggedInUser
              ? null
              : followerEntity.id.toString(),
        ),
      );
    }).toHorizontalPadding(8);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getFollowUnFollowButton(
      FollowerEntity followerEntity, VoidCallback voidCallback) {
    if (followerEntity.buttonText == LocaleKeys.unfollow.tr())
      return followerEntity.buttonText
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
              voidCallback.call();
            },
            okButtonTitle: LocaleKeys.unfollow.tr());
      }).toContainer(height: 30, alignment: Alignment.topCenter);
    else
      return followerEntity.buttonText
          .toSubTitle2(
              color: AppColors.colorPrimary, fontWeight: FontWeight.w600)
          .toVerticalPadding(2)
          .toOutlinedBorder(() {
        voidCallback.call();
      }).toContainer(height: 30, alignment: Alignment.topCenter);
  }
}

enum FollowUnFollowScreenEnum { FOLLOWERS, FOLLOWING, PEOPLE }
