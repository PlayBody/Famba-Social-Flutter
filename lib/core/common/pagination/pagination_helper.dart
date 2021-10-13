import '../failure.dart';
import '../../../features/feed/presentation/widgets/feed_widgets.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

abstract class PostPaginatonCubit<T, S> extends Cubit<S> {
  bool isLoading = false;

  final dynamic initCubitState;

  final PagingController<int, T> pagingController =
      PagingController<int, T>(firstPageKey: 0);

  PagingStatus pagingStatus;

  PostPaginatonCubit(this.initCubitState) : super(initCubitState) {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    pagingController.addStatusListener((status) {
      pagingStatus = status;
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      isLoading = true;
      final response = await getItems(pageKey);
      response.fold((l) {
        isLoading = false;
        if (l.errorMessage == "No data found")
          pagingController.appendLastPage([]);
        else
          pagingController.error = l.errorMessage;
      }, (items) {
        isLoading = false;
        if (isLastPage(items)) {
          pagingController.appendLastPage(items);
        } else {
          final nextPageKey = getNextKey(getLastItemWithoutAd(items));

          pagingController.appendPage(items, nextPageKey);
        }
      });
    } catch (error) {
      isLoading = false;
      pagingController.error = error;
    }
  }

  Future<Either<Failure, List<T>>> getItems(int pageKey);

  int getNextKey(T item);

  bool isLastPage(List<T> item);

  T getLastItemWithoutAd(List<T> item);

  Future<void> likeUnlikePost(int index);
  Future<void> repost(int index);
  Future<void> deletePost(int index);
  Future<void> addOrRemoveBookmark(int index);

  Future onOptionItemSelected(PostOptionsEnum postOptionsEnum, int index);

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }

  void onRefresh() {
    if (!isLoading) {
      pagingController?.itemList?.clear();
      pagingController.refresh();
    }
  }
}
