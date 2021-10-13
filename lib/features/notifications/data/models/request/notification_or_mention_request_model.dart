import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

class NotificationOrMentionRequestModel {
  final NotificationOrMentionEnum notificationOrMentionEnum;
  final String offsetId;

  NotificationOrMentionRequestModel(
      {@required this.notificationOrMentionEnum, @required this.offsetId});

  HashMap<String, String> get toMap => HashMap.from({
        "type":
            notificationOrMentionEnum == NotificationOrMentionEnum.NOTIFICATIONS
                ? "notifs"
                : "mentions",
        "offset": offsetId,
      });
}

enum NotificationOrMentionEnum { NOTIFICATIONS, MENTIONS }
