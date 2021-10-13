import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../post_repo.dart';

@injectable
class DeletePostUseCase extends UseCase<dynamic, String> {
  final PostRepo postRepo;

  DeletePostUseCase(this.postRepo);
  @override
  Future<Either<Failure, dynamic>> call(String params) =>
      postRepo.deletePost(params);
}
