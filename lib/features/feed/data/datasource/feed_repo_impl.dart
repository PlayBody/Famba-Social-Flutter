import 'dart:collection';
import 'dart:io';
import '../../domain/entity/report_post_entity.dart';

import '../../../../core/common/api/api_constants.dart';
import '../../../../core/common/api/api_helper.dart';
import '../../../../core/common/failure.dart';
import '../../../../core/datasource/local_data_source.dart';
import '../models/feeds_response.dart';
import '../../domain/entity/post_entity.dart';
import '../../domain/repo/feed_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: FeedRepo)
class FeedRepoImpl extends FeedRepo {
  final ApiHelper apiHelper;
  final LocalDataSource localDataSource;
  // int requestCount=0;
  FeedRepoImpl(this.apiHelper, this.localDataSource);

  @override
  Future<Either<Failure, List<PostEntity>>> getFeeds(String pageKey) async {
    print("fetching apis");
    // requestCount=requestCount+1;
    var queryMap = {"page_size": ApiConstants.pageSize.toString()};
    if (pageKey != null && pageKey.isNotEmpty && pageKey != "0")
      queryMap.addAll({"offset": pageKey});
    var response =
        await apiHelper.get(ApiConstants.feeds, queryParameters: queryMap);
    return response.fold((l) => left(l), (r) {
      return right(FeedResponse.fromJson(r.data)
          .data
          .feeds
          .map((e) =>
              PostEntity.fromFeed(e).copyWith(parentPostUsername: e.username))
          .toList());
    });
    // map every feed item to postEntity
  }

  @override
  // ignore: missing_return
  Future<Either<Failure, List<PostEntity>>> saveNotificationToken() async {
    if (await localDataSource.isUserLoggedIn()) {
      final pushToken = await localDataSource.getPushToken();
      await apiHelper.post(
        ApiConstants.saveNotificationToken,
        HashMap.from(
          {"token": pushToken, "type": Platform.isAndroid ? "android" : "ios"},
        ),
      );
    }
  }

  @override
  Future<Either<Failure, dynamic>> reportPost(ReportPostEntity param) async =>
      await apiHelper.post(
          ApiConstants.reportPost, HashMap.from(param.toJson()));
}
