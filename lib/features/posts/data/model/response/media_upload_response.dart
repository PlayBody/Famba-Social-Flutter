// To parse this JSON data, do
//
//     final mediaUploadResponse = mediaUploadResponseFromJson(jsonString);

import 'dart:convert';

MediaUploadResponse mediaUploadResponseFromJson(String str) => MediaUploadResponse.fromJson(json.decode(str));

String mediaUploadResponseToJson(MediaUploadResponse data) => json.encode(data.toJson());

class MediaUploadResponse {
  MediaUploadResponse({
    this.errCode,
    this.message,
    this.code,
    this.data,
  });

  int errCode;
  String message;
  int code;
  MediaItem data;

  factory MediaUploadResponse.fromJson(Map<String, dynamic> json) => MediaUploadResponse(
    errCode: json["err_code"] == null ? null : json["err_code"],
    message: json["message"] == null ? null : json["message"],
    code: json["code"] == null ? null : json["code"],
    data: json["data"] == null ? null : MediaItem.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "err_code": errCode == null ? null : errCode,
    "message": message == null ? null : message,
    "code": code == null ? null : code,
    "data": data == null ? null : data.toJson(),
  };
}

class MediaItem {
  MediaItem({
    this.mediaId,
    this.url,
    this.type,
  });

  int mediaId;
  String url;
  String type;

  factory MediaItem.fromJson(Map<String, dynamic> json) => MediaItem(
    mediaId: json["media_id"] == null ? null : json["media_id"],
    url: json["url"] == null ? null : json["url"],
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "media_id": mediaId == null ? null : mediaId,
    "url": url == null ? null : url,
    "type": type == null ? null : type,
  };
}
