import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../../profile/domain/repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogOutUseCase extends UseCase<dynamic, Unit> {
  final ProfileRepo profileRepo;

  LogOutUseCase(this.profileRepo);
  @override
  Future<Either<Failure, dynamic>> call(Unit params) =>
      profileRepo.logOutUser();
}
