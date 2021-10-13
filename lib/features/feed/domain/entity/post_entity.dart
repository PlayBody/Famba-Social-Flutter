import 'package:auto_route/auto_route.dart';

import '../../data/models/feeds_response.dart';
import 'post_media.dart';

import '../../../posts/data/model/response/post_detail_response.dart';
import '../../../posts/data/model/response/ad_response.dart';
import '../../../profile/data/models/response/profile_posts_response.dart';
import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import '../../../../extensions.dart';

class PostEntity extends Equatable {
  final String postId;
  final String profileUrl;
  final String name;
  final String userName;
  final String time;
  final String description;
  final List<PostMedia> media;
  final bool isLiked;
  final bool isCommented;
  final bool isReposted;
  final bool showRepostedText;
  final String likeCount;
  final String repostCount;
  final String commentCount;
  final int offSetId;
  final bool isAdvertisement;
  final bool isSaved;
  final int threadID;
  final List<PostEntity> replys;
  final String type;
  // response to full name
  final String responseTo;

  // user id of person who responds to the post
  final String responseToUserId;

  final PostEntity previous;

  // helps to draw lines between two post item ( timeline)
  final bool isConnected;

  // helps us to check if it's reply item and render ui
  final bool isReplyItem;

  // if it's ads then we will show ads widget
  final AdvertisementEntity advertisementEntity;

  // it's used when user is inside post detail
  // this will be used on the main post of the thread/post
  final bool showFullDivider;
  final String parentPostTime;

  //we need username of the person who is parent or owner of the post
  final String parentPostUsername;

  final bool isOtherUser;
  final String otherUserId;

  final String userProfileUrl;
  final String coverUrl;

  final bool postOwnerVerified;

  final String reposterFullname;

  // used for sharing the post as url to other platforms
  final String urlForSharing;

  final bool isRposterCurrentUser;

  // final dynamic ogData;
  final ogData;

  final Poll poll;

  const PostEntity._(
      {@required this.postId,
      @required this.profileUrl,
      @required this.name,
      @required this.userName,
      @required this.time,
      @required this.description,
      @required this.type,
      this.media = const [],
      this.poll,
      this.isLiked = false,
      this.isCommented = false,
      this.isReposted = false,
      @required this.likeCount,
      @required this.repostCount,
      @required this.commentCount,
      @required this.offSetId,
      @required this.isAdvertisement,
      @required this.isSaved,
      @required this.threadID,
      this.replys = const [],
      this.responseTo,
      this.previous,
      this.isConnected = false,
      this.showRepostedText = false,
      this.advertisementEntity,
      this.isReplyItem = false,
      this.parentPostTime = "",
      this.showFullDivider = false,
      this.isOtherUser = false,
      this.otherUserId,
      this.responseToUserId,
      @required this.coverUrl,
      @required this.userProfileUrl,
      @required this.urlForSharing,
      this.parentPostUsername,
      this.postOwnerVerified = false,
      this.ogData,
      this.reposterFullname = null,
      this.isRposterCurrentUser = false});

  factory PostEntity.fromFeed(Feed data, {Feed previous}) {
    return PostEntity._(
        postId: data.id.toString(),
        profileUrl: data.owner.avatar,
        name: data.owner.name,
        userName: data.owner.username,
        time: data.time,
        type: data.type,
        poll: data.poll,
        // description: faker.lorem.sentence(),
        description: data.text ?? "",
        media: data.media?.map((e) => PostMedia.fromFeed(e))?.toList() ?? [],
        isLiked: data.hasLiked,
        isCommented: data.hasSaved,
        isReposted: data.hasReposted,
        likeCount: data.likesCount,
        repostCount: data.repostsCount,
        commentCount: data.replysCount,
        offSetId: data.offsetId,
        isAdvertisement: data.advertising,
        isSaved: data.hasSaved,
        threadID: data.id,
        responseTo: data?.replyTo?.name,
        responseToUserId: data?.replyTo?.id.toString(),
        previous: previous != null ? PostEntity.fromFeed(previous) : null,
        showRepostedText: data.isRepost,
        advertisementEntity: data.advertising
            ? AdvertisementEntity.fromAdsResponse(data.advertisementResponse)
            : null,
        isOtherUser: !data.isOwner,
        otherUserId: !data.isOwner ? data.owner.id.toString() : null,
        coverUrl: data.cover,
        userProfileUrl: data.avatar,
        reposterFullname: data?.reposter?.name,
        urlForSharing: data.url,
        ogData: data?.ogData != null ? data.ogData : null,
        postOwnerVerified: data.owner.verified.isVerifiedUser);
  }

