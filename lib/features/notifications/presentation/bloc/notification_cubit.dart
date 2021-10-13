import 'package:bloc/bloc.dart';
import '../../../../translations/locale_keys.g.dart';
import '../pagination/mentions_pagination.dart';
import '../pagination/notification_pagination.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'package:easy_localization/easy_localization.dart';
part 'notification_state.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final GlobalKey<AnimatedListState> animatedListState =
      GlobalKey<AnimatedListState>();
  final items = List<String>.generate(
    10,
    (i) => "${i + 1} ${LocaleKeys.hours.tr()} ${LocaleKeys.ago.tr()}",
  );
  final removedItemsIndex = <int>[];
  // pagination
  final NotificationPagination notificationPagination;
  final MentionsPagination mentionsPagination;

  NotificationCubit(this.notificationPagination, this.mentionsPagination)
      : super(NotificationInitial());

  removeItem() {
    var newList = <String>[];
    items.forEach((element) {
      if (!removedItemsIndex.contains(element)) newList.add(element);
    });
  }

  addItemForDelete(int position) {
    removedItemsIndex.add(position);
  }

  removeItemForDelete(int position) {
    removedItemsIndex.remove(position);
  }

  @override
  Future<void> close() {
    notificationPagination.onClose();
    mentionsPagination.onClose();
    return super.close();
  }
}
