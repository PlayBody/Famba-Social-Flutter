// To parse this JSON data, do
//
//     final bookmarksResponse = bookmarksResponseFromJson(jsonString);

import 'dart:convert';

import 'package:colibri/features/feed/data/models/feeds_response.dart';

BookmarksResponse bookmarksResponseFromJson(String str) => BookmarksResponse.fromJson(json.decode(str));

String bookmarksResponseToJson(BookmarksResponse data) => json.encode(data.toJson());

class BookmarksResponse {
  BookmarksResponse({
    this.errCode,
    this.valid,
    this.code,
    this.message,
    this.data,
  });

  int errCode;
  bool valid;
  int code;
  String message;
  List<Feed> data;

  factory BookmarksResponse.fromJson(Map<String, dynamic> json) => BookmarksResponse(
    errCode: json["err_code"] == null ? null : json["err_code"],
    valid: json["valid"] == null ? null : json["valid"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Feed>.from(json["data"].map((x) => Feed.   fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "err_code": errCode == null ? null : errCode,
    "valid": valid == null ? null : valid,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
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
    this.pollData,
    this.privWcs,
    this.privWcr,
    this.time,
    this.offsetId,
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
    this.isBlocked,
    this.meBlocked,
    this.canSee,
    this.replyTo,
    this.owner,
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
  dynamic ogData;
  String pollData;
  String privWcs;
  String privWcr;
  String time;
  int offsetId;
  bool advertising;
  String timeRaw;
  String ogText;
  String ogImage;
  String url;
  bool canDelete;
  List<dynamic> media;
  bool isOwner;
  bool hasLiked;
  bool hasSaved;
  bool hasReposted;
  bool isBlocked;
  bool meBlocked;
  bool canSee;
  List<dynamic> replyTo;
  Owner owner;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    ogData: json["og_data"],
    pollData: json["poll_data"] == null ? null : json["poll_data"],
    privWcs: json["priv_wcs"] == null ? null : json["priv_wcs"],
    privWcr: json["priv_wcr"] == null ? null : json["priv_wcr"],
    time: json["time"] == null ? null : json["time"],
    offsetId: json["offset_id"] == null ? null : json["offset_id"],
    advertising: json["advertising"] == null ? null : json["advertising"],
    timeRaw: json["time_raw"] == null ? null : json["time_raw"],
    ogText: json["og_text"] == null ? null : json["og_text"],
    ogImage: json["og_image"] == null ? null : json["og_image"],
    url: json["url"] == null ? null : json["url"],
    canDelete: json["can_delete"] == null ? null : json["can_delete"],
    media: json["media"] == null ? null : List<dynamic>.from(json["media"].map((x) => x)),
    isOwner: json["is_owner"] == null ? null : json["is_owner"],
    hasLiked: json["has_liked"] == null ? null : json["has_liked"],
    hasSaved: json["has_saved"] == null ? null : json["has_saved"],
    hasReposted: json["has_reposted"] == null ? null : json["has_reposted"],
    isBlocked: json["is_blocked"] == null ? null : json["is_blocked"],
    meBlocked: json["me_blocked"] == null ? null : json["me_blocked"],
    canSee: json["can_see"] == null ? null : json["can_see"],
    replyTo: json["reply_to"] == null ? null : List<dynamic>.from(json["reply_to"].map((x) => x)),
    owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
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
    "og_data": ogData,
    "poll_data": pollData == null ? null : pollData,
    "priv_wcs": privWcs == null ? null : privWcs,
    "priv_wcr": privWcr == null ? null : privWcr,
    "time": time == null ? null : time,
    "offset_id": offsetId == null ? null : offsetId,
    "advertising": advertising == null ? null : advertising,
    "time_raw": timeRaw == null ? null : timeRaw,
    "og_text": ogText == null ? null : ogText,
    "og_image": ogImage == null ? null : ogImage,
    "url": url == null ? null : url,
    "can_delete": canDelete == null ? null : canDelete,
    "media": media == null ? null : List<dynamic>.from(media.map((x) => x)),
    "is_owner": isOwner == null ? null : isOwner,
    "has_liked": hasLiked == null ? null : hasLiked,
    "has_saved": hasSaved == null ? null : hasSaved,
    "has_reposted": hasReposted == null ? null : hasReposted,
    "is_blocked": isBlocked == null ? null : isBlocked,
    "me_blocked": meBlocked == null ? null : meBlocked,
    "can_see": canSee == null ? null : canSee,
    "reply_to": replyTo == null ? null : List<dynamic>.from(replyTo.map((x) => x)),
    "owner": owner == null ? null : owner.toJson(),
  };
}

class OgDataClass {
  OgDataClass({
    this.title,
    this.description,
    this.image,
    this.url,
  });

  String title;
  String description;
  String image;
  String url;

  factory OgDataClass.fromJson(Map<String, dynamic> json) => OgDataClass(
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    image: json["image"] == null ? null : json["image"],
    url: json["url"] == null ? null : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "image": image == null ? null : image,
    "url": url == null ? null : url,
  };
}

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
