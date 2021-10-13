// To parse this JSON data, do
//
//     final sendMessageResponse = sendMessageResponseFromJson(jsonString);

import 'dart:convert';

SendMessageResponse sendMessageResponseFromJson(String str) => SendMessageResponse.fromJson(json.decode(str));

String sendMessageResponseToJson(SendMessageResponse data) => json.encode(data.toJson());

class SendMessageResponse {
  SendMessageResponse({
    this.valid,
    this.code,
    this.message,
    this.data,
  });

  bool valid;
  int code;
  String message;
  Data data;

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) => SendMessageResponse(
    valid: json["valid"] == null ? null : json["valid"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "valid": valid == null ? null : valid,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
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
    this.mediaName,
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
  String mediaName;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    mediaName: json["media_name"] == null ? null : json["media_name"],
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
    "media_name": mediaName == null ? null : mediaName,
  };
}
