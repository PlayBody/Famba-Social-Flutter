import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../../profile/domain/entity/profile_entity.dart';
import '../../../profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetDrawerDataUseCase extends UseCase<ProfileEntity, Unit> {
  final ProfileRepo profileRepo;
  GetDrawerDataUseCase(this.profileRepo);
  @override
  Future<Either<Failure, ProfileEntity>> call(Unit params) async {
    return await profileRepo.getProfileData(null);
  }
}
