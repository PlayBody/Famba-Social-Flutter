// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: invalid_use_of_protected_member
import 'package:bloc/bloc.dart';
import 'package:colibri/core/common/uistate/common_ui_state.dart';
import 'package:colibri/features/profile/domain/usecase/follow_unfollow_use_case.dart';
import 'package:colibri/features/search/presentation/pagination/hashtag_pagination.dart';
import 'package:colibri/features/search/presentation/pagination/people_pagination.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'search_state.dart';

@injectable
class SearchCubit extends Cubit<CommonUIState> {
  // pagination
  final HashTagPagination hashTagPagination;

  final PeoplePagination peoplePagination;

  // use cases

  final FollowUnFollowUseCase followUnFollowUseCase;

  SearchCubit(
      this.hashTagPagination, this.peoplePagination, this.followUnFollowUseCase)
      : super(const CommonUIState.initial());

  @override
  Future<void> close() {
    hashTagPagination.onClose();
    peoplePagination.onClose();
    return super.close();
  }

  followUnFollow(int index) async {
    var currentItem = peoplePagination.pagingController.itemList[index];
    peoplePagination.pagingController.itemList[index] = currentItem.copyWith(
      isFollowed: !currentItem.isFollowed,
      buttonText: currentItem.isFollowed ? "Unfollow" : "follow",
    );
    peoplePagination.pagingController.notifyListeners();

    var either = await followUnFollowUseCase(currentItem.id);
    either.fold((l) {
      emit(CommonUIState.error(l.errorMessage));
      peoplePagination.pagingController
        ..itemList[index] = currentItem.copyWith(
            isFollowed: !currentItem.isFollowed,
            buttonText: currentItem.isFollowed ? "Unfollow" : "follow")
        ..notifyListeners();
    }, (r) {});
  }
}
