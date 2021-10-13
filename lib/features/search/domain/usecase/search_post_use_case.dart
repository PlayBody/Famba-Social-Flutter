import '../../../../core/common/failure.dart';
import '../../../../core/common/pagination/text_model_with_offset.dart';
import '../../../../core/common/usecase.dart';
import '../../../feed/domain/entity/post_entity.dart';
import '../repo/search_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchPostUseCase extends UseCase<List<PostEntity>, TextModelWithOffset> {
  final SearchRepo searchRepo;

  SearchPostUseCase(this.searchRepo);
  @override
  Future<Either<Failure, List<PostEntity>>> call(
      TextModelWithOffset params) async {
    return searchRepo.searchPosts(params);
  }
}
