import '../../../authentication/data/models/login_response.dart';
import 'package:flutter/material.dart';

class DrawerEntity {
  final String profileUrl;
  final String fullName;
  final String userName;
  final bool isVerified;
  final String postCounts;
  final String followingCount;
  final String followerCount;

  DrawerEntity._(
      {@required this.profileUrl,
      @required this.fullName,
      @required this.userName,
      @required this.isVerified,
      @required this.postCounts,
      @required this.followingCount,
      @required this.followerCount});

  factory DrawerEntity.fromUserData(LoginResponse loginResponse) {
    var userData = loginResponse.data.user;
    return DrawerEntity._(
        profileUrl: userData.profilePicture,
        fullName: userData.firstName != null && userData.lastName != null
            ? "${userData.firstName} ${userData.lastName}"
            : "--",
        userName: "@" + userData.userName,
        isVerified: userData.isVerified,
        postCounts: userData.postCount.toString(),
        followingCount: userData.followerCount.toString(),
        followerCount: userData.followerCount.toString());
  }
}
