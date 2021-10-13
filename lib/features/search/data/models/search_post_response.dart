// To parse this JSON data, do
//
//     final searcPostsResponse = searcPostsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:colibri/features/feed/data/models/feeds_response.dart';

SearcPostsResponse searcPostsResponseFromJson(String str) => SearcPostsResponse.fromJson(json.decode(str));

String searcPostsResponseToJson(SearcPostsResponse data) => json.encode(data.toJson());

class SearcPostsResponse {
  SearcPostsResponse({
    this.valid,
    this.code,
    this.message,
    this.data,
  });

  bool valid;
  int code;
  String message;
  List<Feed> data;

  factory SearcPostsResponse.fromJson(Map<String, dynamic> json) => SearcPostsResponse(
    valid: json["valid"] == null ? null : json["valid"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Feed>.from(json["data"].map((x) => Feed.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "valid": valid == null ? null : valid,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : List<Feed>.from(data.map((x) => x.toJson())),
  };
}


