import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../data/model/response/post_detail_response.dart';
import '../post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetThreadedPostUseCase extends UseCase<PostDetailResponse, String> {
  final PostRepo postRepo;

  GetThreadedPostUseCase(this.postRepo);
  @override
  Future<Either<Failure, PostDetailResponse>> call(String params) =>
      postRepo.getThreadedPost(params);
}