  factory PostEntity.fromDummy() {
    return PostEntity._(
        postId: faker.guid.guid(),
        profileUrl:
            "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50",
        name: faker.person.name(),
        userName: faker.person.lastName(),
        time: "2 mins ago",
        description: faker.lorem.word(),
        media: [],
        isLiked: true,
        isCommented: false,
        isReposted: false,
        likeCount: 23.toString(),
        repostCount: 40.toString(),
        commentCount: 10.toString(),
        offSetId: 22,
        isAdvertisement: false,
        isSaved: false,
        threadID: 0,
        userProfileUrl: null,
        coverUrl: null,
        urlForSharing: null,
        type: '');
  }

  factory PostEntity.fromProfilePosts(ProfilePost data) {
    ///123456
    return PostEntity._(
      postId: data.id.toString(),
      profileUrl: data.owner.avatar,
      name: data.owner.name,
      userName: data.owner.username,
      time: data.time,
      // description: faker.lorem.sentence(),
      description: data.text ?? "",
      media:
          data.media?.map((e) => PostMedia.fromProfilePostMedia(e))?.toList() ??
              [],
      isLiked: data.hasLiked,
      isCommented: data.hasSaved,
      isReposted: data.hasReposted,
      likeCount: data.likesCount,
      repostCount: data.repostsCount,
      commentCount: data.replysCount,
      offSetId: data.offsetId,
      isAdvertisement: data.advertising,
      isSaved: data.hasSaved,
      threadID: data.id,
      isOtherUser: !data.isOwner,
      otherUserId: !data.isOwner ? data.owner.id.toString() : null,
      showRepostedText: data.isRepost,
      coverUrl: data.cover,
      userProfileUrl: data.avatar,
      urlForSharing: data.url,
      responseTo: data?.replyTo?.name,
      responseToUserId: data?.replyTo?.id.toString(),
      advertisementEntity: data.advertising
          ? AdvertisementEntity.fromAdsResponse(data.advertisementResponse)
          : null,
      postOwnerVerified: data.owner.verified.isVerifiedUser,
      reposterFullname: data?.reposter?.name,
      ogData: data?.ogData != null && data.ogData != "" ? data?.ogData : null,
      type: data.type,
      // ogData: data?.ogData != null ? data?.ogData : null
    );
  }

  factory PostEntity.fromPostDetails(NextPostItem data, {Feed previous}) {
    return PostEntity._(
        postId: data.id.toString(),
        profileUrl: data.owner.avatar,
        name: data.owner.name,
        userName: data.owner.username,
        type: data.type,
        //  poll: data.pollData,
        time: data.time,
        // description: faker.lorem.sentence(),
        description: data.text ?? "",
        media: data.media
                ?.map((e) => PostMedia.fromProfilePostMedia(e))
                ?.toList() ??
            [],
        isLiked: data.hasLiked,
        isCommented: data.hasSaved,
        isReposted: data.hasReposted,
        likeCount: data.likesCount,
        repostCount: data.repostsCount,
        commentCount: data.replysCount,
        offSetId: data.offsetId,
        isAdvertisement: data.advertising,
        isSaved: data.hasSaved,
        threadID: data.id,
        responseTo: data?.replyTo?.name,
        responseToUserId: data?.replyTo?.id.toString(),
        isOtherUser: data.owner.id.toString() != data?.replyTo.toString(),
        previous: previous != null ? PostEntity.fromFeed(previous) : null,
        showRepostedText: data.isRepost,
        userProfileUrl: null,
        coverUrl: null,
        reposterFullname: data?.reposter?.name,
        urlForSharing: data.url,
        postOwnerVerified: data.owner.verified.isVerifiedUser,
        ogData: data?.ogData != null ? data?.ogData : null);
  }

