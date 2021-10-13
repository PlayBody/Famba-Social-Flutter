import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../../profile/data/models/request/profile_posts_model.dart';
import '../../../profile/domain/entity/follower_entity.dart';
import '../../../profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetFollowersUseCase
    extends UseCase<List<FollowerEntity>, PostCategoryModel> {
  final ProfileRepo profileRepo;

  GetFollowersUseCase(this.profileRepo);
  @override
  Future<Either<Failure, List<FollowerEntity>>> call(
          PostCategoryModel params) =>
      profileRepo.getFollower(params);
}
