import '../../../../../core/common/failure.dart';
import '../../../../feed/domain/entity/post_entity.dart';
import '../../../../feed/domain/usecase/like_unlike_use_case.dart';
import '../../../../feed/domain/usecase/repost_use_case.dart';
import '../../../../posts/domain/usecases/add_remove_bookmark_use_case.dart';
import '../../../../posts/domain/usecases/delete_post_use_case.dart';
import '../../../../posts/presentation/bloc/post_cubit.dart';
import '../../../../posts/presentation/pagination/show_likes_pagination.dart';
import '../../../data/models/request/profile_posts_model.dart';
import '../../../domain/usecase/get_profile_posts.dart';
import '../../../../search/domain/usecase/search_post_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'user_post_state.dart';

@injectable
class UserPostCubit extends PostCubit {
  final GetProfilePostsUseCase getProfilePostsUseCase;
  String userId;

  UserPostCubit(
      AddOrRemoveBookmarkUseCase addOrRemoveBookmarkUseCase,
      LikeUnlikeUseCase likeUnlikeUseCase,
      RepostUseCase repostUseCase,
      DeletePostUseCase deletePostUseCase,
      SearchPostUseCase searchPostUseCase,
      ShowLikesPagination showLikesPagination,
      this.getProfilePostsUseCase)
      : super(addOrRemoveBookmarkUseCase, likeUnlikeUseCase, repostUseCase,
            deletePostUseCase, searchPostUseCase, showLikesPagination);

  @override
  Future<Either<Failure, List<PostEntity>>> getItems(int pageKey) async =>
      await getProfilePostsUseCase(
          PostCategoryModel(pageKey.toString(), PostCategory.POSTS, userId));
}
