// To parse this JSON data, do
//
//     final feedResponse = feedResponseFromJson(jsonString);

import 'dart:convert';
import 'package:colibri/features/posts/data/model/response/post_detail_response.dart';
import 'package:colibri/features/posts/data/model/response/ad_response.dart';
import 'package:flutter/foundation.dart';

FeedResponse feedResponseFromJson(String str) =>
    FeedResponse.fromJson(json.decode(str));

String feedResponseToJson(FeedResponse data) => json.encode(data.toJson());

class FeedResponse {
  FeedResponse({
    this.errCode,
    this.code,
    this.message,
    this.data,
  });

  int errCode;
  int code;
  String message;
  Data data;

  factory FeedResponse.fromJson(Map<String, dynamic> json) => FeedResponse(
        errCode: json["err_code"] == null ? null : json["err_code"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode == null ? null : errCode,
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({
    this.feeds,
  });

  List<Feed> feeds;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        feeds: List<Feed>.from(json["feeds"].map((x) => Feed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "feeds": List<Feed>.from(feeds.map((x) => x.toJson())),
      };
}

class Feed {
  Feed(
      {this.id,
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
      this.poll,
      this.hasReposted,
      this.replyTo,
      this.owner,
      this.reposter,
      this.gif,
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
      this.advertisementResponse});

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
  List<FeedMedia> media;
  bool isOwner;
  bool hasLiked;
  bool hasSaved;
  bool hasReposted;
  ReplyTo replyTo;
  Owner owner;
  Reposter reposter;
  dynamic gif;
  String cover;
  String company;
  String targetUrl;
  int views;
  String description;
  String cta;
  String avatar;
  String username;
  String verified;
  Poll poll;
  String name;
  bool isConversed;
  bool showStats;
  String domain;
  AdvertisementResponse advertisementResponse;
  factory Feed.fromJson(Map<String, dynamic> json) => Feed(
        id: json["id"] == null ? null : json["id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        text: json["text"] == null ? null : json["text"],
        type: json["type"] == null ? null : json["type"],
        replysCount: json["replys_count"] == null ? null : json["replys_count"],
        repostsCount:
            json["reposts_count"] == null ? null : json["reposts_count"],
        likesCount: json["likes_count"] == null ? null : json["likes_count"],
        status: json["status"] == null ? null : json["status"],
        threadId: json["thread_id"] == null ? null : json["thread_id"],
        target: json["target"] == null ? null : json["target"],
        //  poll: List<Poll>.from(json["poll"].map((x) => Poll.fromJson(x))),
        // Todo correct the following
        // ogData: json["og_data"],
        ogData: json['og_data'] == null || json['og_data'] == ""
            ? null
            : json['og_data'], //Class1.fromJson(json['og_data']),
        time: json["time"] == null ? null : json["time"],
        offsetId: json["offset_id"] == null ? null : json["offset_id"],
        isRepost: json["is_repost"] == null ? null : json["is_repost"],
        isReposter: json["is_reposter"] == null ? null : json["is_reposter"],
        attrs: json["attrs"] == null ? null : json["attrs"],
        advertising: json["advertising"] == null ? null : json["advertising"],
        advertisementResponse:
            json["advertising"] != null && json["advertising"]
                ? AdvertisementResponse.fromJson(json)
                : null,
        timeRaw: json["time_raw"] == null ? null : json["time_raw"],
        ogText: json["og_text"] == null ? null : json["og_text"],
        ogImage: json["og_image"] == null ? null : json["og_image"],
        url: json["url"] == null ? null : json["url"],
        canDelete: json["can_delete"] == null ? null : json["can_delete"],
        media: json["media"] == null
            ? null
            : json["media"].isEmpty
                ? []
                : List<FeedMedia>.from(
                    json["media"].map((x) => FeedMedia.fromJson(x))),
        isOwner: json["is_owner"] == null ? null : json["is_owner"],
        hasLiked: json["has_liked"] == null ? null : json["has_liked"],
        hasSaved: json["has_saved"] == null ? null : json["has_saved"],
        hasReposted: json["has_reposted"] == null ? null : json["has_reposted"],
        replyTo: json["reply_to"] == null || json["reply_to"].isEmpty
            ? null
            : ReplyTo.fromJson(json["reply_to"]),
        owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
        poll: json["poll"] == null ? null : Poll.fromJson(json["poll"]),
        reposter: json["reposter"] == null
            ? null
            : Reposter.fromJson(json["reposter"]),
        gif: json["gif"],
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
        "og_data": ogData,
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
        // 'poll': List<Poll>.from(poll.map((x) => x.toJson())),
        "media": media == null
            ? null
            : List<dynamic>.from(media.map((x) => x.toJson())),
        "is_owner": isOwner == null ? null : isOwner,
        "has_liked": hasLiked == null ? null : hasLiked,
        "has_saved": hasSaved == null ? null : hasSaved,
        "has_reposted": hasReposted == null ? null : hasReposted,
        "reply_to": replyTo == null ? null : replyTo.toJson(),
        "owner": owner == null ? null : owner.toJson(),
        "reposter": reposter == null ? null : reposter.toJson(),
        "gif": gif,
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

class Poll {
  final int hasVoted;
  final int total;
  final List<Option> options;

  Poll({
    @required this.hasVoted,
    @required this.total,
    @required this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'has_voted': this.hasVoted,
      'total': this.total,
      'options': List<Option>.from(options.map((e) => e.toJson()))
    };
  }

  factory Poll.fromJson(Map<String, dynamic> jsonMap) {
    return Poll(
      hasVoted: jsonMap['has_voted'],
      total: jsonMap['total'],
      options:
          List<Option>.from(jsonMap['options'].map((e) => Option.fromJson(e))),
    );
  }
}

class Option {
  final String percentage;
  final int total;
  final String option;

  Option({
    @required this.percentage,
    @required this.total,
    @required this.option,
  });

  Map<String, dynamic> toJson() {
    return {
      'percentage': this.percentage,
      'total': this.total,
      'option': this.option,
    };
  }

  factory Option.fromJson(Map<String, dynamic> jsonMap) {
    return Option(
      percentage: jsonMap['percentage'],
      total: jsonMap['total'],
      option: jsonMap['option'],
    );
  }
}

class FeedMedia {
  FeedMedia({
    this.id,
    this.pubId,
    this.type,
    this.src,
    this.jsonData,
    this.time,
    // this.x,
  });

  int id;
  int pubId;
  String type;
  String src;
  String jsonData;
  String time;
  // List<String> x;

  factory FeedMedia.fromJson(Map<String, dynamic> json) => FeedMedia(
        id: json["id"] == null ? null : json["id"],
        pubId: json["pub_id"] == null ? null : json["pub_id"],
        type: json["type"] == null ? null : json["type"],
        src: json["src"] == null ? null : json["src"],
        jsonData: json["json_data"] == null ? null : json["json_data"],
        time: json["time"] == null ? null : json["time"],
        // x: json["x"] == null ? null : List<dynamic>.from(json["x"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "pub_id": pubId == null ? null : pubId,
        "type": type == null ? null : type,
        "src": src == null ? null : src,
        "json_data": jsonData == null ? null : jsonData,
        "time": time == null ? null : time,
        // "x": x == null ? null : List<String>.from(x.map((x) => x)),
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

class Reposter {
  Reposter({
    this.name,
    this.username,
    this.url,
  });

  String name;
  String username;
  String url;

  factory Reposter.fromJson(Map<String, dynamic> json) => Reposter(
        name: json["name"] == null ? null : json["name"],
        username: json["username"] == null ? null : json["username"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "username": username == null ? null : username,
        "url": url == null ? null : url,
      };
}
