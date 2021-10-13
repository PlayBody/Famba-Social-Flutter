import '../../../../translations/locale_keys.g.dart';

import '../../../../core/common/uistate/common_ui_state.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/colors.dart';
import '../../../feed/presentation/bloc/feed_cubit.dart';
import '../../../feed/presentation/widgets/all_home_screens.dart';
import '../../../feed/presentation/widgets/no_data_found_screen.dart';
import '../../../posts/presentation/widgets/post_pagination_widget.dart';
import '../bloc/bookmark_cubit.dart';
import 'package:flutter/material.dart';
import '../../../../extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class BookMarkScreen extends StatefulWidget {
  @override
  _BookMarkScreenState createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  BookmarkCubit bookmarkCubit;

  @override
  void initState() {
    super.initState();
    bookmarkCubit = getIt<BookmarkCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        BlocProvider.of<FeedCubit>(context)
            .changeCurrentPage(const ScreenType.home());
      },
      child: BlocListener<BookmarkCubit, CommonUIState>(
        bloc: bookmarkCubit,
        listener: (_, state) {
          state.maybeWhen(
              orElse: () {},
              error: (e) => context.showSnackBar(message: e, isError: true),
              success: (s) => context.showSnackBar(message: s, isError: false));
        },
        child: NestedScrollView(
            headerSliverBuilder: (v, c) => [
                  SliverAppBar(
                    elevation: 0.0,
                    collapsedHeight: 60,
                    expandedHeight: 60,
                    floating: true,
                    pinned: true,
                    flexibleSpace: "#hashtag, username, etc..."
                        .toSearchBarField()
                        .toHorizontalPadding(24)
                        .toContainer(height: 65)
                        .makeBottomBorder,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                  )
                ],
            body: RefreshIndicator(
              onRefresh: () {
                bookmarkCubit.onRefresh();
                return Future.value();
              },
              child: PostPaginationWidget(
                isComeHome: false,
                isSliverList: false,
                noDataFoundScreen: NoDataFoundScreen(
                  onTapButton: () {
                    // ExtendedNavigator.root.push(Routes.createPost);
                    BlocProvider.of<FeedCubit>(context)
                        .changeCurrentPage(const ScreenType.home());
                  },
                  title: LocaleKeys.no_bookmarks_yet.tr(),
                  buttonText: LocaleKeys.go_to_the_homepage.tr(),
                  message: LocaleKeys
                      .it_looks_like_you_don_t_have_any_bookmarks_yet_to_add_a_post_to_t
                      .tr(),
                  icon: const Icon(
                    Icons.menu_book_outlined,
                    color: AppColors.colorPrimary,
                    size: 40,
                  ),
                ),
                pagingController: bookmarkCubit.pagingController,
                onTapRepost: bookmarkCubit.repost,
                onTapLike: bookmarkCubit.likeUnlikePost,
                onOptionItemTap: bookmarkCubit.onOptionItemSelected,
              ),
            )).toSafeArea,
      ),
    );
  }
}
