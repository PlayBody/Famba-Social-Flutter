import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/theme/strings.dart';

import '../../data/models/response/privacy_response.dart';
import 'profile_entity.dart';

class SettingEntity extends Equatable {
  final String userName;
  final String firstName;
  final String lastName;
  final String name;
  final String phoneNumber;
  final String email;
  final String birthday;
  final String instagram;
  final String ticTok;
  final String twitter;
  final String snapchat;
  final String schoolName;
  final String divisionConference;
  final String eduAwards;
  final String gpa;
  final String sports;
  final String city;
  final String stateProfile;
  final String level;
  final int monetization;
  final String serviceHours;
  final String awards;
  final String website;
  final String about;
  final String gender;
  final String displayLanguage;
  final String country;
  final bool isVerified;
  final bool socialLogin;
  final AccountPrivacyEntity accountPrivacyEntity;

  SettingEntity._({
    @required this.userName,
    @required this.phoneNumber,
    @required this.email,
    @required this.birthday,
    @required this.instagram,
    @required this.ticTok,
    @required this.twitter,
    @required this.snapchat,
    @required this.schoolName,
    @required this.divisionConference,
    @required this.eduAwards,
    @required this.gpa,
    @required this.sports,
    @required this.city,
    @required this.stateProfile,
    @required this.level,
    @required this.monetization,
    @required this.serviceHours,
    @required this.awards,
    @required this.website,
    @required this.about,
    @required this.gender,
    @required this.displayLanguage,
    @required this.country,
    @required this.accountPrivacyEntity,
    @required this.name,
    @required this.firstName,
    @required this.lastName,
    @required this.isVerified,
    this.socialLogin = false,
  });

  factory SettingEntity.fromSettingResponse(
          ProfileEntity user, AccountPrivacyEntity accountPrivacyEntity) =>
      SettingEntity._(
          userName: user.userName,
          phoneNumber: user.phoneNumber,
          email: user.email,
          birthday: user.birthday,
          instagram: user.instagram,
          ticTok: user.ticTok,
          twitter: user.twitter,
          snapchat: user.snapchat,
          schoolName: user.schoolName,
          divisionConference: user.divisionConference,
          eduAwards: user.eduAwards,
          gpa: user.gpa,
          sports: user.sports,
          city: user.city,
          stateProfile: user.stateProfile,
          level: user.level,
          monetization: user.monetization,
          serviceHours: user.serviceHours,
          awards: user.awards,
          website: user.website != null && user.website.isNotEmpty
              ? user.website
              : Strings.emptyWebsite,
          about: user.about != null && user.about.isNotEmpty
              ? user.about
              : Strings.emptyAbout,
          gender: user.gender,
          displayLanguage: user.language,
          country: user.country,
          name: user.fullName,
          accountPrivacyEntity: accountPrivacyEntity,
          firstName: user.firstName,
          lastName: user.lastName,
          isVerified: user.isVerified);

  SettingEntity copyWith({
    bool didSocialLogin,
    String updatedGender,
    String country,
    AccountPrivacyEntity accountPrivacyEntity,
    String displayLang,
  }) =>
      SettingEntity._(
          userName: userName,
          phoneNumber: phoneNumber,
          email: email,
          birthday: birthday,
          instagram: instagram,
          ticTok: ticTok,
          twitter: twitter,
          snapchat: snapchat,
          schoolName: schoolName,
          divisionConference: divisionConference,
          eduAwards: eduAwards,
          gpa: gpa,
          sports: sports,
          city: city,
          stateProfile: stateProfile,
          level: level,
          monetization: monetization,
          serviceHours: serviceHours,
          awards: awards,
          website: website != null && website.isNotEmpty
              ? website
              : "You have not yet determined the URL of your site",
          about: about != null && about.isNotEmpty
              ? about
              : "The field with information about you is still empty",
          gender: updatedGender ?? gender,
          displayLanguage: displayLang ?? this.displayLanguage,
          country: country ?? this.country,
          accountPrivacyEntity:
              accountPrivacyEntity ?? this.accountPrivacyEntity,
          name: name,
          firstName: firstName,
          lastName: lastName,
          socialLogin: didSocialLogin ?? socialLogin,
          isVerified: isVerified);

  @override
  List<Object> get props => [
        this.userName,
        this.phoneNumber,
        this.email,
        this.website,
        this.about,
        this.gender,
        this.displayLanguage,
        this.country,
        this.accountPrivacyEntity,
        this.name,
        this.firstName,
        this.lastName,
        this.isVerified,
        this.socialLogin,
      ];
}

class AccountPrivacyEntity extends Equatable {
  final String canSeeMyPosts;
  final String canFollowMe;
  final String canDMMe;
  final String showProfileInSearchEngine;

  AccountPrivacyEntity._(
      {@required this.canSeeMyPosts,
      @required this.canFollowMe,
      @required this.canDMMe,
      @required this.showProfileInSearchEngine});

  factory AccountPrivacyEntity.fromResponse(PrivacyModel model) =>
      AccountPrivacyEntity._(
          canSeeMyPosts: model.profileVisibility == "followers"
              ? Strings.privacyMyFollowers
              : Strings.privacyEveryOne,
          canFollowMe: null,
          canDMMe: model.contactPrivacy == "followed"
              ? Strings.privacyPeopleIFollow
              : Strings.privacyEveryOne,
          showProfileInSearchEngine:
              model.searchVisibility ? Strings.privacyYes : Strings.privacyNo);
  HashMap<String, String> toModelJson() => HashMap.from({
        "profile_visibility": canSeeMyPosts == Strings.privacyMyFollowers
            ? "followers"
            : "everyone",
        "contact_privacy":
            canDMMe == Strings.privacyEveryOne ? "everyone" : "followed",
        "follow_privacy": "everyone",
        "search_visibility":
            showProfileInSearchEngine == Strings.privacyYes ? "Y" : "N",
      });

  AccountPrivacyEntity copyWith(
          {String canSeeMyPosts,
          String canFollowMe,
          String showProfileInSearchEngine}) =>
      AccountPrivacyEntity._(
          canSeeMyPosts: canSeeMyPosts ?? this.canSeeMyPosts,
          canFollowMe: null,
          canDMMe: canFollowMe ?? this.canFollowMe,
          showProfileInSearchEngine:
              showProfileInSearchEngine ?? this.showProfileInSearchEngine);

  @override
  List<Object> get props => [
        this.canSeeMyPosts,
        this.canFollowMe,
        this.canDMMe,
        this.showProfileInSearchEngine,
      ];
}
