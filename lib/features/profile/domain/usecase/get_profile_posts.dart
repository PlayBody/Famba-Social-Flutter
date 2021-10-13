import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../../feed/domain/entity/post_entity.dart';
import '../../data/models/request/profile_posts_model.dart';
import '../repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProfilePostsUseCase
    extends UseCase<List<PostEntity>, PostCategoryModel> {
  final ProfileRepo profileRepo;
  GetProfilePostsUseCase(this.profileRepo);

  @override
  Future<Either<Failure, List<PostEntity>>> call(PostCategoryModel params) {
    return profileRepo.getUserPostByCategory(params);
  }
}
