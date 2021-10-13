import '../../../../core/common/failure.dart';
import '../../data/models/request/notification_or_mention_request_model.dart';
import '../entity/notification_entity.dart';
import 'package:dartz/dartz.dart';

abstract class NotificationRepo {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications(
      NotificationOrMentionRequestModel model);
  Future<Either<Failure, dynamic>> deleteNotification(List<int> index);
}
