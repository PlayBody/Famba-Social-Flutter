import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../entity/post_entity.dart';
import '../repo/feed_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFeedPostUseCase extends UseCase<List<PostEntity>, String> {
  final FeedRepo feedRepo;

  GetFeedPostUseCase(this.feedRepo);

  @override
  Future<Either<Failure, List<PostEntity>>> call(String params) {
    return feedRepo.getFeeds(params);
  }
}
