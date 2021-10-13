import 'dart:collection';

import '../../../../core/common/api/api_constants.dart';
import '../../../../core/common/api/api_helper.dart';
import '../../../../core/common/failure.dart';
import '../../../../core/common/pagination/text_model_with_offset.dart';

import '../../../feed/domain/entity/post_entity.dart';
import '../models/hashtags_response.dart';
import '../models/people_response.dart';
import '../models/search_post_response.dart';
import '../../domain/entity/people_entity.dart';
import '../../domain/entity/hashtag_entity.dart';
import '../../domain/repo/search_repo.dart';
import '../../../../main.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchRepo)
class SearchRepoImpl extends SearchRepo {
  final ApiHelper apiHelper;

  SearchRepoImpl(this.apiHelper);
  @override
  Future<Either<Failure, List<HashTagEntity>>> searchHashtag(
      TextModelWithOffset model) async {
    HashMap<String, String> map = HashMap.from({
      "query": model.queryText,
      "offset": model.offset,
      "page_size": ApiConstants.pageSize.toString()
    });
    var either =
        await apiHelper.get(ApiConstants.searchHashtags, queryParameters: map);
    return either.fold((l) => left(l), (r) {
      var hashtagResponse = HashtagResponse.fromJson(r.data);
      return right(hashtagResponse.data
          .map((e) => HashTagEntity.fromHashTag(e))
          .toList());
    });
  }

  @override
  Future<Either<Failure, List<PeopleEntity>>> searchPeople(
    TextModelWithOffset model,
  ) async {
    var loginResponse = await localDataSource.getUserData();
    HashMap<String, String> map = HashMap.from({
      "query": model.queryText,
      "offset": model.offset,
      "page_size": ApiConstants.pageSize.toString()
    });
    var either =
        await apiHelper.get(ApiConstants.searchPeople, queryParameters: map);
    return either.fold(
      (l) => left(l),
      (r) {
        final PeopleResponse hashtagResponse = PeopleResponse.fromJson(r.data);
        print(hashtagResponse);
        return right(hashtagResponse.data
            .map(
              (e) => PeopleEntity.fromPeopleModel(
                e,
                loginResponse.data.user.userId == e.id,
              ),
            )
            .toList());
      },
    );
  }

  @override
  Future<Either<Failure, List<PostEntity>>> searchPosts(
      TextModelWithOffset model) async {
    HashMap<String, String> map = HashMap.from({
      "query": model.queryText,
      "offset": model.offset,
      "page_size": ApiConstants.pageSize.toString()
    });
    var either =
        await apiHelper.get(ApiConstants.searchPosts, queryParameters: map);
    return either.fold((l) => left(l), (r) {
      var postsResponse = SearcPostsResponse.fromJson(r.data);
      return right(
          postsResponse.data.map((e) => PostEntity.fromFeed(e)).toList());
    });
  }
}
