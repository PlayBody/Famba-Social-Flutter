import '../../../../core/common/api/api_constants.dart';
import '../../../../core/common/failure.dart';
import '../../../../core/common/pagination/custom_pagination.dart';
import '../../../../core/common/pagination/text_model_with_offset.dart';
import '../../domain/entity/hashtag_entity.dart';
import '../../domain/usecase/search_hastag_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class HashTagPagination extends CustomPagination<HashTagEntity>
    with SearchingMixin<HashTagEntity> {
  final SearchHashtagsUseCase searchHashtagsUseCase;

  HashTagPagination(this.searchHashtagsUseCase) {
    enableSearch();
  }

  @override
  Future<Either<Failure, List<HashTagEntity>>> getItems(int pageKey) async {
    return await searchHashtagsUseCase(
        TextModelWithOffset(queryText: queryText, offset: pageKey.toString()));
  }

  @override
  HashTagEntity getLastItemWithoutAd(List<HashTagEntity> item) {
    return item.last;
  }

  @override
  int getNextKey(HashTagEntity item) {
    return int.tryParse(item.id);
  }

  @override
  bool isLastPage(List<HashTagEntity> item) {
    return item.length < ApiConstants.pageSize;
  }

  @override
  onClose() {
    super.onClose();
    disposeMixin();
    pagingController.dispose();
  }
}
