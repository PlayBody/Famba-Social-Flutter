import 'dart:collection';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/common/api/api_constants.dart';
import '../../../../core/common/api/api_helper.dart';
import '../../../../core/common/failure.dart';
import '../../domain/entity/notification_entity.dart';
import '../../domain/repo/notification_repo.dart';
import '../models/request/notification_or_mention_request_model.dart';
import '../models/response/notification_response.dart';

@Injectable(as: NotificationRepo)
class NotificationRepoImpl extends NotificationRepo {
  final ApiHelper apiHelper;

  NotificationRepoImpl(this.apiHelper);
  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications(
      NotificationOrMentionRequestModel model) async {
    var map = model.toMap
      ..addAll({"page_size": ApiConstants.pageSize.toString()});
    var either = await apiHelper.get(ApiConstants.getNotifications,
        queryParameters: map);
    return either.fold((l) => left(l), (r) {
      var notificationModel = NotificationResponse.fromJson(r.data);
      return right(notificationModel.data
          .map((e) => NotificationEntity.fromResponse(model: e))
          .toList());
    });
  }

  @override
  Future<Either<Failure, dynamic>> deleteNotification(List<int> index) {
    return apiHelper.post(
      ApiConstants.deleteNotification,
      HashMap.from(
        {"scope": index},
      ),
    );
  }
}
