import '../../../../core/common/failure.dart';
import '../../../../core/common/media/media_data.dart';
import '../../../../core/common/usecase.dart';
import '../../../posts/domain/entiity/media_entity.dart';
import '../../../posts/domain/post_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadMediaUseCase extends UseCase<MediaEntity, MediaData> {
  final PostRepo postRepo;

  UploadMediaUseCase(this.postRepo);
  @override
  Future<Either<Failure, MediaEntity>> call(MediaData params) {
    return postRepo.uploadMedia(params);
  }
}
