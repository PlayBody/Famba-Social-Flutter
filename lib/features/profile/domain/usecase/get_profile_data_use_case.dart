import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../entity/profile_entity.dart';
import '../repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetProfileUseCase extends UseCase<ProfileEntity, String> {
  final ProfileRepo profileRepo;

  GetProfileUseCase(this.profileRepo);
  @override
  Future<Either<Failure, ProfileEntity>> call(String params) =>
      profileRepo.getProfileData(params);
}
