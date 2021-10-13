import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../data/models/request/update_password_request.dart';
import '../repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdatePasswordUseCase extends UseCase<dynamic, UpdatePasswordRequest> {
  final ProfileRepo profileRepo;
  UpdatePasswordUseCase(this.profileRepo);
  @override
  Future<Either<Failure, dynamic>> call(params) {
    return profileRepo.updatePassword(params);
  }
}
