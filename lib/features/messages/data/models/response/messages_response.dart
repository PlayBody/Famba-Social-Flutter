// To parse this JSON data, do
//
//     final messagesResponse = messagesResponseFromJson(jsonString);

import 'dart:convert';

MessagesResponse messagesResponseFromJson(String str) => MessagesResponse.fromJson(json.decode(str));

String messagesResponseToJson(MessagesResponse data) => json.encode(data.toJson());

class MessagesResponse {
  MessagesResponse({
    this.code,
    this.valid,
    this.message,
    this.data,
  });

  int code;
  bool valid;
  String message;
  List<MessageResponseModel> data;

  factory MessagesResponse.fromJson(Map<String, dynamic> json) => MessagesResponse(
    code: json["code"] == null ? null : json["code"],
    valid: json["valid"] == null ? null : json["valid"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<MessageResponseModel>.from(json["data"].map((x) => MessageResponseModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "valid": valid == null ? null : valid,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class MessageResponseModel {
  MessageResponseModel({
    this.userId,
    this.username,
    this.name,
    this.avatar,
    this.verified,
    this.chatId,
    this.time,
    this.lastMessage,
    this.newMessages,
    this.chatUrl,
  });

  int userId;
  String username;
  String name;
  String avatar;
  String verified;
  int chatId;
  String time;
  String lastMessage;
  String newMessages;
  String chatUrl;

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) => MessageResponseModel(
    userId: json["user_id"] == null ? null : json["user_id"],
    username: json["username"] == null ? null : json["username"],
    name: json["name"] == null ? null : json["name"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    verified: json["verified"] == null ? null : json["verified"],
    chatId: json["chat_id"] == null ? null : json["chat_id"],
    time: json["time"] == null ? null : json["time"],
    lastMessage: json["last_message"] == null ? null : json["last_message"],
    newMessages: json["new_messages"] == null ? null : json["new_messages"].toString(),
    chatUrl: json["chat_url"] == null ? null : json["chat_url"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId == null ? null : userId,
    "username": username == null ? null : username,
    "name": name == null ? null : name,
    "avatar": avatar == null ? null : avatar,
    "verified": verified == null ? null : verified,
    "chat_id": chatId == null ? null : chatId,
    "time": time == null ? null : time,
    "last_message": lastMessage == null ? null : lastMessage,
    "new_messages": newMessages == null ? null : newMessages,
    "chat_url": chatUrl == null ? null : chatUrl,
  };
}
