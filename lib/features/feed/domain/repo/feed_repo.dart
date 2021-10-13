import '../entity/report_post_entity.dart';

import '../../../../core/common/failure.dart';
import '../entity/post_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FeedRepo {
  Future<Either<Failure, List<PostEntity>>> getFeeds(String pageKey);
  Future<Either<Failure, List<PostEntity>>> saveNotificationToken();
  Future<Either<Failure, dynamic>> reportPost(ReportPostEntity param);
}
