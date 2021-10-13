import '../../../../core/common/api/api_constants.dart';
import '../../data/models/feeds_response.dart';
import '../../presentation/widgets/create_post_card.dart';
import '../../../../extensions.dart';
import '../../../messages/domain/entity/chat_entity.dart';
import '../../../profile/data/models/response/profile_posts_response.dart';

class PostMedia {
  final MediaTypeEnum mediaType;
  final String url;

  const PostMedia._({this.mediaType, this.url});

  factory PostMedia.fromChatEntity(ChatEntity chatEntity) {
    return PostMedia._(
        url: chatEntity.profileUrl, mediaType: MediaTypeEnum.IMAGE);
  }
  factory PostMedia.fromFeed(FeedMedia media) {
    return PostMedia._(
        mediaType: media.src.getMediaType, url: _makeValidUrl(media.src));
  }

  factory PostMedia.fromProfilePostMedia(ProfilePostMedia media) {
    return PostMedia._(
        mediaType: media.src.getMediaType, url: _makeValidUrl(media.src));
  }
  static String _makeValidUrl(String url) {
    if (!url.contains("https")) {
      return ApiConstants.baseMediaUrl + url;
    }
    return url;
  }
}
