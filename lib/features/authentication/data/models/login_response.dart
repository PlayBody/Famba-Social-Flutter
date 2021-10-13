// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse extends Equatable {
  LoginResponse({
    this.errCode,
    this.code,
    this.message,
    this.data,
    this.auth,
  });

  final int errCode;
  final int code;
  final String message;
  final Data data;
  final UserAuth auth;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        errCode: json["err_code"] == null ? null : json["err_code"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        auth: json["auth"] == null ? null : UserAuth.fromJson(json["auth"]),
      );

  Map<String, dynamic> toJson() => {
        "err_code": errCode == null ? null : errCode,
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
        "auth": auth == null ? null : auth.toJson(),
      };

  @override
  List<Object> get props => [
        this.errCode,
        this.code,
        this.message,
        this.data,
        this.auth,
      ];
}

class UserAuth extends Equatable {
  UserAuth({
    this.authToken,
    this.refreshToken,
    this.authTokenExpiry,
  });

  final String authToken;
  final String refreshToken;
  final int authTokenExpiry;

  factory UserAuth.fromJson(Map<String, dynamic> json) => UserAuth(
        authToken: json["auth_token"] == null ? null : json["auth_token"],
        refreshToken:
            json["refresh_token"] == null ? null : json["refresh_token"],
        authTokenExpiry: json["auth_token_expiry"] == null
            ? null
            : json["auth_token_expiry"],
      );

  Map<String, dynamic> toJson() => {
        "auth_token": authToken == null ? null : authToken,
        "refresh_token": refreshToken == null ? null : refreshToken,
        "auth_token_expiry": authTokenExpiry == null ? null : authTokenExpiry,
      };

  @override
  List<Object> get props => [
        this.authToken,
        this.refreshToken,
        this.authTokenExpiry,
      ];
}

class Data {
  Data({
    this.user,
  });

  UserModel user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user == null ? null : user.toJson(),
      };
}

class UserModel {
  UserModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.userName,
    this.profilePicture,
    this.coverPicture,
    this.email,
    this.isVerified,
    this.website,
    this.aboutYou,
    this.gender,
    this.country,
    this.postCount,
    this.lastPost,
    this.lastAd,
    this.language,
    this.followingCount,
    this.followerCount,
    this.wallet,
    this.ipAddress,
    this.lastActive,
    this.memberSince,
    this.profilePrivacy,
  });

  int userId;
  String firstName;
  String lastName;
  String userName;
  String profilePicture;
  String coverPicture;
  String email;
  bool isVerified;
  String website;
  String aboutYou;
  String gender;
  String country;
  int postCount;
  int lastPost;
  int lastAd;
  String language;
  int followingCount;
  int followerCount;
  String wallet;
  String ipAddress;
  String lastActive;
  String memberSince;
  String profilePrivacy;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json["user_id"] == null ? null : json["user_id"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        userName: json["user_name"] == null ? null : json["user_name"],
        profilePicture:
            json["profile_picture"] == null ? null : json["profile_picture"],
        coverPicture:
            json["cover_picture"] == null ? null : json["cover_picture"],
        email: json["email"] == null ? null : json["email"],
        isVerified: json["is_verified"] == null ? null : json["is_verified"],
        website: json["website"] == null ? null : json["website"],
        aboutYou: json["about_you"] == null ? null : json["about_you"],
        gender: json["gender"] == null ? null : json["gender"],
        country: json["country"] == null ? null : json["country"],
        postCount: json["post_count"] == null ? null : json["post_count"],
        lastPost: json["last_post"] == null ? null : json["last_post"],
        lastAd: json["last_ad"] == null ? null : json["last_ad"],
        language: json["language"] == null ? null : json["language"],
        followingCount:
            json["following_count"] == null ? null : json["following_count"],
        followerCount:
            json["follower_count"] == null ? null : json["follower_count"],
        wallet: json["wallet"] == null ? null : json["wallet"],
        ipAddress: json["ip_address"] == null ? null : json["ip_address"],
        lastActive: json["last_active"] == null ? null : json["last_active"],
        memberSince: json["member_since"] == null ? null : json["member_since"],
        profilePrivacy:
            json["profile_privacy"] == null ? null : json["profile_privacy"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId == null ? null : userId,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "user_name": userName == null ? null : userName,
        "profile_picture": profilePicture == null ? null : profilePicture,
        "cover_picture": coverPicture == null ? null : coverPicture,
        "email": email == null ? null : email,
        "is_verified": isVerified == null ? null : isVerified,
        "website": website == null ? null : website,
        "about_you": aboutYou == null ? null : aboutYou,
        "gender": gender == null ? null : gender,
        "country": country == null ? null : country,
        "post_count": postCount == null ? null : postCount,
        "last_post": lastPost == null ? null : lastPost,
        "last_ad": lastAd == null ? null : lastAd,
        "language": language == null ? null : language,
        "following_count": followingCount == null ? null : followingCount,
        "follower_count": followerCount == null ? null : followerCount,
        "wallet": wallet == null ? null : wallet,
        "ip_address": ipAddress == null ? null : ipAddress,
        "last_active": lastActive == null ? null : lastActive,
        "member_since": memberSince == null ? null : memberSince,
        "profile_privacy": profilePrivacy == null ? null : profilePrivacy,
      };
}
