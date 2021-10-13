import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../data/models/request/profile_posts_model.dart';
import '../entity/follower_entity.dart';
import '../repo/profile_repo.dart';
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
