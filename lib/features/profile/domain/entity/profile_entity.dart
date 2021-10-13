import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import '../../../authentication/data/models/login_response.dart';
import '../../data/models/response/profile_response.dart';

class ProfileEntity {
  final String id;
  final String profileUrl;
  final String backgroundUrl;
  final String avatar;
  final String fullName;
  final String userName;
  final String phoneNumber;
  final String birthday;
  final String instagram;
  final String ticTok;
  final String twitter;
  final String snapchat;
  final String schoolName;
  final String divisionConference;
  final String gpa;
  final String sports;
  final String city;
  final String stateProfile;
  final String level;
  final int monetization;
  final String serviceHours;
  final String awards;
  final String eduAwards;
  final String extraPoints;
  final String about;
  final String country;
  final String website;
  final String memberSince;
  final String postCounts;
  final String followingCount;
  final String followerCount;
  final bool isVerified;
  final String email;
  final String gender;
  final String language;
  final String firstName;
  final String lastName;
  final bool isFollowing;
  final String countryFlag;

  const ProfileEntity._({
    @required this.profileUrl,
    @required this.backgroundUrl,
    @required this.avatar,
    @required this.fullName,
    @required this.userName,
    @required this.about,
    @required this.phoneNumber,
    @required this.birthday,
    @required this.instagram,
    @required this.ticTok,
    @required this.twitter,
    @required this.snapchat,
    @required this.schoolName,
    @required this.divisionConference,
    @required this.gpa,
    @required this.sports,
    @required this.city,
    @required this.stateProfile,
    @required this.level,
    @required this.monetization,
    @required this.serviceHours,
    @required this.awards,
    @required this.eduAwards,
    @required this.extraPoints,
    @required this.country,
    @required this.website,
    @required this.memberSince,
    @required this.postCounts,
    @required this.followingCount,
    @required this.isVerified,
    @required this.followerCount,
    @required this.email,
    @required this.gender,
    @required this.language,
    @required this.firstName,
    @required this.lastName,
    @required this.isFollowing,
    @required this.id,
    @required this.countryFlag,
  });

  factory ProfileEntity.fromProfileResponse({
    @required ProfileResponse profileResponse,
    @required LoginResponse loginResponse,
  }) {
    var profileData = profileResponse.data;

    return ProfileEntity._(
        profileUrl: profileData.avatar,
        backgroundUrl: profileData.cover,
        avatar: profileData.avatar,
        fullName: profileData.firstName != null && profileData.lastName != null
            ? "${profileData.firstName} ${profileData.lastName}"
            : "--",
        userName: "@" + profileData.userName,
        phoneNumber: profileData.phoneNumber,
        birthday: profileData.birthday,
        instagram: profileData.instagram,
        ticTok: profileData.ticTok,
        twitter: profileData.twitter,
        snapchat: profileData.snapchat,
        schoolName: profileData.schoolName,
        divisionConference: profileData.divisionConference,
        gpa: profileData.gpa,
        sports: profileData.sports,
        city: profileData.city,
        stateProfile: profileData.stateProfile,
        level: profileData.level,
        monetization: profileData.monetization,
        serviceHours: profileData.serviceHours,
        awards: profileData.awards,
        eduAwards: profileData.eduAwards,
        extraPoints: profileData.extraPoints,
        about: profileData.aboutYou.isNotEmpty ? profileData.aboutYou : '',
        country: profileData.country,
        website: profileData.website,
        memberSince: profileData.memberSince,
        postCounts: profileData.postCount.toString(),
        followingCount: profileData.followingCount.toString(),
        isVerified: profileData.isVerified,
        followerCount: profileData.followerCount.toString(),
        email: profileData.email,
        gender:
            profileData.gender.toLowerCase().contains("m") ? "Male" : "Female",
        language: profileData.language,
        firstName: profileData.firstName,
        lastName: profileData.lastName,
        isFollowing: profileData?.user?.isFollowing ?? false,
        countryFlag: profileData.countryFlag,
        id: profileData.id.toString());
  }

  ProfileEntity copyWith(
          {String profileUrl,
          String coverUrl,
          bool isFollowing,
          String backgroundImage,
          String profileImage}) =>
      ProfileEntity._(
          profileUrl: profileImage ?? this.profileUrl,
          backgroundUrl: backgroundImage ?? this.backgroundUrl,
          avatar: avatar,
          fullName: fullName,
          userName: userName,
          phoneNumber: phoneNumber,
          birthday: birthday,
          instagram: instagram,
          ticTok: ticTok,
          twitter: twitter,
          snapchat: snapchat,
          schoolName: schoolName,
          divisionConference: divisionConference,
          gpa: gpa,
          sports: sports,
          city: city,
          stateProfile: stateProfile,
          level: level,
          monetization: monetization,
          serviceHours: serviceHours,
          awards: awards,
          eduAwards: eduAwards,
          extraPoints: extraPoints,
          about: about,
          country: country,
          website: website,
          memberSince: memberSince,
          postCounts: postCounts,
          followingCount: followingCount,
          isVerified: isVerified,
          followerCount: followerCount,
          email: email,
          gender: gender,
          language: language,
          firstName: firstName,
          countryFlag: countryFlag,
          lastName: lastName,
          isFollowing: isFollowing ?? this.isFollowing,
          id: this.id);
}
