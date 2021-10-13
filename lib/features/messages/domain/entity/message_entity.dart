import 'package:flutter/foundation.dart';

import '../../data/models/response/messages_response.dart';
import '../../../../extensions.dart';

class MessageEntity {
  final String fullName;
  final String userId;
  final String message;
  final String time;
  final String userName;
  final String profileUrl;
  final bool isVerified;

  MessageEntity._(
      {@required this.fullName,
      @required this.userId,
      @required this.message,
      @required this.time,
      @required this.userName,
      @required this.profileUrl,
      @required this.isVerified});
  factory MessageEntity.fromResponse(MessageResponseModel model) {
    return MessageEntity._(
        fullName: model.name,
        userId: model.userId.toString(),
        message: model.lastMessage.isEmpty ? "No Messages" : model.lastMessage,
        time: model.time,
        userName: model.username,
        profileUrl: model.avatar,
        isVerified: model.verified.isVerifiedUser);
  }
  MessageEntity copyWith({String message, String time}) {
    return MessageEntity._(
        fullName: fullName,
        userId: userId,
        message: message.isEmpty ? "No Messages" : message,
        time: time,
        userName: userName,
        profileUrl: profileUrl,
        isVerified: isVerified);
  }
}