  PostEntity copyWith(
      {String commentCount,
      String description,
      bool isAdvertisement,
      bool isCommented,
      bool isLiked,
      bool isReposted,
      String likeCount,
      List<PostMedia> media,
      String name,
      int offSetId,
      String postId,
      String profileUrl,
      String repostCount,
      String time,
      String userName,
      bool isSaved,
      int threadID,
      List<PostEntity> replys,
      PostEntity previous,
      String responseTo,
      bool isConnected,
      bool showRepostedText,
      bool isReplyItem,
      String parentPostTime,
      bool showFullDivider,
      String parentPostUsername,
      String reposterFullname,
      String responseToUserId,
      bool isOtherUser,
      String type,
      Poll poll,
      final ogData
      // OgDataClass1 ogData

      }) {
    return PostEntity._(
        commentCount: commentCount ?? this.commentCount,
        description: description ?? this.description,
        poll: poll ?? this.poll,
        isAdvertisement: isAdvertisement ?? this.isAdvertisement,
        isCommented: isCommented ?? this.isCommented,
        isLiked: isLiked ?? this.isLiked,
        isReposted: isReposted ?? this.isReposted,
        likeCount: likeCount ?? this.likeCount,
        media: media ?? this.media,
        type: type ?? this.type,
        name: name ?? this.name,
        offSetId: offSetId ?? this.offSetId,
        postId: postId ?? this.postId,
        profileUrl: profileUrl ?? this.profileUrl,
        repostCount: repostCount ?? this.repostCount,
        time: time ?? this.time,
        userName: userName ?? this.userName,
        isSaved: isSaved ?? this.isSaved,
        threadID: threadID ?? this.threadID,
        replys: replys ?? this.replys,
        previous: previous ?? this.previous,
        responseTo: responseTo ?? this.responseTo,
        isConnected: isConnected ?? this.isConnected,
        showRepostedText: showRepostedText ?? this.showRepostedText,
        isReplyItem: isReplyItem ?? this.isReplyItem,
        parentPostTime: parentPostTime ?? this.parentPostTime,
        showFullDivider: showFullDivider ?? this.showFullDivider,
        userProfileUrl: this.userProfileUrl,
        coverUrl: this.coverUrl,
        urlForSharing: this.urlForSharing,
        advertisementEntity: advertisementEntity,
        parentPostUsername: parentPostUsername ?? this.parentPostUsername,
        isOtherUser: isOtherUser ?? this.isOtherUser,
        otherUserId: this.otherUserId,
        responseToUserId: responseToUserId ?? this.responseToUserId,
        postOwnerVerified: postOwnerVerified,
        reposterFullname: reposterFullname ?? this.reposterFullname,
        ogData: ogData ?? this.ogData);
  }

  @override
  List<Object> get props => [likeCount, repostCount, commentCount, postId];
}

class AdvertisementEntity {
  final String adTitle;
  final String adSubTitle;
  final String adMediaUrl;
  final String bodyText;
  final String adWebsite;
  final String onClickUrl;
  final String advertiserName;
  final String advertiserUsername;
  final String advertiserProfileUrl;
  final bool isVerified;
  final String time;

  AdvertisementEntity._(
      {@required this.adTitle,
      @required this.adSubTitle,
      @required this.adMediaUrl,
      @required this.bodyText,
      @required this.adWebsite,
      @required this.onClickUrl,
      @required this.advertiserName,
      @required this.advertiserUsername,
      @required this.advertiserProfileUrl,
      @required this.isVerified,
      @required this.time});

  factory AdvertisementEntity.fromAdsResponse(AdvertisementResponse data) {
    return AdvertisementEntity._(
        adTitle: data.company ?? "--",
        adSubTitle: data.description,
        adMediaUrl: data.cover,
        bodyText: data.cta,
        adWebsite: data.domain,
        onClickUrl: data.targetUrl,
        advertiserName: data.owner.name,
        advertiserUsername: data.owner.username,
        advertiserProfileUrl: data.owner.avatar,
        isVerified: data.owner.id == 1 ? true : false,
        time: data.time);
  }
}
