// To parse this JSON data, do
//
//     final privacyResponse = privacyResponseFromJson(jsonString);

import 'dart:convert';

PrivacyResponse privacyResponseFromJson(String str) => PrivacyResponse.fromJson(json.decode(str));

String privacyResponseToJson(PrivacyResponse data) => json.encode(data.toJson());

class PrivacyResponse {
  PrivacyResponse({
    this.code,
    this.valid,
    this.message,
    this.data,
  });

  int code;
  bool valid;
  String message;
  PrivacyModel data;

  factory PrivacyResponse.fromJson(Map<String, dynamic> json) => PrivacyResponse(
    code: json["code"] == null ? null : json["code"],
    valid: json["valid"] == null ? null : json["valid"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : PrivacyModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "valid": valid == null ? null : valid,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class PrivacyModel {
  PrivacyModel({
    this.profileVisibility,
    this.contactPrivacy,
    this.searchVisibility,
  });

  String profileVisibility;
  String contactPrivacy;
  bool searchVisibility;

  factory PrivacyModel.fromJson(Map<String, dynamic> json) => PrivacyModel(
    profileVisibility: json["profile_visibility"] == null ? null : json["profile_visibility"],
    contactPrivacy: json["contact_privacy"] == null ? null : json["contact_privacy"],
    searchVisibility: json["search_visibility"] == null ? null : json["search_visibility"],
  );

  Map<String, dynamic> toJson() => {
    "profile_visibility": profileVisibility == null ? null : profileVisibility,
    "contact_privacy": contactPrivacy == null ? null : contactPrivacy,
    "search_visibility": searchVisibility == null ? null : searchVisibility,
  };
}
