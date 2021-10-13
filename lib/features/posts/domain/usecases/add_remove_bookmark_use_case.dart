import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddOrRemoveBookmarkUseCase extends UseCase<dynamic, String> {
  final PostRepo postRepo;

  AddOrRemoveBookmarkUseCase(this.postRepo);
  @override
  Future<Either<Failure, dynamic>> call(String params) =>
      postRepo.addOrRemoveBookMark(params);
}
