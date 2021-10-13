// To parse this JSON data, do
//
//     final advertisementlResponse = advertisementlResponseFromJson(jsonString);

import 'dart:convert';

import 'post_detail_response.dart';

AdvertisementResponse advertisementResponseFromJson(String str) => AdvertisementResponse.fromJson(json.decode(str));

String advertisementResponseToJson(AdvertisementResponse data) => json.encode(data.toJson());

class AdvertisementResponse {
  AdvertisementResponse({
    this.id,
    this.userId,
    this.cover,
    this.company,
    this.targetUrl,
    this.views,
    this.description,
    this.cta,
    this.time,
    this.avatar,
    this.username,
    this.verified,
    this.name,
    this.isConversed,
    this.advertising,
    this.showStats,
    this.isOwner,
    this.domain,
    this.owner,
  });

  int id;
  int userId;
  String cover;
  String company;
  String targetUrl;
  int views;
  String description;
  String cta;
  String time;
  String avatar;
  String username;
  String verified;
  String name;
  bool isConversed;
  bool advertising;
  bool showStats;
  bool isOwner;
  String domain;
  Owner owner;

  factory AdvertisementResponse.fromJson(Map<String, dynamic> json) => AdvertisementResponse(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    cover: json["cover"] == null ? null : json["cover"],
    company: json["company"] == null ? null : json["company"],
    targetUrl: json["target_url"] == null ? null : json["target_url"],
    views: json["views"] == null ? null : json["views"],
    description: json["description"] == null ? null : json["description"],
    cta: json["cta"] == null ? null : json["cta"],
    time: json["time"] == null ? null : json["time"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    username: json["username"] == null ? null : json["username"],
    verified: json["verified"] == null ? null : json["verified"],
    name: json["name"] == null ? null : json["name"],
    isConversed: json["is_conversed"] == null ? null : json["is_conversed"],
    advertising: json["advertising"] == null ? null : json["advertising"],
    showStats: json["show_stats"] == null ? null : json["show_stats"],
    isOwner: json["is_owner"] == null ? null : json["is_owner"],
    domain: json["domain"] == null ? null : json["domain"],
    owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "cover": cover == null ? null : cover,
    "company": company == null ? null : company,
    "target_url": targetUrl == null ? null : targetUrl,
    "views": views == null ? null : views,
    "description": description == null ? null : description,
    "cta": cta == null ? null : cta,
    "time": time == null ? null : time,
    "avatar": avatar == null ? null : avatar,
    "username": username == null ? null : username,
    "verified": verified == null ? null : verified,
    "name": name == null ? null : name,
    "is_conversed": isConversed == null ? null : isConversed,
    "advertising": advertising == null ? null : advertising,
    "show_stats": showStats == null ? null : showStats,
    "is_owner": isOwner == null ? null : isOwner,
    "domain": domain == null ? null : domain,
    "owner": owner == null ? null : owner.toJson(),
  };
}

