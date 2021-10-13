// To parse this JSON data, do
//
//     final chatNotificationResponse = chatNotificationResponseFromJson(jsonString);

import 'dart:convert';

ChatNotificationResponse chatNotificationResponseFromJson(String str) => ChatNotificationResponse.fromJson(json.decode(str));

String chatNotificationResponseToJson(ChatNotificationResponse data) => json.encode(data.toJson());

class ChatNotificationResponse {
  ChatNotificationResponse({
    this.data,
  });

  Data data;

  factory ChatNotificationResponse.fromJson(Map<String, dynamic> json) => ChatNotificationResponse(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    this.chatMessage,
  });

  ChatMessage chatMessage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    chatMessage: json["chat_message"] == null ? null : ChatMessage.fromJson(json["chat_message"]),
  );

  Map<String, dynamic> toJson() => {
    "chat_message": chatMessage == null ? null : chatMessage.toJson(),
  };
}

class ChatMessage {
  ChatMessage({
    this.messageType,
    this.data,
    this.messageId,
    this.avatar,
    this.userId,
    this.name,
  });

  String messageType;
  String data;
  int messageId;
  String avatar;
  int userId;
  String name;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    messageType: json["message_type"] == null ? null : json["message_type"],
    data: json["data"] == null ? null : json["data"],
    messageId: json["message_id"] == null ? null : json["message_id"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    userId: json["user_id"] == null ? null : json["user_id"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "message_type": messageType == null ? null : messageType,
    "data": data == null ? null : data,
    "message_id": messageId == null ? null : messageId,
    "avatar": avatar == null ? null : avatar,
    "user_id": userId == null ? null : userId,
    "name": name == null ? null : name,
  };
}
