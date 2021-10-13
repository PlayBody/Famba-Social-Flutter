// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: invalid_use_of_protected_member
import 'package:colibri/core/common/api/api_constants.dart';
import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/pagination/pagination_helper.dart';
import 'package:colibri/core/common/stream_validators.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/core/theme/strings.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/feed/domain/usecase/like_unlike_use_case.dart';
import 'package:colibri/features/feed/domain/usecase/repost_use_case.dart';
import 'package:colibri/features/feed/presentation/widgets/feed_widgets.dart';
import 'package:colibri/features/posts/domain/usecases/add_remove_bookmark_use_case.dart';
import 'package:colibri/features/posts/domain/usecases/delete_post_use_case.dart';
import 'package:colibri/features/profile/domain/usecase/get_bookmarks_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:colibri/extensions.dart';
part 'bookmark_state.dart';

@injectable
class BookmarkCubit extends PostPaginatonCubit<PostEntity, CommonUIState> {
  final searchQuery = FieldValidators(null, null);

  final GetBookmarksUseCase getBookmarksUseCase;
  final AddOrRemoveBookmarkUseCase addOrRemoveUseCase;
  final LikeUnlikeUseCase likeUnlikeUseCase;
  final RepostUseCase repostUseCase;
  final DeletePostUseCase deletePostUseCase;
  BookmarkCubit(this.getBookmarksUseCase, this.addOrRemoveUseCase,
      this.likeUnlikeUseCase, this.repostUseCase, this.deletePostUseCase)
      : super(const CommonUIState.initial());

  @override
  Future<void> addOrRemoveBookmark(int index) async {
    var item = pagingController.itemList[index];
    pagingController.itemList[index] = item.copyWith(
      isSaved: !item.isSaved,
    );
    pagingController.notifyListeners();
    var either = await addOrRemoveUseCase(item.postId);
    either.fold((l) {
      var oldItem = pagingController.itemList[index];
      pagingController.itemList[index] = oldItem.copyWith(
        isSaved: !oldItem.isSaved,
      );
      pagingController.notifyListeners();
      emit(CommonUIState.error(l.errorMessage));
      emit(const CommonUIState.initial());
    }, (r) {
      pagingController.itemList.removeAt(index);
      pagingController.notifyListeners();
      var message = Strings.removeBookmark;
      emit(CommonUIState.success(message));
      emit(const CommonUIState.initial());
    });
  }

  @override
  Future<void> deletePost(int index) async {
    var either = await deletePostUseCase(
        pagingController.itemList[index].postId.toString());
    either.fold((l) {
      emit(const CommonUIState.initial());
      emit(CommonUIState.error(l.errorMessage));
    }, (r) {
      emit(const CommonUIState.initial());
      emit(const CommonUIState.success("Deleted Successfully"));
      pagingController.itemList.removeAt(index);
      pagingController.notifyListeners();
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getItems(int pageKey) async {
    return await getBookmarksUseCase(pageKey.toString());
  }

  @override
  int getNextKey(PostEntity item) {
    return item.offSetId ?? 0;
  }

  @override
  bool isLastPage(List<PostEntity> item) {
    // check if response has an advertisement object
    // if yes then item length will always be [ApiConstants.pageSize+1]
    if (item.last.isAdvertisement && item.length == ApiConstants.pageSize + 1)
      return false;
    else if (!item.last.isAdvertisement && item.length == ApiConstants.pageSize)
      return false;
    return true;
  }

  @override
  PostEntity getLastItemWithoutAd(List<PostEntity> item) {
    // if there is an ad object as last we will give
    // second last item for calculating offset value
    if (item.last.isAdvertisement) return item[item.length - 2];
    return item.last;
  }

  @override
  Future<void> likeUnlikePost(int index) async {
    var item = pagingController.itemList[index];
    pagingController.itemList[index] = item.copyWith(
        isLiked: !item.isLiked,
        likeCount: (item.isLiked ? item.likeCount.dec : item.likeCount.inc)
            .toString());
    pagingController.notifyListeners();
    var either = await likeUnlikeUseCase(item.postId);
    either.fold((l) {
      var oldItem = pagingController.itemList[index];
      pagingController.itemList[index] = oldItem.copyWith(
          isLiked: !oldItem.isLiked,
          likeCount:
              (oldItem.isLiked ? oldItem.likeCount.dec : oldItem.likeCount.inc)
                  .toString());
      pagingController.notifyListeners();
      emit(CommonUIState.error(l.errorMessage));
      emit(const CommonUIState.initial());
    }, (r) {});
  }

  @override
  Future<void> repost(int index) async {
    var item = pagingController.itemList[index];

    // remove show reposted image first
    if (item?.showRepostedText == true) {
      pagingController.itemList.removeAt(index);
      var firstWhere = pagingController.itemList.firstWhere(
          (element) => element.postId == item.postId,
          orElse: () => null);
      if (firstWhere != null) {
        var index = pagingController.itemList.indexOf(firstWhere);
        pagingController.itemList[index] = firstWhere.copyWith(
            isReposted: !item.isReposted,
            repostCount:
                (item.isReposted ? item.repostCount.dec : item.repostCount.inc)
                    .toString());
      }
    } else {
      var firstWhere = pagingController.itemList.firstWhere(
          (element) =>
              element.postId == item.postId &&
              element?.showRepostedText == true,
          orElse: () => null);
      if (firstWhere != null && firstWhere.showRepostedText) {
        pagingController.itemList
            .removeAt(pagingController.itemList.indexOf(firstWhere));
        var firstWhere2 = pagingController.itemList.firstWhere(
            (element) => element.postId == item.postId,
            orElse: () => null);
        var indexOf = pagingController.itemList.indexOf(firstWhere2);
        pagingController.itemList[indexOf] = firstWhere2.copyWith(
            isReposted: false, repostCount: firstWhere2.repostCount.dec);
      } else {
        pagingController.itemList[index] = item.copyWith(
            isReposted: !item.isReposted,
            repostCount:
                (item.isReposted ? item.repostCount.dec : item.repostCount.inc)
                    .toString());

        pagingController
          ..itemList.insert(
              0,
              item.copyWith(
                  showRepostedText: true,
                  repostCount: item.repostCount.inc.toString(),
                  isReposted: true))
          ..notifyListeners();
      }
    }
    pagingController.notifyListeners();
    await repostUseCase(item.postId);
    // await repostUseCase(item.postId);
  }

  @override
  Future onOptionItemSelected(
      PostOptionsEnum postOptionsEnum, int index) async {
    switch (postOptionsEnum) {
      case PostOptionsEnum.REPORT:
        break;
      case PostOptionsEnum.SHOW_LIKES:
        break;
      case PostOptionsEnum.BOOKMARK:
        await addOrRemoveBookmark(index);
        break;
      case PostOptionsEnum.DELETE:
        await deletePost(index);
        break;
    }
  }
}
