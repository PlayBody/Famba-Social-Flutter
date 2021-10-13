import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../repo/notification_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteNotificationUseCase extends UseCase<dynamic, List<int>> {
  final NotificationRepo notificationRepo;

  DeleteNotificationUseCase(this.notificationRepo);
  @override
  Future<Either<Failure, dynamic>> call(List<int> params) {
    return notificationRepo.deleteNotification(params);
  }
}
