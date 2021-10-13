import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../core/common/stream_validators.dart';
import '../../../../core/common/uistate/common_ui_state.dart';
import '../../../../core/theme/strings.dart';
import '../../../feed/domain/entity/post_entity.dart';
import '../../../feed/domain/usecase/create_post_use_case.dart';
import '../../../feed/domain/usecase/like_unlike_use_case.dart';
import '../../../feed/domain/usecase/repost_use_case.dart';
import '../../data/model/response/post_detail_response.dart';
import '../../domain/usecases/add_remove_bookmark_use_case.dart';
import '../../domain/usecases/delete_post_use_case.dart';
import '../../domain/usecases/get_threaded_post_use_case.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../extensions.dart';
part 'view_post_state.dart';

@injectable
class ViewPostCubit extends Cubit<CommonUIState> {
  FieldValidators postReplyValidator = FieldValidators(null, null);

  final GetThreadedPostUseCase getThreadedPostUseCase;

  final CreatePostUseCase createPostUseCase;

  final LikeUnlikeUseCase likeUnlikeUseCase;

  final RepostUseCase repostUseCase;

  final AddOrRemoveBookmarkUseCase addOrRemoveUseCase;

  final DeletePostUseCase deletePostUseCase;

  ViewPostCubit(
      this.getThreadedPostUseCase,
      this.createPostUseCase,
      this.likeUnlikeUseCase,
      this.repostUseCase,
      this.addOrRemoveUseCase,
      this.deletePostUseCase)
      : super(const CommonUIState.initial());
  List<PostEntity> _items = [];

  List<PostEntity> get items => _items;

  final _parentPostControllerController = BehaviorSubject<List<PostEntity>>();

  Function(List<PostEntity>) get changePostEntity =>
      _parentPostControllerController.sink.add;

  Stream<List<PostEntity>> get parentPostEntity =>
      _parentPostControllerController.stream;

