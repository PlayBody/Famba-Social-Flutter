import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileCoverUseCase extends UseCase<String, String> {
  final ProfileRepo profileRepo;

  UpdateProfileCoverUseCase(this.profileRepo);
  @override
  Future<Either<Failure, String>> call(String params) {
    return profileRepo.updateCover(params);
  }
}
