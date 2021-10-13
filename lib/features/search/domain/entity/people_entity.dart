import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import '../../../posts/data/model/response/likes_response.dart';

import '../../data/models/people_response.dart';
import '../../../../extensions.dart';
import 'package:faker/faker.dart';

class PeopleEntity {
  final String id;
  final String profileUrl;
  final String userName;
  final String fullName;
  final bool isFollowed;
  final bool isVerified;
  final String buttonText;
  // only needed in case of pagination
  final int offsetId;

  // if we have data of current logged in user
  // we will not display follow and follow button
  final bool isCurrentLoggedInUser;
  const PeopleEntity._(
      {@required this.id,
      @required this.profileUrl,
      @required this.userName,
      @required this.fullName,
      @required this.isFollowed,
      @required this.isVerified,
      this.offsetId,
      this.buttonText,
      this.isCurrentLoggedInUser = false});

  factory PeopleEntity.fromPeopleModel(
      PeopleModel model, bool isCurrentLoggedInUser) {
    return PeopleEntity._(
        id: model.id.toString(),
        profileUrl: model.avatar,
        userName: model.username,
        fullName: model.name,
        isFollowed: model.isFollowing,
        isVerified: model.verified.toBool,
        buttonText: model.isFollowing ? "Unfollow" : "Follow",
        isCurrentLoggedInUser: isCurrentLoggedInUser);
  }
  factory PeopleEntity.fromLikesResponse(
      LikePeopleModel model, bool isCurrentLoggedInUser) {
    return PeopleEntity._(
        id: model.id.toString(),
        profileUrl: model.avatar,
        userName: model.username,
        fullName: model.name,
        isFollowed: model.isFollowing,
        isVerified: model.verified.isVerifiedUser,
        buttonText: model.isFollowing ? "Unfollow" : "Follow",
        isCurrentLoggedInUser: isCurrentLoggedInUser,
        offsetId: model.offsetId);
  }
  factory PeopleEntity.getDummyData() {
    return PeopleEntity._(
        id: faker.guid.guid(),
        profileUrl:
            'https://picsum.photos/200?random=${Random.secure().nextInt(100)}',
        userName: "@" + faker.person.firstName(),
        fullName: faker.person.name(),
        isFollowed: true,
        isVerified: false,
        buttonText: "Follow");
  }

  PeopleEntity copyWith({
    String buttonText,
    String fullName,
    String id,
    bool isFollowed,
    bool isVerified,
    String profileUrl,
    String userName,
  }) {
    return PeopleEntity._(
      isFollowed: isFollowed ?? this.isFollowed,
      buttonText: isFollowed ? "Unfollow" : "Follow",
      fullName: fullName ?? this.fullName,
      id: id ?? this.id,
      isVerified: isVerified ?? this.isVerified,
      profileUrl: profileUrl ?? this.profileUrl,
      userName: userName ?? this.userName,
    );
  }
}
