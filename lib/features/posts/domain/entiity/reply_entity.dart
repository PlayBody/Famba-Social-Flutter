import 'package:auto_route/auto_route.dart';
import '../../../feed/domain/entity/post_entity.dart';
import '../../../feed/domain/entity/post_media.dart';

class ReplyEntity {
  final String name;

  final String time;
  final String description;
  final String id;
  final String profileUrl;
  // we can have more than one username
  final String username1;
  final String username2;

  final String loggedUserProfileUrl;

  final List<PostMedia> items;

  ReplyEntity._(
      {@required this.name,
      @required this.time,
      @required this.description,
      @required this.id,
      @required this.profileUrl,
      @required this.username1,
      @required this.username2,
      @required this.loggedUserProfileUrl,
      this.items = const []});

  factory ReplyEntity.fromPostEntity({@required PostEntity postEntity}) =>
      ReplyEntity._(
          time: postEntity.time,
          description: postEntity.description,
          id: postEntity.postId,
          profileUrl: postEntity.profileUrl,
          username1: postEntity.userName,
          username2: postEntity.parentPostUsername ?? "",
          loggedUserProfileUrl: postEntity.profileUrl,
          name: postEntity.name,
          items: postEntity.media);
}
