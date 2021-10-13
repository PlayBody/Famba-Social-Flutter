import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import '../../data/models/response/notification_response.dart';
import '../../../../extensions.dart';
import '../../../posts/presentation/pages/view_post_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';

class NotificationEntity {
  final String name;
  final String title;
  final String time;
  final String profileUrl;
  final String notificationId;
  final String offsetId;
  final NotificationType notificationType;
  final bool verifiedUser;

  /// below are the two types where use can navigate on tap of notification
  /// if the notification is type of post then we will open post detail screen [ViewPostScreen] using post id
  final String postId;

  /// if the notification is type of a specific to a user then we will open user profile[ProfileScreen] using user id
  final String userID;

  NotificationEntity._(
      {@required this.title,
      @required this.time,
      @required this.profileUrl,
      @required this.offsetId,
      @required this.name,
      @required this.verifiedUser,
      @required this.notificationType,
      @required this.notificationId,
      this.userID,
      this.postId});

  factory NotificationEntity.fromResponse({@required NotificationModel model}) {
    return NotificationEntity._(
        title: getTitleFromNotificationType(model.subject),
        time: model.time,
        profileUrl: model.avatar,
        notificationId: model.id.toString(),
        offsetId: model.id.toString(),
        name: model.name,
        notificationType: getNotificationType(model.subject),
        verifiedUser: model.verified.isVerifiedUser,
        postId: model.postId.toString(),
        userID: model.userId.toString());
  }

  static NotificationType getNotificationType(String subject) {
    if (subject == "subscribe")
      return NotificationType.SUBSCRIBED;
    else if (subject == "subscribe_accept")
      return NotificationType.SUBSCRIPTION_REQUEST_ACCEPTED;
    else if (subject == "reply")
      return NotificationType.POSTED_REPLY;
    else if (subject == "repost")
      return NotificationType.REPOSTED;
    else if (subject == "visit")
      return NotificationType.PROFILE_VISITED;
    else if (subject == "like")
      return NotificationType.LIKED;
    else if (subject == "subscribe_request")
      return NotificationType.SUBSCRIBE_REQUEST;
    else if (subject == "mention")
      return NotificationType.MENTIONED;
    else if (subject == "chat_message" || subject == "chat-message")
      return NotificationType.MESSAGE_RECEIVED;
    return NotificationType.UNDEFINED_YET;
  }

  static String getTitleFromNotificationType(String subject) {
    final notificationType = getNotificationType(subject);
    var title = '';
    switch (notificationType) {
      case NotificationType.SUBSCRIBED:
        title = "Started following you";
        break;
      case NotificationType.SUBSCRIPTION_REQUEST_ACCEPTED:
        title = "Accepted your follow request";
        break;
      case NotificationType.PROFILE_VISITED:
        title = "Visited your profile";
        break;
      case NotificationType.POSTED_REPLY:
        title = "Replied to your post";
        break;
      case NotificationType.REPOSTED:
        title = "Shared your publication";
        break;
      case NotificationType.LIKED:
        title = "Liked your post";
        break;
      case NotificationType.SUBSCRIBE_REQUEST:
        title = "Wants to follow you";
        break;
      case NotificationType.MENTIONED:
        title = "Mentioned you in a post";
        break;
      case NotificationType.UNDEFINED_YET:
        title = "Not defined yet";
        break;
      case NotificationType.MESSAGE_RECEIVED:
        title = "Sends you a message";
        break;
    }
    return title;
  }
}

enum NotificationType {
  SUBSCRIBED,
  SUBSCRIPTION_REQUEST_ACCEPTED,
  PROFILE_VISITED,
  POSTED_REPLY,
  // POST_CREATED,
  REPOSTED,
  LIKED,
  SUBSCRIBE_REQUEST,
  MENTIONED,
  UNDEFINED_YET,
  MESSAGE_RECEIVED
}

// New post created by the user I'm following
// New Follower
// Follow Request
// New Comment on post
// Like on post
// Like on comment
// Mentioned in a post
// Mentioned in a comment
// Reply on comment
// New Message
// Chat Message (when doing chat)
// Shared your post
