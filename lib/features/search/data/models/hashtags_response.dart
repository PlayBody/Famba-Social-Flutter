// To parse this JSON data, do
//
//     final hashtagResponse = hashtagResponseFromJson(jsonString);

import 'dart:convert';

HashtagResponse hashtagResponseFromJson(String str) => HashtagResponse.fromJson(json.decode(str));

String hashtagResponseToJson(HashtagResponse data) => json.encode(data.toJson());

class HashtagResponse {
  HashtagResponse({
    this.valid,
    this.code,
    this.message,
    this.data,
  });

  bool valid;
  int code;
  String message;
  List<HashTag> data;

  factory HashtagResponse.fromJson(Map<String, dynamic> json) => HashtagResponse(
    valid: json["valid"] == null ? null : json["valid"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<HashTag>.from(json["data"].map((x) => HashTag.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "valid": valid == null ? null : valid,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class HashTag {
  HashTag({
    this.id,
    this.posts,
    this.tag,
    this.time,
    this.hashtag,
    this.url,
    this.total,
  });

  int id;
  int posts;
  String tag;
  String time;
  String hashtag;
  String url;
  String total;

  factory HashTag.fromJson(Map<String, dynamic> json) => HashTag(
    id: json["id"] == null ? null : json["id"],
    posts: json["posts"] == null ? null : json["posts"],
    tag: json["tag"] == null ? null : json["tag"],
    time: json["time"] == null ? null : json["time"],
    hashtag: json["hashtag"] == null ? null : json["hashtag"],
    url: json["url"] == null ? null : json["url"],
    total: json["total"] == null ? null : json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "posts": posts == null ? null : posts,
    "tag": tag == null ? null : tag,
    "time": time == null ? null : time,
    "hashtag": hashtag == null ? null : hashtag,
    "url": url == null ? null : url,
    "total": total == null ? null : total,
  };
}
