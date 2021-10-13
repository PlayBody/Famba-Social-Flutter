import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../repo/profile_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChangeLanguageUseCase extends UseCase<String, String> {
  final ProfileRepo profileRepo;
  ChangeLanguageUseCase(this.profileRepo);
  @override
  Future<Either<Failure, String>> call(String params) =>
      profileRepo.changeLanguage(params);
}
