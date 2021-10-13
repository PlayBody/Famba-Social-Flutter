import '../api/api_constants.dart';
import 'pagination_helper.dart';
import '../uistate/common_ui_state.dart';
import '../../../features/feed/domain/entity/post_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rxdart/rxdart.dart';

import '../failure.dart';

abstract class CustomPagination<T> {
  bool isLoading = false;

  final PagingController<int, T> pagingController =
      PagingController<int, T>(firstPageKey: 0);

  final _itemControllerController = BehaviorSubject<int>.seeded(0);

  Function(int) get changeItemLength => _itemControllerController.sink.add;

  Stream<int> get itemLength => _itemControllerController.stream;

  CustomPagination() {
    pagingController.addPageRequestListener((pageKey) {
      print("current page key : $pageKey");
      _fetchPage(pageKey);
    });
    pagingController.addStatusListener((status) {
      print("current page status : $status");
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      isLoading = true;
      final response = await getItems(pageKey);
      response.fold(
        (l) {
          isLoading = false;
          if (l.errorMessage == "No data found")
            pagingController.appendLastPage([]);
          else
            pagingController.error = l.errorMessage;
        },
        (items) {
          changeItemLength(_itemControllerController.value + items.length);
          // check if last item is of advertisement
          isLoading = false;
          if (isLastPage(items)) {
            pagingController.appendLastPage(items);
          } else {
            final nextPageKey = getNextKey(getLastItemWithoutAd(items));
            pagingController.appendPage(items, nextPageKey);
          }
        },
      );
    } catch (error) {
      isLoading = false;
      pagingController.error = error;
    }
  }

  Future<Either<Failure, List<T>>> getItems(int pageKey);

  // used for sending to sever for fetching next chunk of data
  int getNextKey(T item);

  // to check if there is no more data available
  bool isLastPage(List<T> item);

  // get last item for getting offset value for pagination
  // if there is object with advertisement there will be no offset
  // so we will have to look the very last object that is not a type of ad object
  T getLastItemWithoutAd(List<T> item);

  onClose() {
    _itemControllerController.close();
  }

  bool commonLastPage(List<T> items) {
    if (items.length < ApiConstants.pageSize) return true;
    return false;
  }

  void onRefresh() {
    if (!isLoading) {
      pagingController.refresh();
      changeItemLength(0);
    }
  }
}

// helps to add searching functionality to the custom pagination
// without add another method in CustomPagination
mixin SearchingMixin<T> on CustomPagination<T> {
  final _searchControllerController = BehaviorSubject<String>.seeded(" ");

  Function(String) get changeSearch => _searchControllerController.sink.add;

  Stream<String> get search => _searchControllerController.stream
          .debounce(
        (_) => TimerStream(
          true,
          const Duration(
            milliseconds: 500,
          ),
        ),
      )
          .switchMap((query) async* {
        yield query;
      }).distinct();

  TextEditingController textEditingController = TextEditingController();

  String _searchedText = " ";

  String get queryText => _searchedText;

  set queryText(String text) {
    if (text.isEmpty) text = " ";
    // searchedText=event;
    _searchedText = text;
    textEditingController.text = text;
    changeSearch(_searchedText);
  }

  enableSearch() {
    search.listen((event) {
      // default value for getting all data
      if (event.isEmpty) event = " ";
      _searchedText = event;
      onRefresh();
    });
  }

  disposeMixin() {
    textEditingController.dispose();
    _searchControllerController.close();
  }
}

mixin PostSearchingMixin<T> on PostPaginatonCubit<PostEntity, CommonUIState> {
  final _searchControllerController = BehaviorSubject<String>.seeded(" ");

  Function(String) get changeSearch => _searchControllerController.sink.add;

  Stream<String> get search => _searchControllerController.stream
          .debounce((_) => TimerStream(true, const Duration(milliseconds: 500)))
          .switchMap((query) async* {
        yield query;
      });

  TextEditingController textEditingController = TextEditingController();

  String _searchedText = " ";

  String get searchedText => _searchedText;

  set searchedText(String text) {
    if (text.isEmpty) text = " ";
    // searchedText=event;
    _searchedText = text;
    textEditingController.text = text;
    changeSearch(_searchedText);
  }

  enableSearch() {
    search.listen((event) {
      // default value for getting all data
      if (event.isEmpty) event = " ";
      _searchedText = event;
      onRefresh();
    });
  }

  disposeMixin() {
    textEditingController.dispose();
    _searchControllerController.close();
  }
}
