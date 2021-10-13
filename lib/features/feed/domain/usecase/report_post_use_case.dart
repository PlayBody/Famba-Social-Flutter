import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../entity/report_post_entity.dart';
import '../repo/feed_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReportPostUseCase implements UseCase<dynamic, ReportPostEntity> {
  final FeedRepo feedRepo;
  const ReportPostUseCase(this.feedRepo);

  @override
  Future<Either<Failure, dynamic>> call(ReportPostEntity params) async =>
      await feedRepo.reportPost(params);
}
