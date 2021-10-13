import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../entity/report_profile_entity.dart';
import '../repo/profile_repo.dart';
import 'package:dartz/dartz.dart';

class ReportProfileUseCase implements UseCase<dynamic, ReportProfileEntity> {
  final ProfileRepo profileRepo;
  const ReportProfileUseCase(this.profileRepo);
  @override
  Future<Either<Failure, dynamic>> call(ReportProfileEntity params) async =>
      await profileRepo.reportProfile(params);
}
