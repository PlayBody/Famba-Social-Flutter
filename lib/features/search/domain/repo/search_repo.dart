import '../../../../core/common/failure.dart';
import '../../../../core/common/pagination/text_model_with_offset.dart';
import '../../../feed/domain/entity/post_entity.dart';
import '../entity/people_entity.dart';
import '../entity/hashtag_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SearchRepo {
  Future<Either<Failure, List<HashTagEntity>>> searchHashtag(
      TextModelWithOffset model);
  Future<Either<Failure, List<PeopleEntity>>> searchPeople(
      TextModelWithOffset model);
  Future<Either<Failure, List<PostEntity>>> searchPosts(
      TextModelWithOffset model);
}