  getParentPost(String threadId) async {
    emit(const CommonUIState.loading());
    var either = await getThreadedPostUseCase(threadId);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) {
      _items..clear();
      loadPageData(r);
    });
  }

  Future<void> likeUnLikePost(int index) async {
    var currentItem = _items[index];
    _items[index] = _items[index].copyWith(
        isLiked: !currentItem.isLiked,
        likeCount: (currentItem.isLiked
                ? currentItem.likeCount.dec
                : currentItem.likeCount.inc)
            .toString());
    changePostEntity(_items);
    await likeUnlikeUseCase(_items[index].postId);
  }

  Future<void> addRemoveBook(int index) async {
    var item = _items[index];
    _items[index] = item.copyWith(
      isSaved: !item.isSaved,
    );
    var either = await addOrRemoveUseCase(item.postId);
    either.fold((l) {
      _items[index] = item.copyWith(
        isSaved: !item.isSaved,
      );
    }, (r) {
      var message = _items[index].isSaved
          ? Strings.bookmarkAdded
          : Strings.removeBookmark;
      emit(CommonUIState.success(message));
      emit(const CommonUIState.initial());
    });
    changePostEntity(_items);
  }

  Future<void> repost(int index) async {
    var item = _items[index];
    _items[index] = item.copyWith(
        isReposted: !item.isReposted,
        repostCount:
            (item.isReposted ? item.repostCount.dec : item.repostCount.inc)
                .toString());
    changePostEntity(_items);
    await repostUseCase(_items[index].postId);
  }

  Future<void> deletePost(int index) async {
    ExtendedNavigator.root.pop();
    emit(const CommonUIState.loading());
    var item = _items[index];

    var either = await deletePostUseCase(item.postId.toString());
    either.fold((l) {
      emit(const CommonUIState.initial());
      emit(CommonUIState.error(l.errorMessage));
      _items.insert(index, item);
    }, (r) {
      _items.removeAt(index);
      changePostEntity(_items);
      emit(const CommonUIState.initial());
      emit(const CommonUIState.success("Deleted Successfully"));
    });
  }

  void loadPageData(PostDetailResponse r) {
    List<PostEntity> postItems = [];
    var nextItems = r.data.next;
    var prevItems = r.data.prev;

    var parentItem = PostEntity.fromFeed(r.data.post);

    if (prevItems.isNotEmpty) {
      prevItems.forEach((prevPostItem) {
        // add item then add replies below if there are
        var prevItem = PostEntity.fromPostDetails(prevPostItem);
        // check if next item has replies
        if (prevPostItem.replys.isNotEmpty) {
          // add next item then add it's replies
          postItems.add(prevItem.copyWith(
              isConnected: true,
              isReplyItem: true,
              parentPostUsername: parentItem.userName));
          prevPostItem.replys.forEach((reply) {
            var replyItem = PostEntity.fromPostDetails(reply);
            postItems.add(
              replyItem.copyWith(
                  isConnected: false,
                  isReplyItem: prevPostItem.replys.last.id != reply.id,
                  parentPostUsername: parentItem.userName),
            );
            // helps to add full divider
            if (prevPostItem.replys.last.id == reply.id) {
              postItems.add(replyItem.copyWith(
                  showFullDivider: true,
                  isConnected: false,
                  isReplyItem: false,
                  parentPostUsername: parentItem.userName));
            }
          });
        } else {
          postItems.add(prevItem.copyWith(
              isConnected: true,
              isReplyItem: true,
              parentPostUsername: parentItem.userName));
          // postItems.add(prevItem.copyWith(isConnected: false,isReplyItem: false,showFullDivider: false));
        }
      });
    }

    // if there is no prev item we will add on top of our array
    // else will add main post item below the parent tree ( we're getting this from prev posts)
    if (prevItems.isNotEmpty) {
      // parentItem = parentItem.copyWith(isConnected: false,time: r.data.post.timeRaw.toTime);
      parentItem = parentItem.copyWith(isConnected: false, isReplyItem: true);
    }
    // postItems.add(parentItem.copyWith(time: r.data.post.timeRaw.toTime));
    postItems.add(parentItem);
    postItems.add(PostEntity.fromDummy()
        .copyWith(parentPostTime: r.data.post.timeRaw.toTime));

    // check next array if it's not empty then add items
    // choose next second because it will contain child post
    if (nextItems.isNotEmpty) {
      nextItems.forEach((nextPostItem) {
        // add item then add replies below if there are
        var nextItem = PostEntity.fromPostDetails(nextPostItem)
            .copyWith(parentPostUsername: parentItem.userName);
        // check if next item has replies
        if (nextPostItem.replys.isNotEmpty) {
          // add next item then add it's replies
          if (nextItems.indexOf(nextPostItem) == 0 && prevItems.isNotEmpty) {
            postItems.add(nextItem.copyWith(
                isConnected: false,
                isReplyItem: true,
                parentPostUsername: parentItem.userName));
          } else
            postItems.add(nextItem.copyWith(
                isConnected: true,
                isReplyItem: true,
                parentPostUsername: parentItem.userName));

          nextPostItem.replys.forEach((reply) {
            var replyItem = PostEntity.fromPostDetails(reply);
            postItems.add(replyItem.copyWith(
                isConnected: nextPostItem.replys.last.id != reply.id,
                isReplyItem: true,
                parentPostUsername: parentItem.userName));
            if (nextPostItem.replys.last.id == reply.id) {
              postItems.add(replyItem.copyWith(
                  showFullDivider: true,
                  isConnected: false,
                  isReplyItem: false,
                  parentPostUsername: parentItem.userName));
            }
          });
        } else {
          postItems.add(
            nextItem,
          );
          // helps to adding divider
          postItems.add(nextItem.copyWith(
              showFullDivider: true, isConnected: false, isReplyItem: false));
        }
      });
    }

    // post data to ui
    changePostEntity(postItems);
    _items.addAll(postItems);
    emit(const CommonUIState.success(""));
  }
}
