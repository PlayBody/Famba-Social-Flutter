import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../data/models/request/update_setting_request_model.dart';
import '../repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateUserSettingsUseCase
    implements UseCase<dynamic, UpdateSettingsRequestModel> {
  final ProfileRepo profileRepo;
  UpdateUserSettingsUseCase(this.profileRepo);

  @override
  Future<Either<Failure, dynamic>> call(UpdateSettingsRequestModel params) =>
      profileRepo.updateUserSetting(params);
}
