// To parse this JSON data, do
//
//     final profilePostResponse = profilePostResponseFromJson(jsonString);

import 'dart:convert';

import 'package:colibri/features/feed/data/models/feeds_response.dart';
import 'package:colibri/features/posts/data/model/response/post_detail_response.dart';
import 'package:colibri/features/posts/data/model/response/ad_response.dart';

ProfilePostResponse profilePostResponseFromJson(String str) => ProfilePostResponse.fromJson(json.decode(str));

String profilePostResponseToJson(ProfilePostResponse data) => json.encode(data.toJson());

class ProfilePostResponse {
  ProfilePostResponse({
    this.code,
    this.message,
    this.data,
  });

  int code;
  String message;
  ProfilePostItem data;

  factory ProfilePostResponse.fromJson(Map<String, dynamic> json) => ProfilePostResponse(
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : ProfilePostItem.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class ProfilePostItem {
  ProfilePostItem({
    this.posts,
  });

  List<ProfilePost> posts;

  factory ProfilePostItem.fromJson(Map<String, dynamic> json) => ProfilePostItem(
    posts: json["posts"] == null ? null : List<ProfilePost>.from(json["posts"].map((x) => ProfilePost.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "posts": posts == null ? null : List<dynamic>.from(posts.map((x) => x.toJson())),
  };
}

class ProfilePost {
  ProfilePost({
    this.id,
    this.userId,
    this.text,
    this.type,
    this.replysCount,
    this.repostsCount,
    this.likesCount,
    this.status,
    this.threadId,
    this.target,
    this.ogData,
    this.time,
    this.offsetId,
    this.isRepost,
    this.isReposter,
    this.attrs,
    this.advertising,
    this.timeRaw,
    this.ogText,
    this.ogImage,
    this.url,
    this.canDelete,
    this.media,
    this.isOwner,
    this.hasLiked,
    this.hasSaved,
    this.hasReposted,
    this.replyTo,
    this.owner,
    this.gif,
    this.reposter,
    this.cover,
    this.company,
    this.targetUrl,
    this.views,
    this.description,
    this.cta,
    this.avatar,
    this.username,
    this.verified,
    this.name,
    this.isConversed,
    this.showStats,
    this.domain,
    this.advertisementResponse
  });

  int id;
  int userId;
  String text;
  String type;
  String replysCount;
  String repostsCount;
  String likesCount;
  String status;
  int threadId;
  String target;
  var ogData;
  // OgDataClass1 ogData;
  String time;
  int offsetId;
  bool isRepost;
  bool isReposter;
  String attrs;
  bool advertising;
  String timeRaw;
  String ogText;
  String ogImage;
  String url;
  bool canDelete;
  List<ProfilePostMedia> media;
  bool isOwner;
  bool hasLiked;
  bool hasSaved;
  bool hasReposted;
  ReplyTo replyTo;
  Owner owner;
  dynamic gif;
  Reposter reposter;
  String cover;
  String company;
  String targetUrl;
  int views;
  String description;
  String cta;
  String avatar;
  String username;
  String verified;
  String name;
  bool isConversed;
  bool showStats;
  String domain;
  AdvertisementResponse advertisementResponse;
  factory ProfilePost.fromJson(Map<String, dynamic> json) => ProfilePost(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    text: json["text"] == null ? null : json["text"],
    type: json["type"] == null ? null : json["type"],
    replysCount: json["replys_count"] == null ? null : json["replys_count"],
    repostsCount: json["reposts_count"] == null ? null : json["reposts_count"],
    likesCount: json["likes_count"] == null ? null : json["likes_count"],
    status: json["status"] == null ? null : json["status"],
    threadId: json["thread_id"] == null ? null : json["thread_id"],
    target: json["target"] == null ? null : json["target"],
    ogData: json["og_data"] == null && json["og_data"] == "" ? null : json["og_data"],
    time: json["time"] == null ? null : json["time"],
    offsetId: json["offset_id"] == null ? null : json["offset_id"],
    isRepost: json["is_repost"] == null ? null : json["is_repost"],
    isReposter: json["is_reposter"] == null ? null : json["is_reposter"],
    attrs: json["attrs"] == null ? null : json["attrs"],
    advertising: json["advertising"] == null ? null : json["advertising"],
    timeRaw: json["time_raw"] == null ? null : json["time_raw"],
    ogText: json["og_text"] == null ? null : json["og_text"],
    ogImage: json["og_image"] == null ? null : json["og_image"],
    url: json["url"] == null ? null : json["url"],
    canDelete: json["can_delete"] == null ? null : json["can_delete"],
    advertisementResponse:json["advertising"] != null&&json["advertising"]?AdvertisementResponse.fromJson(json):null,
    media: json["media"] == null ? null : List<ProfilePostMedia>.from(json["media"].map((x) => ProfilePostMedia.fromJson(x))),
    isOwner: json["is_owner"] == null ? null : json["is_owner"],
    hasLiked: json["has_liked"] == null ? null : json["has_liked"],
    hasSaved: json["has_saved"] == null ? null : json["has_saved"],
    hasReposted: json["has_reposted"] == null ? null : json["has_reposted"],
    replyTo: json["reply_to"] == null || json["reply_to"].isEmpty? null : ReplyTo.fromJson(json["reply_to"]),
    owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
    gif: json["gif"],
    reposter: json["reposter"] == null ? null : Reposter.fromJson(json["reposter"]),
    cover: json["cover"] == null ? null : json["cover"],
    company: json["company"] == null ? null : json["company"],
    targetUrl: json["target_url"] == null ? null : json["target_url"],
    views: json["views"] == null ? null : json["views"],
    description: json["description"] == null ? null : json["description"],
    cta: json["cta"] == null ? null : json["cta"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    username: json["username"] == null ? null : json["username"],
    verified: json["verified"] == null ? null : json["verified"],
    name: json["name"] == null ? null : json["name"],
    isConversed: json["is_conversed"] == null ? null : json["is_conversed"],
    showStats: json["show_stats"] == null ? null : json["show_stats"],
    domain: json["domain"] == null ? null : json["domain"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "text": text == null ? null : text,
    "type": type == null ? null : type,
    "replys_count": replysCount == null ? null : replysCount,
    "reposts_count": repostsCount == null ? null : repostsCount,
    "likes_count": likesCount == null ? null : likesCount,
    "status": status == null ? null : status,
    "thread_id": threadId == null ? null : threadId,
    "target": target == null ? null : target,
    // "og_data": ogData,
    "og_data": ogData == null ? null : ogData,
    "time": time == null ? null : time,
    "offset_id": offsetId == null ? null : offsetId,
    "is_repost": isRepost == null ? null : isRepost,
    "is_reposter": isReposter == null ? null : isReposter,
    "attrs": attrs == null ? null : attrs,
    "advertising": advertising == null ? null : advertising,
    "time_raw": timeRaw == null ? null : timeRaw,
    "og_text": ogText == null ? null : ogText,
    "og_image": ogImage == null ? null : ogImage,
    "url": url == null ? null : url,
    "can_delete": canDelete == null ? null : canDelete,
    "media": media == null ? null : List<dynamic>.from(media.map((x) => x.toJson())),
    "is_owner": isOwner == null ? null : isOwner,
    "has_liked": hasLiked == null ? null : hasLiked,
    "has_saved": hasSaved == null ? null : hasSaved,
    "has_reposted": hasReposted == null ? null : hasReposted,
    "reply_to": replyTo == null ? null : replyTo.toJson(),
    "owner": owner == null ? null : owner.toJson(),
    "gif": gif,
    "reposter": reposter == null ? null : reposter.toJson(),
    "cover": cover == null ? null : cover,
    "company": company == null ? null : company,
    "target_url": targetUrl == null ? null : targetUrl,
    "views": views == null ? null : views,
    "description": description == null ? null : description,
    "cta": cta == null ? null : cta,
    "avatar": avatar == null ? null : avatar,
    "username": username == null ? null : username,
    "verified": verified == null ? null : verified,
    "name": name == null ? null : name,
    "is_conversed": isConversed == null ? null : isConversed,
    "show_stats": showStats == null ? null : showStats,
    "domain": domain == null ? null : domain,
  };
}

class ProfilePostMedia {
  ProfilePostMedia({
    this.id,
    this.pubId,
    this.type,
    this.src,
    this.jsonData,
    this.time,
    this.x,
  });

  int id;
  int pubId;
  String type;
  String src;
  String jsonData;
  String time;
  dynamic x;

  factory ProfilePostMedia.fromJson(Map<String, dynamic> json) => ProfilePostMedia(
    id: json["id"] == null ? null : json["id"],
    pubId: json["pub_id"] == null ? null : json["pub_id"],
    type: json["type"] == null ? null : json["type"],
    src: json["src"] == null ? null : json["src"],
    jsonData: json["json_data"] == null ? null : json["json_data"],
    time: json["time"] == null ? null : json["time"],
    x: json["x"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "pub_id": pubId == null ? null : pubId,
    "type": type == null ? null : type,
    "src": src == null ? null : src,
    "json_data": jsonData == null ? null : jsonData,
    "time": time == null ? null : time,
    "x": x,
  };
}

class XClass {
  XClass({
    this.posterThumb,
    this.imageThumb,
  });

  String posterThumb;
  String imageThumb;

  factory XClass.fromJson(Map<String, dynamic> json) => XClass(
    posterThumb: json["poster_thumb"] == null ? null : json["poster_thumb"],
    imageThumb: json["image_thumb"] == null ? null : json["image_thumb"],
  );

  Map<String, dynamic> toJson() => {
    "poster_thumb": posterThumb == null ? null : posterThumb,
    "image_thumb": imageThumb == null ? null : imageThumb,
  };
}

// class OgDataClass {
//   OgDataClass({
//     this.title,
//     this.description,
//     this.image,
//     this.url,
//   });
//
//   String title;
//   String description;
//   String image;
//   String url;
//
//   factory OgDataClass.fromJson(Map<String, dynamic> json) => OgDataClass(
//     title: json["title"] == null ? null : json["title"],
//     description: json["description"] == null ? null : json["description"],
//     image: json["image"] == null ? null : json["image"],
//     url: json["url"] == null ? null : json["url"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "title": title == null ? null : title,
//     "description": description == null ? null : description,
//     "image": image == null ? null : image,
//     "url": url == null ? null : url,
//   };
// }

class Owner {
  Owner({
    this.id,
    this.url,
    this.avatar,
    this.username,
    this.name,
    this.verified,
  });

  int id;
  String url;
  String avatar;
  String username;
  String name;
  String verified;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    id: json["id"] == null ? null : json["id"],
    url: json["url"] == null ? null : json["url"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    username: json["username"] == null ? null : json["username"],
    name: json["name"] == null ? null : json["name"],
    verified: json["verified"] == null ? null : json["verified"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "url": url == null ? null : url,
    "avatar": avatar == null ? null : avatar,
    "username": username == null ? null : username,
    "name": name == null ? null : name,
    "verified": verified == null ? null : verified,
  };
}

