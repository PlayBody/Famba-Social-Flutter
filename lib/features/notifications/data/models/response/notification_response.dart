// To parse this JSON data, do
//
//     final notificationResponse = notificationResponseFromJson(jsonString);

import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) => NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) => json.encode(data.toJson());

class NotificationResponse {
  NotificationResponse({
    this.valid,
    this.code,
    this.message,
    this.data,
  });

  bool valid;
  int code;
  String message;
  List<NotificationModel> data;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
    valid: json["valid"] == null ? null : json["valid"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<NotificationModel>.from(json["data"].map((x) => NotificationModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "valid": valid == null ? null : valid,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NotificationModel {
  NotificationModel({
    this.id,
    this.notifierId,
    this.recipientId,
    this.status,
    this.subject,
    this.entryId,
    this.json,
    this.time,
    this.username,
    this.avatar,
    this.verified,
    this.name,
    this.url,
    this.userId,
    this.postId,
  });

  int id;
  int notifierId;
  int recipientId;
  String status;
  String subject;
  int entryId;
  String json;
  String time;
  String username;
  String avatar;
  String verified;
  String name;
  String url;
  int userId;
  int postId;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    id: json["id"] == null ? null : json["id"],
    notifierId: json["notifier_id"] == null ? null : json["notifier_id"],
    recipientId: json["recipient_id"] == null ? null : json["recipient_id"],
    status: json["status"] == null ? null : json["status"],
    subject: json["subject"] == null ? null : json["subject"],
    entryId: json["entry_id"] == null ? null : json["entry_id"],
    json: json["json"] == null ? null : json["json"],
    time: json["time"] == null ? null : json["time"],
    username: json["username"] == null ? null : json["username"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    verified: json["verified"] == null ? null : json["verified"],
    name: json["name"] == null ? null : json["name"],
    url: json["url"] == null ? null : json["url"],
    userId: json["user_id"] == null ? null : json["user_id"],
    postId: json["post_id"] == null ? null : json["post_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "notifier_id": notifierId == null ? null : notifierId,
    "recipient_id": recipientId == null ? null : recipientId,
    "status": status == null ? null : status,
    "subject": subject == null ? null : subject,
    "entry_id": entryId == null ? null : entryId,
    "json": json == null ? null : json,
    "time": time == null ? null : time,
    "username": username == null ? null : username,
    "avatar": avatar == null ? null : avatar,
    "verified": verified == null ? null : verified,
    "name": name == null ? null : name,
    "url": url == null ? null : url,
    "user_id": userId == null ? null : userId,
    "post_id": postId == null ? null : postId,
  };
}

