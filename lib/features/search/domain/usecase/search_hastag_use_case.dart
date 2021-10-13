import '../../../../core/common/failure.dart';
import '../../../../core/common/pagination/text_model_with_offset.dart';
import '../../../../core/common/usecase.dart';
import '../entity/hashtag_entity.dart';
import '../repo/search_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchHashtagsUseCase
    extends UseCase<List<HashTagEntity>, TextModelWithOffset> {
  final SearchRepo searchRepo;

  SearchHashtagsUseCase(this.searchRepo);
  @override
  Future<Either<Failure, List<HashTagEntity>>> call(
      TextModelWithOffset params) async {
    return searchRepo.searchHashtag(params);
  }
}
