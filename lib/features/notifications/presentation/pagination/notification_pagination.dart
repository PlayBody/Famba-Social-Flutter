import '../../../../core/common/failure.dart';
import '../../../../core/common/pagination/custom_pagination.dart';
import '../../data/models/request/notification_or_mention_request_model.dart';
import '../../domain/entity/notification_entity.dart';
import '../../domain/usecase/delete_notification_use_case.dart';
import '../../domain/usecase/get_notification_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class NotificationPagination extends CustomPagination<NotificationEntity> {
  final GetNotificationUseCase getNotificationUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;

  final _deletedItemsController = BehaviorSubject<Set<int>>.seeded(Set());

  addDeletedItem(int index) {
    _deletedItemsController.sink.add(_deletedItemsController.value..add(index));
  }

  deleteSelectedItem(int index) {
    _deletedItemsController.sink
        .add(_deletedItemsController.value..remove(index));
  }

  Stream<Set<int>> get deletedItems =>
      _deletedItemsController.stream.asBroadcastStream();

  NotificationPagination(
      this.getNotificationUseCase, this.deleteNotificationUseCase);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getItems(
      int pageKey) async {
    var result = await getNotificationUseCase(
      NotificationOrMentionRequestModel(
        notificationOrMentionEnum: NotificationOrMentionEnum.NOTIFICATIONS,
        offsetId: pageKey.toString(),
      ),
    );
    return result;
  }

  @override
  NotificationEntity getLastItemWithoutAd(List<NotificationEntity> item) =>
      item.last;

  @override
  int getNextKey(NotificationEntity item) => int.tryParse(item.offsetId);

  @override
  bool isLastPage(List<NotificationEntity> item) => commonLastPage(item);

  @override
  onClose() {
    super.onClose();
    _deletedItemsController.close();
    pagingController.dispose();
  }

  // TODO Notification id is not available
  Future<void> deleteNotification() async {
    List<int> _notificationId = [];
    _deletedItemsController.value.forEach((element) {
      _notificationId
          .add(int.tryParse(pagingController.itemList[element].notificationId));
    });
    _deletedItemsController.sink.add(Set());
    var either = await deleteNotificationUseCase(_notificationId);
    either.fold(
      (l) {
        print('L: ${l.errorMessage}');
        return null;
      },
      (r) {
        print('R: $r');
        return onRefresh();
      },
    );
  }
}
