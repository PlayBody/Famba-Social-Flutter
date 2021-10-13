import 'package:auto_route/auto_route.dart';
import '../../../../core/common/media/media_data.dart';
import '../../../feed/presentation/widgets/create_post_card.dart';
import '../../data/model/response/media_upload_response.dart';
import '../../../../extensions.dart';

class MediaEntity {
  final String mediaId;
  final String mediaUrl;
  final MediaTypeEnum mediaTypeEnum;
  MediaEntity._({
    @required this.mediaId,
    @required this.mediaUrl,
    @required this.mediaTypeEnum,
  });

  factory MediaEntity.fromResponse(MediaItem mediaItem) => MediaEntity._(
      mediaId: mediaItem.mediaId.toString(),
      mediaUrl: mediaItem.url,
      mediaTypeEnum: mediaItem.url.getMediaType);

  factory MediaEntity.fromMediaData(MediaData mediaData) => MediaEntity._(
      mediaId: mediaData.id.toString(),
      mediaUrl: mediaData.path,
      mediaTypeEnum: mediaData.path.getMediaType);
}
