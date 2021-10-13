import '../../../features/profile/domain/usecase/follow_unfollow_use_case.dart';
import '../../../features/search/domain/entity/people_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: invalid_use_of_protected_member
mixin FollowUnFollowMixin {
  @protected
  PagingController<int, PeopleEntity> get pagingControllerMixin;

  @protected
  FollowUnFollowUseCase get followUnFollowUseCaseMixin;

  followUnFollow(int index) async {
    var currentItem = pagingControllerMixin.itemList[index];
    pagingControllerMixin.itemList[index] = currentItem.copyWith(
        isFollowed: !currentItem.isFollowed,
        buttonText: currentItem.isFollowed ? "Unfollow" : "follow");
    pagingControllerMixin.notifyListeners();

    var either = await followUnFollowUseCaseMixin(currentItem.id);
    either.fold((l) {
      // emit(CommonUIState.error(l.errorMessage));
      pagingControllerMixin
        ..itemList[index] = currentItem.copyWith(
            isFollowed: !currentItem.isFollowed,
            buttonText: currentItem.isFollowed ? "Unfollow" : "follow")
        ..notifyListeners();
    }, (r) {});
  }
}
