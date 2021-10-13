// To parse this JSON data, do
//
//     final chatsResponse = chatsResponseFromJson(jsonString);

import 'dart:convert';

ChatsResponse chatsResponseFromJson(String str) => ChatsResponse.fromJson(json.decode(str));

String chatsResponseToJson(ChatsResponse data) => json.encode(data.toJson());

class ChatsResponse {
  ChatsResponse({
    this.valid,
    this.code,
    this.data,
  });

  bool valid;
  int code;
  List<ChatResponseModel> data;

  factory ChatsResponse.fromJson(Map<String, dynamic> json) => ChatsResponse(
    valid: json["valid"] == null ? null : json["valid"],
    code: json["code"] == null ? null : json["code"],
    data: json["data"] == null ? null : List<ChatResponseModel>.from(json["data"].map((x) => ChatResponseModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "valid": valid == null ? null : valid,
    "code": code == null ? null : code,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ChatResponseModel {
  ChatResponseModel({
    this.id,
    this.sentBy,

    this.sentTo,
    this.owner,
    this.message,
    this.mediaFile,
    this.mediaType,
    this.seen,
    this.deletedFs1,
    this.deletedFs2,
    this.time,
    this.side,
  });

  int id;
  int sentBy;
  int sentTo;
  bool owner;
  String message;
  String mediaFile;
  String mediaType;
  String seen;
  String deletedFs1;
  String deletedFs2;
  String time;
  String side;

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) => ChatResponseModel(
    id: json["id"] == null ? null : json["id"],
    sentBy: json["sent_by"] == null ? null : json["sent_by"],
    sentTo: json["sent_to"] == null ? null : json["sent_to"],
    owner: json["owner"] == null ? null : json["owner"],
    message: json["message"] == null ? null : json["message"],
    mediaFile: json["media_file"] == null ? null : json["media_file"],
    mediaType: json["media_type"] == null ? null : json["media_type"],
    seen: json["seen"] == null ? null : json["seen"],
    deletedFs1: json["deleted_fs1"] == null ? null : json["deleted_fs1"],
    deletedFs2: json["deleted_fs2"] == null ? null : json["deleted_fs2"],
    time: json["time"] == null ? null : json["time"],
    side: json["side"] == null ? null : json["side"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "sent_by": sentBy == null ? null : sentBy,
    "sent_to": sentTo == null ? null : sentTo,
    "owner": owner == null ? null : owner,
    "message": message == null ? null : message,
    "media_file": mediaFile == null ? null : mediaFile,
    "media_type": mediaType == null ? null : mediaType,
    "seen": seen == null ? null : seen,
    "deleted_fs1": deletedFs1 == null ? null : deletedFs1,
    "deleted_fs2": deletedFs2 == null ? null : deletedFs2,
    "time": time == null ? null : time,
    "side": side == null ? null : side,
  };
}
