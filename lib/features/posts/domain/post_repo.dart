import 'package:colibri/features/feed/domain/usecase/vote_poll_use_case.dart';

import '../../../core/common/failure.dart';
import '../../../core/common/media/media_data.dart';
import '../../feed/data/models/request/post_request_model.dart';
import '../data/model/response/post_detail_response.dart';
import '../data/model/request/like_request_model.dart';
import '../../search/domain/entity/people_entity.dart';
import 'package:dartz/dartz.dart';

import 'entiity/media_entity.dart';

abstract class PostRepo {
  Future<Either<Failure, dynamic>> likeUnlikePost(String postId);
  Future<Either<Failure, dynamic>> repost(String postId);
  Future<Either<Failure, dynamic>> deletePost(String postId);
  Future<Either<Failure, MediaEntity>> uploadMedia(MediaData mediaData);
  Future<Either<Failure, dynamic>> deleteMedia(MediaEntity mediaEntity);
  Future<Either<Failure, dynamic>> createPost(PostRequestModel mediaData);
  Future<Either<Failure, dynamic>> addOrRemoveBookMark(String postId);
  Future<Either<Failure, List<PeopleEntity>>> getPostLikes(
      LikesRequestModel model);
  Future<Either<Failure, PostDetailResponse>> getThreadedPost(String postId);
  Future<Either<Failure, dynamic>> votePoll(PollParam pollParam);
}
