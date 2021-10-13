import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../entity/setting_entity.dart';
import '../repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdatePrivacyUseCase extends UseCase<dynamic, AccountPrivacyEntity> {
  final ProfileRepo profileRepo;

  UpdatePrivacyUseCase(this.profileRepo);
  @override
  Future<Either<Failure, dynamic>> call(AccountPrivacyEntity params) {
    return profileRepo.updatePrivacy(params);
  }
}
