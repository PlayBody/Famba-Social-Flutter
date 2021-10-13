import '../../../../translations/locale_keys.g.dart';

import '../../../../core/common/widget/common_divider.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/loading_bar.dart';
import '../../../../extensions.dart';
import '../../../feed/presentation/bloc/feed_cubit.dart';
import '../../../feed/presentation/widgets/all_home_screens.dart';
import '../../../feed/presentation/widgets/no_data_found_screen.dart';
import '../../../posts/presentation/bloc/post_cubit.dart';
import '../../../posts/presentation/widgets/post_pagination_widget.dart';
import '../../domain/entity/people_entity.dart';
import '../../domain/entity/hashtag_entity.dart';
import '../bloc/search_cubit.dart';
import '../widgets/hasttag_item.dart';
import '../widgets/people_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchScreen extends StatefulWidget {
  final String searchedText;
  const SearchScreen({Key key, this.searchedText}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  SearchCubit searchCubit;
  PostCubit postCubit;
  TabController tabController;
  FocusNode focusNode;
  TextEditingController textEditingController;
  @override
  void initState() {
    super.initState();
    searchCubit = getIt<SearchCubit>();
    postCubit = getIt<PostCubit>();
    tabController = TabController(length: 3, vsync: this);
    focusNode = FocusNode();
    textEditingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.searchedText?.isNotEmpty == true) {
        tabController.animateTo(2, duration: const Duration(milliseconds: 300));
        postCubit.searchedText = widget.searchedText.replaceAll("#", "");
      }
    });
    tabController.addListener(() {
      FocusManager.instance.primaryFocus.unfocus();
      var s = textEditingController.text;
      if (tabController.index == 0) {
        searchCubit.hashTagPagination.queryText = s;
      } else if (tabController.index == 1) {
        searchCubit.peoplePagination.queryText = s;
      } else {
        postCubit.searchedText = s;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    context.initScreenUtil();
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (_, value) => [
          SliverAppBar(
            title: AppIcons.appLogo
                .toContainer(height: 35, width: 35)
                .toVisibility(widget.searchedText != null),
            centerTitle: true,
            elevation: 0.0,
            floating: true,
            pinned: true,
            expandedHeight:
                widget.searchedText != null ? 160.toHeight : 115.toHeight,
            flexibleSpace: "#hashtag, username, etc..."
                .toSearchBarField(
                    onTextChange: (s) {
                      print(textEditingController.text);
                      doSearch(s);
                    },
                    focusNode: focusNode,
                    textEditingController: textEditingController)
                .toHorizontalPadding(24)
                .toContainer(height: widget.searchedText != null ? 140 : 60),
            leading: const BackButton(
              color: AppColors.colorPrimary,
            ).toVisibility(widget.searchedText != null),
            backgroundColor: Colors.white,
            bottom: PreferredSize(
              preferredSize: Size(context.getScreenWidth, 56.toHeight),
              child: Stack(
                children: [
                  Positioned.fill(
                    top: 0.0,
                    child: Container(
                      color: Colors.white,
                    ).makeVerticalBorders,
                  ),
                  TabBar(
                    // TODO Use propertiy label color for text color and indicatorcolor for the underline color
                    onTap: (value) =>
                        FocusManager.instance.primaryFocus.unfocus(),

                    controller: tabController,
                    tabs: [
                      Tab(text: LocaleKeys.hashtags.tr()),
                      Tab(text: LocaleKeys.people.tr()),
                      Tab(text: LocaleKeys.posts.tr()),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
        body: TabBarView(
          controller: tabController,
          children: [
            Container(
                child: RefreshIndicator(
              onRefresh: () {
                searchCubit.hashTagPagination.onRefresh();
                return Future.value();
              },
              child: PagedListView.separated(
                key: const PageStorageKey("Hashtags"),
                pagingController:
                    searchCubit.hashTagPagination.pagingController,
                builderDelegate: PagedChildBuilderDelegate<HashTagEntity>(
                    noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen(
                          buttonText: LocaleKeys.go_to_the_homepage.tr(),
                          icon: const Icon(
                            Icons.search,
                            color: AppColors.colorPrimary,
                            size: 40,
                          ),
                          title: LocaleKeys.nothing_found.tr(),
                          message: LocaleKeys
                              .sorry_but_we_could_not_find_anything_in_our_database_for_your_sea
                              .tr(namedArgs: {
                            '@search_query@': textEditingController.text,
                          }),
                          onTapButton: () {
                            BlocProvider.of<FeedCubit>(context)
                                .changeCurrentPage(const ScreenType.home());
                          },
                        ),
                    itemBuilder: (c, item, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: index == 0 ? 8.0 : 0, left: 10),
                        child: getHastTagItem(item, (s) {
                          textEditingController.text = s.replaceAll("#", "");
                          postCubit.searchedText = s.replaceAll("#", "");
                          tabController.animateTo(2,
                              duration: const Duration(milliseconds: 300));
                        }),
                      );
                    }),
                separatorBuilder: (BuildContext context, int index) =>
                    commonDivider,
              ),
            )),
            RefreshIndicator(
              onRefresh: () {
                searchCubit.peoplePagination.onRefresh();
                return Future.value();
              },
              child: PagedListView.separated(
                key: const PageStorageKey("People"),
                pagingController: searchCubit.peoplePagination.pagingController,
                padding: const EdgeInsets.only(top: 10),
                builderDelegate: PagedChildBuilderDelegate<PeopleEntity>(
                  noItemsFoundIndicatorBuilder: (_) => NoDataFoundScreen(
                    buttonText: LocaleKeys.go_to_the_homepage.tr(),
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.colorPrimary,
                      size: 40,
                    ),
                    title: LocaleKeys.nothing_found.tr(),
                    message: LocaleKeys
                        .sorry_but_we_could_not_find_anything_in_our_database_for_your_sea
                        .tr(namedArgs: {
                      '@search_query@': textEditingController.text,
                    }),
                    onTapButton: () {
                      BlocProvider.of<FeedCubit>(context).changeCurrentPage(
                        const ScreenType.home(),
                      );
                    },
                  ),
                  itemBuilder: (c, item, index) => PeopleItem(
                    peopleEntity: item,
                    onFollowTap: () => searchCubit.followUnFollow(index),
                  ),
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    commonDivider,
              ),
            ),
            RefreshIndicator(
              onRefresh: () {
                postCubit.onRefresh();
                return Future.value();
              },
              child: PostPaginationWidget(
                isComeHome: true,
                isSliverList: false,
                noDataFoundScreen: StreamBuilder<String>(
                  stream: postCubit.search,
                  initialData: textEditingController.text,
                  builder: (context, snapshot) {
                    return snapshot.data.isEmpty
                        ? LoadingBar()
                        : NoDataFoundScreen(
                            buttonText: LocaleKeys.go_to_the_homepage.tr(),
                            icon: const Icon(Icons.search,
                                color: AppColors.colorPrimary, size: 40),
                            title: LocaleKeys.nothing_found.tr(),
                            message: LocaleKeys
                                .sorry_but_we_could_not_find_anything_in_our_database_for_your_sea
                                .tr(namedArgs: {
                              '@search_query@': snapshot.data,
                            }),
                            onTapButton: () {
                              BlocProvider.of<FeedCubit>(context)
                                  .changeCurrentPage(
                                const ScreenType.home(),
                              );
                            },
                          );
                  },
                ),
                pagingController: postCubit.pagingController,
                onTapLike: postCubit.likeUnlikePost,
                onTapRepost: postCubit.repost,
                onOptionItemTap: postCubit.onOptionItemSelected,
                isFromProfileSearch: true,
              ),
            )
          ],
        ),
      ).toSafeArea,
    );
  }

  void doSearch(String s) {
    if (tabController.index == 0) {
      searchCubit.hashTagPagination.changeSearch(s);
    } else if (tabController.index == 1) {
      searchCubit.peoplePagination.changeSearch(s);
    } else {
      postCubit.changeSearch(s);
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
