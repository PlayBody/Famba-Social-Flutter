// To parse this JSON data, do
//
//     final postDetailResponse = postDetailResponseFromJson(jsonString);

import 'dart:convert';

import 'package:colibri/features/feed/data/models/feeds_response.dart';
import 'package:colibri/features/profile/data/models/response/profile_posts_response.dart';

PostDetailResponse postDetailResponseFromJson(String str) => PostDetailResponse.fromJson(json.decode(str));

String postDetailResponseToJson(PostDetailResponse data) => json.encode(data.toJson());

class PostDetailResponse {
  PostDetailResponse({
    this.code,
    this.data,
  });

  int code;
  Data data;

  factory PostDetailResponse.fromJson(Map<String, dynamic> json) => PostDetailResponse(
    code: json["code"] == null ? null : json["code"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    this.post,
    this.next,
    this.canReply,
    this.canSee,
    this.prev,
  });

  Feed post;
  List<NextPostItem> next;
  bool canReply;
  bool canSee;
  List<NextPostItem> prev;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    post: json["post"] == null ? null : Feed.fromJson(json["post"]),
    next: json["next"] == null ? null : List<NextPostItem>.from(json["next"].map((x) => NextPostItem.fromJson(x))),
    canReply: json["can_reply"] == null ? null : json["can_reply"],
    canSee: json["can_see"] == null ? null : json["can_see"],
    prev: json["prev"] == null ? null : List<NextPostItem>.from(json["prev"].map((x) => NextPostItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "post": post == null ? null : post.toJson(),
    "next": next == null ? null : List<dynamic>.from(next.map((x) => x.toJson())),
    "can_reply": canReply == null ? null : canReply,
    "can_see": canSee == null ? null : canSee,
    "prev": prev == null ? null : List<dynamic>.from(prev.map((x) => x)),
  };
}

class NextPostItem {
  NextPostItem({
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
    this.replys=const [],
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
    this.offsetId,
    this.isRepost,
    this.reposter
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
  // OgDataClass1 ogData;
  // String ogData;
  String pollData;
  String privWcs;
  String privWcr;
  String time;
  List<NextPostItem> replys;
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
  bool isBlocked;
  bool meBlocked;
  bool canSee;
  ReplyTo replyTo;
  Owner owner;
  int offsetId;
  bool isRepost;
  Reposter reposter;

  factory NextPostItem.fromJson(Map<String, dynamic> json) => NextPostItem(
    reposter: json["reposter"] == null ? null : Reposter.fromJson(json["reposter"]),
    id: json["id"] == null ? null : json["id"],
    isRepost: json["is_repost"] == null ? null : json["is_repost"],
    userId: json["user_id"] == null ? null : json["user_id"],
    text: json["text"] == null ? null : json["text"],
    type: json["type"] == null ? null : json["type"],
    replysCount: json["replys_count"] == null ? null : json["replys_count"],
    repostsCount: json["reposts_count"] == null ? null : json["reposts_count"],
    likesCount: json["likes_count"] == null ? null : json["likes_count"],
    status: json["status"] == null ? null : json["status"],
    threadId: json["thread_id"] == null ? null : json["thread_id"],
    target: json["target"] == null ? null : json["target"],
    ogData: json["og_data"] == null ? null : json["og_data"],
    pollData: json["poll_data"] == null ? null : json["poll_data"],
    privWcs: json["priv_wcs"] == null ? null : json["priv_wcs"],
    privWcr: json["priv_wcr"] == null ? null : json["priv_wcr"],
    time: json["time"] == null ? null : json["time"],
    replys: json["replys"] == null||json["replys"].isEmpty ? [] : List<NextPostItem>.from(json["replys"].map((x) => NextPostItem.fromJson(x))),
    advertising: json["advertising"] == null ? null : json["advertising"],
    timeRaw: json["time_raw"] == null ? null : json["time_raw"],
    ogText: json["og_text"] == null ? null : json["og_text"],
    ogImage: json["og_image"] == null ? null : json["og_image"],
    url: json["url"] == null ? null : json["url"],
    canDelete: json["can_delete"] == null ? null : json["can_delete"],
    media: json["media"] == null ? null : List<ProfilePostMedia>.from(json["media"].map((x) => ProfilePostMedia.fromJson(x))),
    isOwner: json["is_owner"] == null ? null : json["is_owner"],
    hasLiked: json["has_liked"] == null ? null : json["has_liked"],
    hasSaved: json["has_saved"] == null ? null : json["has_saved"],
    hasReposted: json["has_reposted"] == null ? null : json["has_reposted"],
    isBlocked: json["is_blocked"] == null ? null : json["is_blocked"],
    meBlocked: json["me_blocked"] == null ? null : json["me_blocked"],
    canSee: json["can_see"] == null ? null : json["can_see"],
    replyTo: json["reply_to"] == null || json["reply_to"].isEmpty? null : ReplyTo.fromJson(json["reply_to"]),
    owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
    offsetId: json["offset_id"] == null ? null : json["offset_id"],
  );

  Map<String, dynamic> toJson() => {
    "is_repost":isRepost==null?null:isRepost,
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
    "og_data": ogData == null ? null : ogData,
    "poll_data": pollData == null ? null : pollData,
    "priv_wcs": privWcs == null ? null : privWcs,
    "priv_wcr": privWcr == null ? null : privWcr,
    "time": time == null ? null : time,
    "replys": replys == null ? null : List<dynamic>.from(replys.map((x) => x.toJson())),
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
    "reply_to": replyTo == null ? null : replyTo.toJson(),
    "owner": owner == null ? null : owner.toJson(),
    "offset_id": offsetId == null ? null : offsetId,
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

class ReplyTo {
  ReplyTo({
    this.id,
    this.url,
    this.avatar,
    this.username,
    this.name,
    this.gender,
    this.isOwner,
    this.threadUrl,
  });

  int id;
  String url;
  String avatar;
  String username;
  String name;
  String gender;
  bool isOwner;
  String threadUrl;

  factory ReplyTo.fromJson(Map<String, dynamic> json) => ReplyTo(
    id: json["id"] == null ? null : json["id"],
    url: json["url"] == null ? null : json["url"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    username: json["username"] == null ? null : json["username"],
    name: json["name"] == null ? null : json["name"],
    gender: json["gender"] == null ? null : json["gender"],
    isOwner: json["is_owner"] == null ? null : json["is_owner"],
    threadUrl: json["thread_url"] == null ? null : json["thread_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "url": url == null ? null : url,
    "avatar": avatar == null ? null : avatar,
    "username": username == null ? null : username,
    "name": name == null ? null : name,
    "gender": gender == null ? null : gender,
    "is_owner": isOwner == null ? null : isOwner,
    "thread_url": threadUrl == null ? null : threadUrl,
  };
}

// class Post {
//   Post({
//     this.id,
//     this.userId,
//     this.text,
//     this.type,
//     this.replysCount,
//     this.repostsCount,
//     this.likesCount,
//     this.status,
//     this.threadId,
//     this.target,
//     this.ogData,
//     this.pollData,
//     this.privWcs,
//     this.privWcr,
//     this.time,
//     this.advertising,
//     this.timeRaw,
//     this.ogText,
//     this.ogImage,
//     this.url,
//     this.canDelete,
//     this.media,
//     this.isOwner,
//     this.hasLiked,
//     this.hasSaved,
//     this.hasReposted,
//     this.isBlocked,
//     this.meBlocked,
//     this.canSee,
//     this.replyTo,
//     this.owner,
//     this.offsetId,
//   });
//
//   int id;
//   int userId;
//   String text;
//   String type;
//   String replysCount;
//   String repostsCount;
//   String likesCount;
//   String status;
//   int threadId;
//   String target;
//   String ogData;
//   String pollData;
//   String privWcs;
//   String privWcr;
//   String time;
//   bool advertising;
//   String timeRaw;
//   String ogText;
//   String ogImage;
//   String url;
//   bool canDelete;
//   List<Media> media;
//   bool isOwner;
//   bool hasLiked;
//   bool hasSaved;
//   bool hasReposted;
//   bool isBlocked;
//   bool meBlocked;
//   bool canSee;
//   List<dynamic> replyTo;
//   Owner owner;
//   int offsetId;
//
//   factory Post.fromJson(Map<String, dynamic> json) => Post(
//     id: json["id"] == null ? null : json["id"],
//     userId: json["user_id"] == null ? null : json["user_id"],
//     text: json["text"] == null ? null : json["text"],
//     type: json["type"] == null ? null : json["type"],
//     replysCount: json["replys_count"] == null ? null : json["replys_count"],
//     repostsCount: json["reposts_count"] == null ? null : json["reposts_count"],
//     likesCount: json["likes_count"] == null ? null : json["likes_count"],
//     status: json["status"] == null ? null : json["status"],
//     threadId: json["thread_id"] == null ? null : json["thread_id"],
//     target: json["target"] == null ? null : json["target"],
//     ogData: json["og_data"] == null ? null : json["og_data"],
//     pollData: json["poll_data"] == null ? null : json["poll_data"],
//     privWcs: json["priv_wcs"] == null ? null : json["priv_wcs"],
//     privWcr: json["priv_wcr"] == null ? null : json["priv_wcr"],
//     time: json["time"] == null ? null : json["time"],
//     advertising: json["advertising"] == null ? null : json["advertising"],
//     timeRaw: json["time_raw"] == null ? null : json["time_raw"],
//     ogText: json["og_text"] == null ? null : json["og_text"],
//     ogImage: json["og_image"] == null ? null : json["og_image"],
//     url: json["url"] == null ? null : json["url"],
//     canDelete: json["can_delete"] == null ? null : json["can_delete"],
//     media: json["media"] == null ? null : List<Media>.from(json["media"].map((x) => Media.fromJson(x))),
//     isOwner: json["is_owner"] == null ? null : json["is_owner"],
//     hasLiked: json["has_liked"] == null ? null : json["has_liked"],
//     hasSaved: json["has_saved"] == null ? null : json["has_saved"],
//     hasReposted: json["has_reposted"] == null ? null : json["has_reposted"],
//     isBlocked: json["is_blocked"] == null ? null : json["is_blocked"],
//     meBlocked: json["me_blocked"] == null ? null : json["me_blocked"],
//     canSee: json["can_see"] == null ? null : json["can_see"],
//     replyTo: json["reply_to"] == null ? null : List<dynamic>.from(json["reply_to"].map((x) => x)),
//     owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
//     offsetId: json["offset_id"] == null ? null : json["offset_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id == null ? null : id,
//     "user_id": userId == null ? null : userId,
//     "text": text == null ? null : text,
//     "type": type == null ? null : type,
//     "replys_count": replysCount == null ? null : replysCount,
//     "reposts_count": repostsCount == null ? null : repostsCount,
//     "likes_count": likesCount == null ? null : likesCount,
//     "status": status == null ? null : status,
//     "thread_id": threadId == null ? null : threadId,
//     "target": target == null ? null : target,
//     "og_data": ogData == null ? null : ogData,
//     "poll_data": pollData == null ? null : pollData,
//     "priv_wcs": privWcs == null ? null : privWcs,
//     "priv_wcr": privWcr == null ? null : privWcr,
//     "time": time == null ? null : time,
//     "advertising": advertising == null ? null : advertising,
//     "time_raw": timeRaw == null ? null : timeRaw,
//     "og_text": ogText == null ? null : ogText,
//     "og_image": ogImage == null ? null : ogImage,
//     "url": url == null ? null : url,
//     "can_delete": canDelete == null ? null : canDelete,
//     "media": media == null ? null : List<dynamic>.from(media.map((x) => x.toJson())),
//     "is_owner": isOwner == null ? null : isOwner,
//     "has_liked": hasLiked == null ? null : hasLiked,
//     "has_saved": hasSaved == null ? null : hasSaved,
//     "has_reposted": hasReposted == null ? null : hasReposted,
//     "is_blocked": isBlocked == null ? null : isBlocked,
//     "me_blocked": meBlocked == null ? null : meBlocked,
//     "can_see": canSee == null ? null : canSee,
//     "reply_to": replyTo == null ? null : List<dynamic>.from(replyTo.map((x) => x)),
//     "owner": owner == null ? null : owner.toJson(),
//     "offset_id": offsetId == null ? null : offsetId,
//   };
// }

class Media {
  Media({
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
  X x;

  factory Media.fromJson(Map<String, dynamic> json) => Media(
    id: json["id"] == null ? null : json["id"],
    pubId: json["pub_id"] == null ? null : json["pub_id"],
    type: json["type"] == null ? null : json["type"],
    src: json["src"] == null ? null : json["src"],
    jsonData: json["json_data"] == null ? null : json["json_data"],
    time: json["time"] == null ? null : json["time"],
    x: json["x"] == null ? null : X.fromJson(json["x"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "pub_id": pubId == null ? null : pubId,
    "type": type == null ? null : type,
    "src": src == null ? null : src,
    "json_data": jsonData == null ? null : jsonData,
    "time": time == null ? null : time,
    "x": x == null ? null : x.toJson(),
  };
}

class X {
  X({
    this.imageThumb,
  });

  String imageThumb;

  factory X.fromJson(Map<String, dynamic> json) => X(
    imageThumb: json["image_thumb"] == null ? null : json["image_thumb"],
  );

  Map<String, dynamic> toJson() => {
    "image_thumb": imageThumb == null ? null : imageThumb,
  };
}
