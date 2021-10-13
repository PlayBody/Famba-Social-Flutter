// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: invalid_use_of_protected_member
import 'package:colibri/core/common/api/api_constants.dart';
import 'package:colibri/core/common/failure.dart';
import 'package:colibri/core/common/pagination/custom_pagination.dart';
import 'package:colibri/core/common/pagination/pagination_helper.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/core/constants/appconstants.dart';
import 'package:colibri/core/theme/strings.dart';
import 'package:colibri/features/feed/domain/entity/post_entity.dart';
import 'package:colibri/features/feed/domain/usecase/like_unlike_use_case.dart';
import 'package:colibri/features/feed/domain/usecase/repost_use_case.dart';
import 'package:colibri/features/posts/domain/usecases/add_remove_bookmark_use_case.dart';
import 'package:colibri/features/posts/domain/usecases/delete_post_use_case.dart';
import 'package:colibri/features/posts/presentation/bloc/post_cubit.dart';
import 'package:colibri/main.dart';
import 'package:dartz/dartz.dart';
import 'package:colibri/extensions.dart';
import 'package:http/http.dart' as http;

mixin PostInteractionMixin on PostPaginatonCubit<PostEntity, CommonUIState> {
  Future<Either<Failure, String>> mAddRemoveBookmark(
      int index, AddOrRemoveBookmarkUseCase addOrRemoveBookmarkUseCase) async {
    var item = pagingController.itemList[index];
    pagingController.itemList[index] = item.copyWith(
      isSaved: !item.isSaved,
    );
    pagingController.notifyListeners();
    var either = await addOrRemoveBookmarkUseCase(item.postId);
    return either.fold((l) {
      var oldItem = pagingController.itemList[index];
      pagingController.itemList[index] = oldItem.copyWith(
        isSaved: !oldItem.isSaved,
      );
      pagingController.notifyListeners();

      return left(l);
    }, (r) {
      var message = pagingController.itemList[index].isSaved
          ? Strings.bookmarkAdded
          : Strings.removeBookmark;
      return right(message);
    });
  }

  Future<Either<Failure, String>> mDeletePost(
      int index, DeletePostUseCase deletePostUseCase) async {
    var either = await deletePostUseCase(
        pagingController.itemList[index].postId.toString());
    return either.fold((l) {
      return left(l);
    }, (r) {
      pagingController.itemList.removeAt(index);
      pagingController.notifyListeners();
      return right("Post Deleted Successfully");
    });
  }

  PostCubit postCubit;

  Future<Either<Failure, String>> mRepost(
      int index, RepostUseCase repostUseCase) async {
    // postCubit = getIt<PostCubit>();
    // postCubit.onRefresh();
    loginResponse = await localDataSource.getUserAuth();

    final item = pagingController.itemList[index];
    final allItems = pagingController.itemList
        .where((element) => element.postId == item.postId)
        .toList();

    /// case of removing reposted item
    /// if items is already reposteed
    if (item?.showRepostedText == true) {
      /// if the reposted items is not owned by the other person
      /// current user is reposted this particular item
      /// or owner of the post is not the logged in current user but current user reposted the post
      if (!item.isOtherUser || item.isReposted) {
        /// Firstly removed the item from the list
        ///
        /// find the reposted post item with having name of current user in reposted text
        final firstWhere = pagingController.itemList.firstWhere(
            (element) => element.postId == item.postId,
            orElse: () => null);
        if (firstWhere != null) {
          /// remove post item
          final removedIndex = pagingController.itemList.indexOf(firstWhere);
          pagingController
            ..itemList.removeAt(removedIndex)
            ..notifyListeners();

          /// also removed from global list
          allItems.removeAt(removedIndex);

          /// updated all items with new values
          allItems.asMap().forEach((index, value) {
            pagingController.itemList[index] = value.copyWith(
                isReposted: false, repostCount: value.repostCount.dec);
          });
        } else {
          pagingController
            ..itemList.removeAt(index)
            ..notifyListeners();

          /// get all items of that particular item (we have more more than one post of same id) so that we can update reposted count on each post

          /// assigning & updated resposted count and isResposted to false
          allItems.asMap().forEach((index, value) {
            pagingController
              ..itemList[index] = value.copyWith(
                  repostCount: value.repostCount.dec.toString(),
                  isReposted: false)
              ..notifyListeners();
          });
        }
        // if(firstWhere!=null){
        //   var index=pagingController.itemList.indexOf(firstWhere);
        //   pagingController.itemList[index]=firstWhere.copyWith(isReposted: !item.isReposted,
        //       repostCount: item.repostCount.dec.toString());
        // }
      }

      /// owner of post is other user
      /// we don't remove the post from current index
      /// and add the same post as reposted post on the top of the list
      else {
        final firstWhere = pagingController.itemList.firstWhere(
            (element) => element.postId == item.postId,
            orElse: () => null);
        if (firstWhere != null) {
          // var index=pagingController.itemList.indexOf(firstWhere);
          /// at last we're adding reposted post on the top of the list
          pagingController
            ..itemList.insert(
                0,
                firstWhere.copyWith(
                    isReposted: true,
                    repostCount: item.repostCount.inc.toString(),
                    showRepostedText: true,
                    reposterFullname: "You",
                    isOtherUser: false))
            ..notifyListeners();
        } else {
          /// getting all post items with reposted or without reposted
          /// so that we can increase the repost count on each item
          var list = pagingController.itemList
              .where((element) => element.postId == item.postId)
              .toList();

          /// all items with same post ids
          list.asMap().forEach((index, value) {
            /// updating the items with incremented reposted value
            pagingController.itemList[index] = item.copyWith(
                repostCount: item.repostCount.inc.toString(),
                isReposted: true,
                reposterFullname:
                    pagingController.itemList[index].reposterFullname,
                showRepostedText:
                    pagingController.itemList[index].showRepostedText);
          });
        }
      }
    } else {
      pagingController
        ..itemList[index] = item.copyWith(
            isReposted: true, repostCount: item.repostCount.inc.toString())
        ..notifyListeners();

      Future.delayed(Duration(seconds: 2), () {
        pagingController
          ..itemList.insert(
              0,
              item.copyWith(
                  showRepostedText: true,
                  reposterFullname: "You",
                  isOtherUser: false,
                  repostCount: item.repostCount.inc.toString(),
                  isReposted: true));
        // ..notifyListeners();
      });

      // var firstWhere = pagingController.itemList.firstWhere((element) => element.postId==item.postId&&element.showRepostedText,orElse:()=> null);
      // if(firstWhere!=null&&firstWhere.showRepostedText){
      //   pagingController.itemList.removeAt(pagingController.itemList.indexOf(firstWhere));
      //   var firstWhere2 = pagingController.itemList.firstWhere((element) => element.postId==item.postId,orElse:()=> null);
      //   var indexOf = pagingController.itemList.indexOf(firstWhere2);
      //   pagingController.itemList[indexOf]=firstWhere2.copyWith(isReposted: false,repostCount: firstWhere2.repostCount.dec);
      // }
      // else{
      //   pagingController.itemList[index]=item.copyWith(isReposted: !item.isReposted,
      //       repostCount: (item.isReposted?item.repostCount.dec:item.repostCount.inc).toString());
      //
      //
      //   pagingController..itemList.insert(0, item.copyWith(showRepostedText: true,repostCount: item.repostCount.inc.toString(),isReposted: true))..notifyListeners();
      // }
    }

    pagingController.notifyListeners();

    await repostUseCase(item.postId);

    myRepostShow(item.postId);

    var either = await repostUseCase(item.postId);
    return either.fold((l) {
      pagingController.itemList.insert(index, item);
      pagingController.notifyListeners();
      return left(l);
    }, (r) => right(""));
  }

  Future<Either<Failure, String>> mLikeUnlike(
      int index, LikeUnlikeUseCase likeUnlikeUseCase) async {
    var item = pagingController.itemList[index];
    pagingController.itemList[index] = item.copyWith(
        isLiked: !item.isLiked,
        likeCount: (item.isLiked ? item.likeCount.dec : item.likeCount.inc)
            .toString());
    pagingController.notifyListeners();
    var either = await likeUnlikeUseCase(item.postId);
    return either.fold((l) {
      var oldItem = pagingController.itemList[index];
      pagingController.itemList[index] = oldItem.copyWith(
          isLiked: !oldItem.isLiked,
          likeCount:
              (oldItem.isLiked ? oldItem.likeCount.dec : oldItem.likeCount.inc)
                  .toString());
      pagingController.notifyListeners();
      // emit(CommonUIState.error(l.errorMessage));
      // emit(CommonUIState.initial());
      return left(l);
    }, (r) => right(""));
  }

  static var loginResponse;

  Future<http.Response> myRepostShow(String postId) async {
    String uri = ApiConstants.baseUrl + ApiConstants.publicationRepost;
    Map<String, dynamic> requestBody = {
      "session_id":
          AC.loginResponse?.authToken ?? loginResponse?.authToken ?? "",
      "post_id": postId
    };

    // emit(const CommonUIState.loading());

    try {
      http.Response response =
          await http.post(Uri.parse(uri), body: requestBody);
      print("Repost data $response");
      // postCubit.onRefresh();
      return response;
    } catch (e) {
      print("respont data in error =>>  $e");
      return null;
    }
  }
}
mixin PostInteractionMixinOnCustomPagination on CustomPagination<PostEntity> {
  Future<Either<Failure, String>> mAddRemoveBookmark(
      int index, AddOrRemoveBookmarkUseCase addOrRemoveBookmarkUseCase) async {
    var item = pagingController.itemList[index];
    pagingController.itemList[index] = item.copyWith(
      isSaved: !item.isSaved,
    );
    pagingController.notifyListeners();
    var either = await addOrRemoveBookmarkUseCase(item.postId);
    return either.fold((l) {
      var oldItem = pagingController.itemList[index];
      pagingController.itemList[index] = oldItem.copyWith(
        isSaved: !oldItem.isSaved,
      );
      pagingController.notifyListeners();
      // emit(CommonUIState.error(l.errorMessage));
      // emit(CommonUIState.initial());
      return left(l);
    }, (r) {
      var message = pagingController.itemList[index].isSaved
          ? Strings.bookmarkAdded
          : Strings.removeBookmark;
      // emit(CommonUIState.success(message));
      // emit(CommonUIState.initial());
      return right(message);
    });
  }

  Future<Either<Failure, String>> mDeletePost(
      int index, DeletePostUseCase deletePostUseCase) async {
    var either = await deletePostUseCase(
        pagingController.itemList[index].postId.toString());
    return either.fold((l) => left(l), (r) {
      // emit(CommonUIState.initial());
      // emit(CommonUIState.success("Deleted Successfully"));
      pagingController.itemList.removeAt(index);
      pagingController.notifyListeners();
      return right(r);
    });
  }

  Future<Either<Failure, String>> mRepost(
      int index, RepostUseCase repostUseCase) async {
    var item = pagingController.itemList[index];
    if (item?.showRepostedText == true) {
      pagingController.itemList.removeAt(index);
    } else {
      pagingController.itemList[index] = item.copyWith(
          isReposted: !item.isReposted,
          repostCount:
              (item.isReposted ? item.repostCount.dec : item.repostCount.inc)
                  .toString());
    }
    pagingController.notifyListeners();
    var either = await repostUseCase(item.postId);
    return either.fold((l) {
      pagingController.itemList.insert(index, item);
      pagingController.notifyListeners();
      return left(l);
    }, (r) => right(""));
  }

  Future<Either<Failure, String>> mLikeUnlike(
      int index, LikeUnlikeUseCase likeUnlikeUseCase) async {
    var item = pagingController.itemList[index];
    pagingController.itemList[index] = item.copyWith(
        isLiked: !item.isLiked,
        likeCount: (item.isLiked ? item.likeCount.dec : item.likeCount.inc)
            .toString());
    pagingController.notifyListeners();
    var either = await likeUnlikeUseCase(item.postId);
    return either.fold((l) {
      var oldItem = pagingController.itemList[index];
      pagingController.itemList[index] = oldItem.copyWith(
          isLiked: !oldItem.isLiked,
          likeCount:
              (oldItem.isLiked ? oldItem.likeCount.dec : oldItem.likeCount.inc)
                  .toString());
      pagingController.notifyListeners();
      // emit(CommonUIState.error(l.errorMessage));
      // emit(CommonUIState.initial());
      return left(l);
    }, (r) => right(""));
  }
}
