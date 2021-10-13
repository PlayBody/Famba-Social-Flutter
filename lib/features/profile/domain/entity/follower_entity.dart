import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';

import '../../../posts/data/model/response/follwers_response.dart';

class FollowerEntity {
  final String profileUrl;
  final String fullName;
  final String username;
  final String about;
  final bool isFollowing;
  final int id;
  final int offsetId;
  final String buttonText;

  // if the user if current logged in user
  // we will not display follow or unfollow button
  final bool isCurrentLoggedInUser;

  FollowerEntity(
      {@required this.profileUrl,
      @required this.fullName,
      @required this.username,
      @required this.about,
      @required this.isFollowing,
      @required this.id,
      @required this.offsetId,
      @required this.buttonText,
      this.isCurrentLoggedInUser = false});

  factory FollowerEntity.fromResponse(
          FollowerResponseModel model, bool isCurrentLoggedInUser) =>
      FollowerEntity(
          profileUrl: model.avatar,
          fullName: model.name,
          username: model.username,
          about: model.about,
          isFollowing: model.isFollowing,
          id: model.id,
          offsetId: model.offsetId,
          buttonText: model.isFollowing ? "Unfollow" : "Follow",
          isCurrentLoggedInUser: isCurrentLoggedInUser);

  FollowerEntity copyWith({
    String buttonText,
    bool isFollowed,
  }) =>
      FollowerEntity(
          profileUrl: this.profileUrl,
          fullName: this.fullName,
          username: this.username,
          about: this.about,
          isFollowing: isFollowed ?? this.isFollowing,
          id: this.id,
          offsetId: this.offsetId,
          buttonText: isFollowed ? "Unfollow" : "Follow",
          isCurrentLoggedInUser: isCurrentLoggedInUser);
}
