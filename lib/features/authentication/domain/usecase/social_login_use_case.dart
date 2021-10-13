import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../repo/auth_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SocialLoginUseCase extends UseCase<String, SocialLogin> {
  final AuthRepo authRepo;
  SocialLoginUseCase(this.authRepo);
  @override
  Future<Either<Failure, String>> call(SocialLogin params) {
    if (params == SocialLogin.FB)
      return authRepo.fbLogin();
    else
      return authRepo.googleLogin();
  }
}

enum SocialLogin { TWITTER, FB, GOOGLE }
