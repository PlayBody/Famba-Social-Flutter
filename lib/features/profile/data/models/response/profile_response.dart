// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse {
  ProfileResponse({
    this.code,
    this.message,
    this.data,
  });

  int code;
  String message;
  Data data;

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data(
      {this.id,
      this.avatar,
      this.cover,
      this.firstName,
      this.lastName,
      this.userName,
      this.phoneNumber,
      this.birthday,
      this.instagram,
      this.ticTok,
      this.twitter,
      this.snapchat,
      this.schoolName,
      this.divisionConference,
      this.gpa,
      this.sports,
      this.city,
      this.stateProfile,
      this.level,
      this.monetization,
      this.serviceHours,
      this.awards,
      this.eduAwards,
      this.extraPoints,
      this.email,
      this.isVerified,
      this.website,
      this.aboutYou,
      this.gender,
      this.country,
      this.postCount,
      this.ipAddress,
      this.followingCount,
      this.followerCount,
      this.language,
      this.lastActive,
      this.profilePrivacy,
      this.memberSince,
      this.isBlockedVisitor,
      this.isFollowing,
      this.canViewProfile,
      this.user,
      this.countryFlag});

  int id;
  String avatar;
  String cover;
  String firstName;
  String lastName;
  String userName;
  String email;
  String phoneNumber;
  String birthday;
  String instagram;
  String ticTok;
  String twitter;
  String snapchat;
  String schoolName;
  String divisionConference;
  String gpa;
  String sports;
  String city;
  String stateProfile;
  String level;
  int monetization;
  String serviceHours;
  String awards;
  String eduAwards;
  String extraPoints;
  bool isVerified;
  String website;
  String aboutYou;
  String gender;
  String country;
  int postCount;
  String ipAddress;
  int followingCount;
  int followerCount;
  String language;
  String lastActive;
  String profilePrivacy;
  String memberSince;
  String countryFlag;
  bool isBlockedVisitor;
  bool isFollowing;
  bool canViewProfile;
  User user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        countryFlag: json["country_flag"] == null ? null : json["country_flag"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        cover: json["cover"] == null ? null : json["cover"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        userName: json["user_name"] == null ? null : json["user_name"],
        phoneNumber: json["phone_number"] == null ? null : json["phone_number"],
        birthday: json['birthday'] == null ? null : json['birthday'],
        instagram: json['instagram'],
        ticTok: json['tic_tok'],
        twitter: json['twitter'],
        snapchat: json['snapchat'],
        schoolName: json['school_name'],
        divisionConference: json['division_conference'],
        gpa: json['gpa'],
        sports: json['sports'],
        city: json['city'],
        stateProfile: json['state'],
        level: json['level'],
        monetization: json['monetization'] == null ? 0 : json['monetization'],
        serviceHours: json['service_hours'],
        awards: json['awards'],
        eduAwards: json['edu_awards'],
        extraPoints: json['extra_points'] == null
            ? '0'
            : json['extra_points'].toString(),
        email: json["email"] == null ? null : json["email"],
        isVerified: json["is_verified"] == null ? null : json["is_verified"],
        website: json["website"] == null ? null : json["website"],
        aboutYou: json["about_you"] == null ? null : json["about_you"],
        gender: json["gender"] == null ? null : json["gender"],
        country: json["country"] == null ? null : json["country"],
        postCount: json["post_count"] == null ? null : json["post_count"],
        ipAddress: json["ip_address"] == null ? null : json["ip_address"],
        followingCount:
            json["following_count"] == null ? null : json["following_count"],
        followerCount:
            json["follower_count"] == null ? null : json["follower_count"],
        language: json["language"] == null ? null : json["language"],
        lastActive: json["last_active"] == null ? null : json["last_active"],
        profilePrivacy:
            json["profile_privacy"] == null ? null : json["profile_privacy"],
        memberSince: json["member_since"] == null ? null : json["member_since"],
        isBlockedVisitor: json["is_blocked_visitor"] == null
            ? null
            : json["is_blocked_visitor"],
        isFollowing: json["is_following"] == null ? null : json["is_following"],
        canViewProfile:
            json["can_view_profile"] == null ? null : json["can_view_profile"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "avatar": avatar == null ? null : avatar,
        "cover": cover == null ? null : cover,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "user_name": userName == null ? null : userName,
        "phone_number": phoneNumber == null ? null : phoneNumber,
        "birthday": birthday == null ? null : birthday,
        "instagram": instagram,
        "tic_tok": ticTok,
        "twitter": twitter,
        "snapchat": snapchat,
        "school_name": schoolName,
        "division_conference": divisionConference,
        "gpa": gpa,
        "sports": sports,
        "city": city,
        "state": stateProfile,
        "level": level,
        "monetization": monetization,
        "service_hours": serviceHours,
        "awards": awards,
        "edu_awards": eduAwards,
        "extra_points": extraPoints,
        "email": email == null ? null : email,
        "is_verified": isVerified == null ? null : isVerified,
        "website": website == null ? null : website,
        "about_you": aboutYou == null ? null : aboutYou,
        "gender": gender == null ? null : gender,
        "country": country == null ? null : country,
        "post_count": postCount == null ? null : postCount,
        "ip_address": ipAddress == null ? null : ipAddress,
        "following_count": followingCount == null ? null : followingCount,
        "follower_count": followerCount == null ? null : followerCount,
        "language": language == null ? null : language,
        "last_active": lastActive == null ? null : lastActive,
        "profile_privacy": profilePrivacy == null ? null : profilePrivacy,
        "member_since": memberSince == null ? null : memberSince,
        "is_blocked_visitor":
            isBlockedVisitor == null ? null : isBlockedVisitor,
        "is_following": isFollowing == null ? null : isFollowing,
        "can_view_profile": canViewProfile == null ? null : canViewProfile,
        "user": user == null ? null : user.toJson(),
      };
}

class User {
  User({
    this.isBlockedVisitor,
    this.isBlockedProfile,
    this.isFollowing,
  });

  bool isBlockedVisitor;
  bool isBlockedProfile;
  bool isFollowing;

  factory User.fromJson(Map<String, dynamic> json) => User(
        isBlockedVisitor: json["is_blocked_visitor"] == null
            ? null
            : json["is_blocked_visitor"],
        isBlockedProfile: json["is_blocked_profile"] == null
            ? null
            : json["is_blocked_profile"],
        isFollowing: json["is_following"] == null ? null : json["is_following"],
      );

  Map<String, dynamic> toJson() => {
        "is_blocked_visitor":
            isBlockedVisitor == null ? null : isBlockedVisitor,
        "is_blocked_profile":
            isBlockedProfile == null ? null : isBlockedProfile,
        "is_following": isFollowing == null ? null : isFollowing,
      };
}
