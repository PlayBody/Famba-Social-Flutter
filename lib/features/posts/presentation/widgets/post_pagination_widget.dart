// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: invalid_use_of_protected_member
import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:colibri/core/common/widget/promoted_widget.dart';

import 'package:colibri/core/routes/routes.gr.dart';
import 'package:colibri/core/theme/colors.dart';
import 'package:colibri/core/widgets/error/first_page_error.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/feed/presentation/widgets/feed_widgets.dart';
import 'package:colibri/features/feed/presentation/widgets/no_data_found_screen.dart';
import 'package:colibri/features/posts/presentation/pages/show_likes_screen.dart';
import 'package:colibri/features/posts/presentation/pages/view_post_screen.dart';
import 'package:colibri/features/posts/presentation/widgets/report_post_widget.dart';
import 'package:colibri/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:colibri/extensions.dart';

typedef ValueChangedWithTwoParam<T, R> = void Function(T value, R secondValue);

class PostPaginationWidget extends StatefulWidget {
  final bool isComeHome;
  final PagingController<int, PostEntity> pagingController;
  final ValueChanged<int> onTapLike;
  final ValueChanged<int> onTapRepost;
  final ValueChangedWithTwoParam<PostOptionsEnum, int> onOptionItemTap;
  final Widget noDataFoundScreen;
  final bool isFromProfileSearch;

  /// it can help full in [ProfileScreen] to restrict the current user to open private content
  final ValueChanged<bool> isPrivateAccount;

  /// we can return two diff types of list
  /// 1 [SliverList]
  /// 2 [ListView]
  final bool isSliverList;
  final Widget firstPageError;
  const PostPaginationWidget(
      {Key key,
      @required this.isComeHome,
      @required this.pagingController,
      @required this.onTapLike,
      @required this.onTapRepost,
      @required this.onOptionItemTap,
      this.noDataFoundScreen,
      this.isSliverList = true,
      this.isFromProfileSearch = false,
      this.isPrivateAccount,
      this.firstPageError})
      : super(key: key);
  @override
  _PostPaginationWidgetState createState() => _PostPaginationWidgetState();
}

class _PostPaginationWidgetState extends State<PostPaginationWidget> {
  String userAuth;

  @override
  Widget build(BuildContext context) => widget.isSliverList
      ? PagedSliverList.separated(
          pagingController: widget.pagingController,
          builderDelegate: buildHome(),
          separatorBuilder: (BuildContext context, int index) => Container(),
        )
      : PagedListView(
          pagingController: widget.pagingController,
          builderDelegate: buildHome());

  PagedChildBuilderDelegate<PostEntity> buildHome() =>
      PagedChildBuilderDelegate<PostEntity>(
          firstPageErrorIndicatorBuilder: (c) {
            // print("hello ${widget?.isPrivateAccount}" );
            widget?.isPrivateAccount(widget.pagingController.error ==
                'This profile data is not available for viewing');
            return widget.pagingController.error ==
                    'This profile data is not available for viewing'
                ? PrivacyProtectedErrorView()
                : CustomFirstPageView(onTryAgain: () {
                    widget?.pagingController?.refresh();
                  });
          },
          noItemsFoundIndicatorBuilder: (_) =>
              widget.noDataFoundScreen ??
              NoDataFoundScreen(
                onTapButton: () {
                  ExtendedNavigator.root.push(Routes.createPost);
                },
              ),
          itemBuilder: (BuildContext context, item, int index) {
            if (item.isAdvertisement)
              return PromotedWidget(
                advertisementEntity: item.advertisementEntity,
              );

            return OpenContainer<PostEntity>(
              openElevation: 0.0,
              closedElevation: 0.0,
              closedBuilder: (c, opencontainer) => PostItem(
                isComeHome: widget.isComeHome,
                postEntity: item,
                onLikeTap: () {
                  widget.onTapLike(index);
                  // feedCubit.likeUnlikePost(index);
                },
                onTapRepost: () {
                  widget.onTapRepost(index);
                  // feedCubit.repost(index);
                },
                onPostOptionItem: (value) {
                  // context.showSnackBar(message: value);
                  // await feedCubit.deletePost(index);
                  // context.showSnackBar(message: value.getOptionsEnum.toString());
                  // SystemChannels.textInput.invokeMethod('TextInput.hide');

                  print("Value data ");
                  print("$value");
                  print("${value.getOptionsEnum}");

                  FocusManager.instance.primaryFocus.unfocus();
                  final getOptionsEnum = value.getOptionsEnum;
                  switch (getOptionsEnum) {
                    case PostOptionsEnum.SHOW_LIKES:
                      showModalBottomSheet(
                        context: context,
                        builder: (c) => ShowLikeScreen(item.postId),
                      );
                      break;
                    case PostOptionsEnum.REPORT:
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => ReportPostWidget(
                          item.postId,
                        ),
                      );
                      break;
                    case PostOptionsEnum.BOOKMARK:
                      widget.onOptionItemTap(PostOptionsEnum.BOOKMARK, index);
                      break;
                    case PostOptionsEnum.DELETE:
                      context.showDeleteDialog(onOkTap: () async {
                        if (widget.isFromProfileSearch) {
                          Future.delayed(Duration(microseconds: 100), () {
                            ExtendedNavigator.root.pop();
                            widget?.pagingController?.refresh();
                          });
                        }
                        widget.onOptionItemTap(PostOptionsEnum.DELETE, index);
                      });
                      break;
                  }
                  // if(getOptionsEnum==PostOptionsEnum.SHOW_LIKES)
                  //
                  // else if()
                  // else widget.onOptionItemTap(getOptionsEnum,index);
                },
                detailedPost: true,
                replyCountIncreased: (value) {
                  var currentItem = widget.pagingController.itemList[index];
                  widget.pagingController
                    ..itemList[index] = currentItem.copyWith(
                        commentCount: currentItem.commentCount.inc.toString())
                    ..notifyListeners();
                },
              ).toContainer().makeBottomBorder, //

              openBuilder: (c, cl) => InkWell(
                onTap: () async {
                  ExtendedNavigator.root.push(Routes.viewPostScreen,
                      arguments: ViewPostScreenArguments(
                          threadID: item.threadID, postEntity: item));

                  // context.showSnackBar(message: item==null?"item is null":"not null");

                  // feedCubit.onRefresh();
                  // context.showSnackBar(message: "test");
                },
                child: ViewPostScreen(
                  postEntity: item,
                  threadID: item.threadID,
                ),
              ),
              onClosed: (s) async {
                var item = widget.pagingController.itemList[index];
                if (item != s) {
                  widget.pagingController.itemList[index] = s;
                  widget.pagingController.notifyListeners();
                }

                // Future.delayed(Duration(milliseconds: 600), () {
                //   feedCubit.onRefresh();
                // });
              },
            );
          });
  @override
  void dispose() {
    super.dispose();
  }
}

class PrivacyProtectedErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.privacy_tip_outlined,
              color: AppColors.colorPrimary,
              size: 40,
            ),
            10.toSizedBox,
            'This profile is protected'
                .toSubTitle1(fontWeight: FontWeight.w600),
            10.toSizedBox,
            'Only approved followers can see the posts and content of this profile, click the (Follow) button to see their posts!'
                .toSubTitle2(align: TextAlign.center),
            10.toSizedBox,
            "Go Back"
                .toButton(color: AppColors.colorPrimary)
                .toHorizontalPadding(24)
                .toOutlinedBorder(() {
              ExtendedNavigator.root.pop();
            })
          ],
        ),
      ).toHorizontalPadding(24);
}
