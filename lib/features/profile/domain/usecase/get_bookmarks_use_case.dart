import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../../feed/domain/entity/post_entity.dart';
import '../repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBookmarksUseCase extends UseCase<List<PostEntity>, String> {
  final ProfileRepo profileRepo;

  GetBookmarksUseCase(this.profileRepo);
  @override
  Future<Either<Failure, List<PostEntity>>> call(String params) =>
      profileRepo.getBookmarks(params);
}
