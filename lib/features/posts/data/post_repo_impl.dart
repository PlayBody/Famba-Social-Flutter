import 'dart:collection';

import 'package:colibri/features/feed/domain/usecase/vote_poll_use_case.dart';

import '../../../core/common/api/api_constants.dart';
import '../../../core/common/api/api_helper.dart';
import '../../../core/common/failure.dart';
import '../../../core/common/media/media_data.dart';
import '../../../core/datasource/local_data_source.dart';
import '../../feed/data/models/request/post_request_model.dart';
import '../../feed/presentation/widgets/create_post_card.dart';
import 'model/response/likes_response.dart';
import '../domain/entiity/media_entity.dart';
import '../domain/post_repo.dart';
import '../../search/domain/entity/people_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'model/response/media_upload_response.dart';
import 'model/response/post_detail_response.dart';
import 'model/request/like_request_model.dart';

@Injectable(as: PostRepo)
class PostRepoImpl extends PostRepo {
  final ApiHelper apiHelper;
  final LocalDataSource localDataSource;
  PostRepoImpl(this.apiHelper, this.localDataSource);
  @override
  Future<Either<Failure, dynamic>> deletePost(String postId) async {
    var either = await apiHelper.post(
        ApiConstants.deletePost, HashMap.from({"post_id": postId}));
    return either;
  }

  @override
  Future<Either<Failure, dynamic>> likeUnlikePost(String postId) async {
    var either = await apiHelper.post(
        ApiConstants.likePost, HashMap.from({"post_id": postId}));
    return either;
  }

  @override
  Future<Either<Failure, dynamic>> repost(String postId) async =>
      await apiHelper.post(
          ApiConstants.publicationRepost, HashMap.from({"post_id": postId}));

  @override
  Future<Either<Failure, MediaEntity>> uploadMedia(MediaData mediaData) async {
    final mimeTypeData =
        lookupMimeType(mediaData.path, headerBytes: [0xFF, 0xD8]).split('/');
    var multipartFile = await MultipartFile.fromFile(mediaData.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    HashMap<String, Object> body = HashMap();
    body.addAll({
      "type": mediaData.type == MediaTypeEnum.VIDEO ? "video" : "image",
      "file": multipartFile
    });
    var either = await apiHelper.post(ApiConstants.uploadPostMedia, body);
    return either.fold(
        (l) => left(l),
        (r) => right(MediaEntity.fromResponse(
            MediaUploadResponse.fromJson(r.data).data)));
  }

  @override
  Future<Either<Failure, dynamic>> createPost(
    PostRequestModel postRequestModel,
  ) async {
    print(":vishal test data ${postRequestModel.toMap()}");

    var either = await apiHelper.post(
      ApiConstants.publishPost,
      postRequestModel.toMap(),
    );

    print(":vishal test data $either");

    return either;
  }

  @override
  Future<Either<Failure, dynamic>> deleteMedia(MediaEntity mediaEntity) async {
    var map = HashMap<String, dynamic>.from({
      "media_id": mediaEntity.mediaId,
      "type":
          mediaEntity.mediaTypeEnum == MediaTypeEnum.VIDEO ? "video" : "image",
    });
    return await apiHelper.post(ApiConstants.deletePostMedia, map);
  }

  @override
  Future<Either<Failure, dynamic>> addOrRemoveBookMark(String postId) async {
    var either = await apiHelper.post(
        ApiConstants.addBookmark, HashMap.from({"post_id": postId}));
    return either;
  }

  @override
  Future<Either<Failure, List<PeopleEntity>>> getPostLikes(
      LikesRequestModel model) async {
    var loginResponse = await localDataSource.getUserData();
    var map = {
      "post_id": model.postId,
      "page_size": ApiConstants.pageSize,
      "offset": model.offsetId,
    };
    // if(model.offSetId!=null)map.addAll({"offset":model.offSetId.toString()});
    var either =
        await apiHelper.get(ApiConstants.fetchLikes, queryParameters: map);
    return either.fold(
        (l) => left(l),
        (r) => right(PostLikesResponse.fromJson(r.data)
            .data
            .map((e) => PeopleEntity.fromLikesResponse(
                e, loginResponse.data.user.userId == e.id))
            .toList()));
  }

  @override
  Future<Either<Failure, PostDetailResponse>> getThreadedPost(
      String postId) async {
    var either = await apiHelper.get(ApiConstants.threadData,
        queryParameters: HashMap.from({"thread_id": postId}));
    return either.fold(
        (l) => left(l), (r) => right(PostDetailResponse.fromJson(r.data)));
  }

  @override
  Future<Either<Failure, dynamic>> votePoll(PollParam pollParam) async {
    final either = await apiHelper.post(
      ApiConstants.votePolls,
      HashMap.from(
        {
          'post_id': pollParam.postId,
          'poll_id': pollParam.pollId,
        },
      ),
    );
    return either;
  }
}
