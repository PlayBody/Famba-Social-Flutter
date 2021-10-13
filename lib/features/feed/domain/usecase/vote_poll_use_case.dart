import 'package:flutter/foundation.dart';

import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../../posts/domain/post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreatePostUseCase extends UseCase<dynamic, PollParam> {
  final PostRepo postRepo;

  CreatePostUseCase(this.postRepo);
  @override
  Future<Either<Failure, dynamic>> call(PollParam params) {
    return postRepo.votePoll(params);
  }
}

class PollParam {
  final int postId;
  final int pollId;

  PollParam({
    @required this.postId,
    @required this.pollId,
  });
}
