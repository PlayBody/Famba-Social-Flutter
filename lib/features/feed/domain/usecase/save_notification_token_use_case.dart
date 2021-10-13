import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../repo/feed_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveNotificationPushUseCase extends UseCase<dynamic, Unit> {
  final FeedRepo feedRepo;

  SaveNotificationPushUseCase(this.feedRepo);
  @override
  Future<Either<Failure, dynamic>> call(Unit params) {
    return feedRepo.saveNotificationToken();
  }
}
