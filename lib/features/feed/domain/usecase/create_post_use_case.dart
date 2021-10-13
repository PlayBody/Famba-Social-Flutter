import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../data/models/request/post_request_model.dart';
import '../../../posts/domain/post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreatePostUseCase extends UseCase<dynamic, PostRequestModel> {
  final PostRepo postRepo;

  CreatePostUseCase(this.postRepo);
  @override
  Future<Either<Failure, dynamic>> call(PostRequestModel params) {
    return postRepo.createPost(params);
  }
}
