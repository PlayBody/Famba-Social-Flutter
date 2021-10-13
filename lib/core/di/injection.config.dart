// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:colibri/features/feed/domain/usecase/report_post_use_case.dart';
import 'package:colibri/features/profile/domain/usecase/report_profile_use_case.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/posts/domain/usecases/add_remove_bookmark_use_case.dart';
import '../common/api/api_helper.dart';
import '../../features/authentication/domain/repo/auth_repo.dart';
import '../../features/authentication/data/datasource/auth_repo_impl.dart';
import '../../features/profile/presentation/bloc/bookmark_cubit.dart';
import '../../features/profile/domain/usecase/change_language_use_case.dart';
import '../../features/messages/presentation/bloc/chat_cubit.dart';
import '../../features/messages/presentation/chat_pagination.dart';
import '../../features/posts/presentation/bloc/createpost_cubit.dart';
import '../../features/feed/domain/usecase/create_post_use_case.dart';
import '../../features/profile/domain/usecase/delete_account_use_case.dart';
import '../../features/messages/domain/usecase/delete_all_messages_use_case.dart';
import '../../features/posts/domain/usecases/delete_media_use_case.dart';
import '../../features/messages/domain/usecase/delete_messag_use_case.dart';
import '../../features/notifications/domain/usecase/delete_notification_use_case.dart';
import '../../features/posts/domain/usecases/delete_post_use_case.dart';
import '../../features/feed/presentation/bloc/feed_cubit.dart';
import '../../features/feed/domain/repo/feed_repo.dart';
import '../../features/feed/data/datasource/feed_repo_impl.dart';
import '../../features/profile/domain/usecase/follow_unfollow_use_case.dart';
import '../../features/profile/presentation/pagination/followers/follower_pagination.dart';
import '../../features/profile/presentation/bloc/followers_following_cubit.dart';
import '../../features/profile/presentation/pagination/following/following_pagination.dart';
import '../../features/profile/domain/usecase/get_bookmarks_use_case.dart';
import '../../features/messages/domain/usecase/get_chats_use_case.dart';
import '../../features/feed/domain/usecase/get_drawer_data_use_case.dart';
import '../../features/feed/domain/usecase/get_feed_posts_use_case.dart';
import '../../features/posts/domain/usecases/get_followers_use_case.dart';
import '../../features/profile/domain/usecase/get_followers_use_case.dart'
    as colibri;
import '../../features/profile/domain/usecase/get_following_use_case.dart';
import '../../features/posts/domain/usecases/get_likes_use_case.dart';
import '../../features/profile/domain/usecase/get_login_mode.dart';
import '../../features/messages/domain/usecase/get_messages_use_case.dart';
import '../../features/notifications/domain/usecase/get_notification_use_case.dart';
import '../../features/profile/domain/usecase/get_profile_like_posts.dart';
import '../../features/profile/domain/usecase/get_profile_media_posts.dart';
import '../../features/profile/domain/usecase/get_profile_posts.dart';
import '../../features/profile/domain/usecase/get_profile_data_use_case.dart';
import '../../features/posts/domain/usecases/get_threaded_post_use_case.dart';
import '../../features/profile/domain/usecase/get_user_settings.dart';
import '../../features/search/presentation/pagination/hashtag_pagination.dart';
import '../../features/feed/domain/usecase/like_unlike_use_case.dart';
import '../datasource/local_data_source.dart';
import '../../features/posts/domain/usecases/log_out_use_case.dart';
import '../../features/authentication/presentation/bloc/login_cubit.dart';
import '../../features/authentication/domain/usecase/login_use_case.dart';
import '../../features/notifications/presentation/pagination/mentions_pagination.dart';
import '../../features/messages/presentation/bloc/message_cubit.dart';
import '../../features/messages/domain/repo/message_repo.dart';
import '../../features/messages/data/repo_impl/message_repo_impl.dart';
import '../common/social_share/social_share.dart';
import '../../features/notifications/presentation/bloc/notification_cubit.dart';
import '../../features/notifications/presentation/pagination/notification_pagination.dart';
import '../../features/notifications/domain/repo/notification_repo.dart';
import '../../features/notifications/data/repo_impl/notification_repo_impl.dart';
import '../../features/search/presentation/pagination/people_pagination.dart';
import '../../features/posts/presentation/bloc/post_cubit.dart';
import '../../features/posts/domain/post_repo.dart';
import '../../features/posts/data/post_repo_impl.dart';
import '../../features/profile/presentation/bloc/profile_cubit.dart';
import '../../features/profile/presentation/pagination/likes/likes_pagination.dart';
import '../../features/profile/presentation/pagination/media/media_pagination.dart';
import '../../features/profile/presentation/pagination/posts/post_pagination.dart';
import '../../features/profile/domain/repo/profile_repo.dart';
import '../../features/profile/data/datasource/profile_repo_impl.dart';
import 'register_module.dart';
import '../../features/feed/domain/usecase/repost_use_case.dart';
import '../../features/authentication/presentation/bloc/reset_password_cubit.dart';
import '../../features/authentication/domain/usecase/reset_password_use_case.dart';
import '../../features/feed/domain/usecase/save_notification_token_use_case.dart';
import '../../features/messages/domain/usecase/search_chats_use_case.dart';
import '../../features/search/presentation/bloc/search_cubit.dart';
import '../../features/search/domain/usecase/search_hastag_use_case.dart';
import '../../features/search/domain/usecase/search_people_use_case.dart';
import '../../features/search/domain/usecase/search_post_use_case.dart';
import '../../features/search/domain/repo/search_repo.dart';
import '../../features/search/data/repo_impl/search_repo_impl.dart';
import '../../features/messages/domain/usecase/send_chat_message_use_case.dart';
import '../../features/posts/presentation/pagination/show_likes_pagination.dart';
import '../../features/authentication/presentation/bloc/sign_up_cubit.dart';
import '../../features/authentication/domain/usecase/sign_up_case.dart';
import '../../features/authentication/domain/usecase/social_login_use_case.dart';
import '../../features/profile/domain/usecase/uppdate_profile_avatar_use_case.dart';
import '../../features/profile/domain/usecase/udpate_password_use_case.dart';
import '../../features/profile/domain/usecase/update_privacy_setting_use_case.dart';
import '../../features/profile/domain/usecase/update_profile_cover_use_case.dart';
import '../../features/profile/domain/usecase/update_profile_setting_use_case.dart';
import '../common/api/upload_manager.dart';
import '../../features/feed/domain/usecase/upload_media_use_case.dart';
import '../../features/profile/presentation/bloc/user_likes/user_likes_cubit.dart';
import '../../features/profile/presentation/bloc/user_media/user_media_cubit.dart';
import '../../features/profile/presentation/bloc/user_posts/user_post_cubit.dart';
import '../../features/profile/presentation/bloc/settings/user_setting_cubit.dart';
import '../../features/profile/domain/usecase/verify_user_account_use_case.dart';
import '../../features/posts/presentation/bloc/view_post_cubit.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

Future<GetIt> $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) async {
  final gh = GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingleton<Dio>(() => registerModule.dio);
  gh.lazySingleton<GoogleSignIn>(() => registerModule.googleLogin);
  gh.factory<MySocialShare>(() => MySocialShare());
  final sharedPreferences = await registerModule.storage;
  gh.factory<SharedPreferences>(() => sharedPreferences);
  gh.factory<LocalDataSource>(
      () => LocalDataSourceImpl(get<Dio>(), get<SharedPreferences>()));
  gh.factory<UploadManager>(() => UploadManager(get<LocalDataSource>()));
  gh.factory<ApiHelper>(() => ApiHelper(get<LocalDataSource>()));
  gh.factory<FeedRepo>(
      () => FeedRepoImpl(get<ApiHelper>(), get<LocalDataSource>()));
  gh.factory<GetFeedPostUseCase>(() => GetFeedPostUseCase(get<FeedRepo>()));
  gh.factory<LoginUseCase>(() => LoginUseCase(get<AuthRepo>()));
  gh.factory<MessageRepo>(
      () => MessageRepoImpl(get<ApiHelper>(), get<LocalDataSource>()));
  gh.factory<NotificationRepo>(() => NotificationRepoImpl(get<ApiHelper>()));
  gh.factory<PostRepo>(
      () => PostRepoImpl(get<ApiHelper>(), get<LocalDataSource>()));
  gh.factory<ProfileRepo>(() => ProfileRepoImpl(
        get<ApiHelper>(),
        get<LocalDataSource>(),
        get<GoogleSignIn>(),
      ));
  gh.factory<RepostUseCase>(() => RepostUseCase(get<PostRepo>()));
  gh.factory<ResetPasswordUseCase>(() => ResetPasswordUseCase(get<AuthRepo>()));
  gh.factory<SaveNotificationPushUseCase>(
      () => SaveNotificationPushUseCase(get<FeedRepo>()));
  gh.factory<SearchChatUseCase>(() => SearchChatUseCase(get<MessageRepo>()));
  gh.factory<SearchRepo>(() => SearchRepoImpl(get<ApiHelper>()));
  gh.factory<SendChatMessageUseCase>(
      () => SendChatMessageUseCase(get<MessageRepo>()));
  gh.factory<SignUpUseCase>(() => SignUpUseCase(get<AuthRepo>()));
  gh.factory<SocialLoginUseCase>(() => SocialLoginUseCase(get<AuthRepo>()));
  gh.factory<UpdateAvatarProfileUseCase>(
      () => UpdateAvatarProfileUseCase(get<ProfileRepo>()));
  gh.factory<ReportProfileUseCase>(
      () => ReportProfileUseCase(get<ProfileRepo>()));
  gh.factory<UpdatePasswordUseCase>(
      () => UpdatePasswordUseCase(get<ProfileRepo>()));
  gh.factory<UpdatePrivacyUseCase>(
      () => UpdatePrivacyUseCase(get<ProfileRepo>()));
  gh.factory<UpdateProfileCoverUseCase>(
      () => UpdateProfileCoverUseCase(get<ProfileRepo>()));
  gh.factory<UpdateUserSettingsUseCase>(
      () => UpdateUserSettingsUseCase(get<ProfileRepo>()));
  gh.factory<UploadMediaUseCase>(() => UploadMediaUseCase(get<PostRepo>()));
  gh.factory<VerifyUserAccountUseCase>(
      () => VerifyUserAccountUseCase(get<ProfileRepo>()));
  gh.factory<AddOrRemoveBookmarkUseCase>(
      () => AddOrRemoveBookmarkUseCase(get<PostRepo>()));
  gh.factory<ChangeLanguageUseCase>(
      () => ChangeLanguageUseCase(get<ProfileRepo>()));
  gh.factory<CreatePostUseCase>(() => CreatePostUseCase(get<PostRepo>()));
  gh.factory<DeleteAccountUseCase>(
      () => DeleteAccountUseCase(get<ProfileRepo>()));
  gh.factory<DeleteAllMessagesUseCase>(
      () => DeleteAllMessagesUseCase(get<MessageRepo>()));
  gh.factory<DeleteMediaUseCase>(() => DeleteMediaUseCase(get<PostRepo>()));
  gh.factory<DeleteMessageUseCase>(
      () => DeleteMessageUseCase(get<MessageRepo>()));
  gh.factory<DeleteNotificationUseCase>(
      () => DeleteNotificationUseCase(get<NotificationRepo>()));
  gh.factory<DeletePostUseCase>(() => DeletePostUseCase(get<PostRepo>()));
  gh.factory<FollowUnFollowUseCase>(
      () => FollowUnFollowUseCase(get<ProfileRepo>()));
  gh.factory<GetBookmarksUseCase>(
      () => GetBookmarksUseCase(get<ProfileRepo>()));
  gh.factory<GetChatUseCase>(() => GetChatUseCase(get<MessageRepo>()));
  gh.factory<GetDrawerDataUseCase>(
      () => GetDrawerDataUseCase(get<ProfileRepo>()));
  gh.factory<GetFollowersUseCase>(
      () => GetFollowersUseCase(get<ProfileRepo>()));
  gh.factory<colibri.GetFollowersUseCase>(
      () => colibri.GetFollowersUseCase(get<ProfileRepo>()));
  gh.factory<GetFollowingUseCase>(
      () => GetFollowingUseCase(get<ProfileRepo>()));
  gh.factory<GetLikesUseCase>(() => GetLikesUseCase(get<PostRepo>()));
  gh.factory<GetLoginMode>(() => GetLoginMode(get<ProfileRepo>()));
  gh.factory<GetMessagesUseCase>(() => GetMessagesUseCase(get<MessageRepo>()));
  gh.factory<GetNotificationUseCase>(
      () => GetNotificationUseCase(get<NotificationRepo>()));
  gh.factory<GetProfileLikedPostsUseCase>(
      () => GetProfileLikedPostsUseCase(get<ProfileRepo>()));
  gh.factory<GetProfileMediaUseCase>(
      () => GetProfileMediaUseCase(get<ProfileRepo>()));
  gh.factory<GetProfilePostsUseCase>(
      () => GetProfilePostsUseCase(get<ProfileRepo>()));
  gh.factory<GetProfileUseCase>(() => GetProfileUseCase(get<ProfileRepo>()));
  gh.factory<GetThreadedPostUseCase>(
      () => GetThreadedPostUseCase(get<PostRepo>()));
  gh.factory<GetUserSettingsUseCase>(
      () => GetUserSettingsUseCase(get<ProfileRepo>()));
  gh.factory<LikeUnlikeUseCase>(() => LikeUnlikeUseCase(get<PostRepo>()));
  gh.factory<ReportPostUseCase>(() => ReportPostUseCase(get<FeedRepo>()));
  gh.factory<LogOutUseCase>(() => LogOutUseCase(get<ProfileRepo>()));
  gh.factory<LoginCubit>(() => LoginCubit(
        get<LocalDataSource>(),
        get<LoginUseCase>(),
        get<SocialLoginUseCase>(),
      ));
  gh.factory<MentionsPagination>(() => MentionsPagination(
      get<GetNotificationUseCase>(), get<DeleteNotificationUseCase>()));
  gh.factory<MessageCubit>(() => MessageCubit(get<GetMessagesUseCase>(),
      get<DeleteAllMessagesUseCase>(), get<DeleteMessageUseCase>()));
  gh.factory<NotificationPagination>(() => NotificationPagination(
      get<GetNotificationUseCase>(), get<DeleteNotificationUseCase>()));
  gh.factory<ProfileCubit>(() => ProfileCubit(
        get<GetProfileUseCase>(),
        get<FollowUnFollowUseCase>(),
        get<LogOutUseCase>(),
        get<UpdateProfileCoverUseCase>(),
        get<UpdateAvatarProfileUseCase>(),
        get<ReportProfileUseCase>(),
      ));
  gh.factory<ProfileLikesPagination>(
      () => ProfileLikesPagination(get<GetProfileLikedPostsUseCase>()));
  gh.factory<ProfileMediaPagination>(
      () => ProfileMediaPagination(get<GetProfileMediaUseCase>()));
  gh.factory<ProfilePostPagination>(
      () => ProfilePostPagination(get<GetProfilePostsUseCase>()));
  gh.factory<ResetPasswordCubit>(
      () => ResetPasswordCubit(get<ResetPasswordUseCase>()));
  gh.factory<SearchHashtagsUseCase>(
      () => SearchHashtagsUseCase(get<SearchRepo>()));
  gh.factory<SearchPeopleUseCase>(() => SearchPeopleUseCase(get<SearchRepo>()));
  gh.factory<SearchPostUseCase>(() => SearchPostUseCase(get<SearchRepo>()));
  gh.factory<ShowLikesPagination>(() => ShowLikesPagination(
      get<GetLikesUseCase>(), get<FollowUnFollowUseCase>()));
  gh.factory<SignUpCubit>(
      () => SignUpCubit(get<SignUpUseCase>(), get<SocialLoginUseCase>()));
  gh.factory<UserLikesCubit>(() => UserLikesCubit(
        get<AddOrRemoveBookmarkUseCase>(),
        get<LikeUnlikeUseCase>(),
        get<RepostUseCase>(),
        get<DeletePostUseCase>(),
        get<SearchPostUseCase>(),
        get<GetProfileLikedPostsUseCase>(),
        get<ShowLikesPagination>(),
      ));
  gh.factory<UserMediaCubit>(() => UserMediaCubit(
        get<AddOrRemoveBookmarkUseCase>(),
        get<LikeUnlikeUseCase>(),
        get<RepostUseCase>(),
        get<DeletePostUseCase>(),
        get<SearchPostUseCase>(),
        get<ShowLikesPagination>(),
        get<GetProfileMediaUseCase>(),
      ));
  gh.factory<UserPostCubit>(() => UserPostCubit(
        get<AddOrRemoveBookmarkUseCase>(),
        get<LikeUnlikeUseCase>(),
        get<RepostUseCase>(),
        get<DeletePostUseCase>(),
        get<SearchPostUseCase>(),
        get<ShowLikesPagination>(),
        get<GetProfilePostsUseCase>(),
      ));
  gh.factory<UserSettingCubit>(() => UserSettingCubit(
        get<GetUserSettingsUseCase>(),
        get<UpdateUserSettingsUseCase>(),
        get<UpdatePasswordUseCase>(),
        get<UpdatePrivacyUseCase>(),
        get<DeleteAccountUseCase>(),
        get<VerifyUserAccountUseCase>(),
        get<ChangeLanguageUseCase>(),
        get<GetLoginMode>(),
      ));
  gh.factory<ViewPostCubit>(() => ViewPostCubit(
        get<GetThreadedPostUseCase>(),
        get<CreatePostUseCase>(),
        get<LikeUnlikeUseCase>(),
        get<RepostUseCase>(),
        get<AddOrRemoveBookmarkUseCase>(),
        get<DeletePostUseCase>(),
      ));
  gh.factory<BookmarkCubit>(() => BookmarkCubit(
        get<GetBookmarksUseCase>(),
        get<AddOrRemoveBookmarkUseCase>(),
        get<LikeUnlikeUseCase>(),
        get<RepostUseCase>(),
        get<DeletePostUseCase>(),
      ));
  gh.factory<ChatPagination>(
      () => ChatPagination(get<GetChatUseCase>(), get<SearchChatUseCase>()));
  gh.factory<CreatePostCubit>(() => CreatePostCubit(
        get<UploadMediaUseCase>(),
        get<CreatePostUseCase>(),
        get<DeleteMediaUseCase>(),
        get<GetDrawerDataUseCase>(),
      ));
  gh.factory<FeedCubit>(() => FeedCubit(
        get<GetFeedPostUseCase>(),
        get<GetDrawerDataUseCase>(),
        get<UploadMediaUseCase>(),
        get<CreatePostUseCase>(),
        get<LikeUnlikeUseCase>(),
        get<DeleteMediaUseCase>(),
        get<RepostUseCase>(),
        get<AddOrRemoveBookmarkUseCase>(),
        get<DeletePostUseCase>(),
        get<LogOutUseCase>(),
        get<SaveNotificationPushUseCase>(),
        get<ReportPostUseCase>(),
      ));
  gh.factory<FollowerPagination>(
      () => FollowerPagination(get<GetFollowersUseCase>()));
  gh.factory<FollowingPagination>(
      () => FollowingPagination(get<GetFollowingUseCase>()));
  gh.factory<HashTagPagination>(
      () => HashTagPagination(get<SearchHashtagsUseCase>()));
  gh.factory<NotificationCubit>(() => NotificationCubit(
      get<NotificationPagination>(), get<MentionsPagination>()));
  gh.factory<PeoplePagination>(
      () => PeoplePagination(get<SearchPeopleUseCase>()));
  gh.factory<PostCubit>(() => PostCubit(
        get<AddOrRemoveBookmarkUseCase>(),
        get<LikeUnlikeUseCase>(),
        get<RepostUseCase>(),
        get<DeletePostUseCase>(),
        get<SearchPostUseCase>(),
        get<ShowLikesPagination>(),
      ));
  gh.factory<SearchCubit>(() => SearchCubit(
        get<HashTagPagination>(),
        get<PeoplePagination>(),
        get<FollowUnFollowUseCase>(),
      ));
  gh.factory<ChatCubit>(() => ChatCubit(
        get<GetChatUseCase>(),
        get<HashTagPagination>(),
        get<SendChatMessageUseCase>(),
        get<DeleteMessageUseCase>(),
        get<DeleteAllMessagesUseCase>(),
        get<ChatPagination>(),
      ));
  gh.factory<FollowersFollowingCubit>(() => FollowersFollowingCubit(
        get<FollowerPagination>(),
        get<FollowingPagination>(),
        get<FollowUnFollowUseCase>(),
        get<GetProfileUseCase>(),
      ));

  // Eager singletons must be registered in the right order
  gh.singleton<AuthRepo>(AuthRepoImpl(
    get<ApiHelper>(),
    get<GoogleSignIn>(),
    get<LocalDataSource>(),
  ));
  return get;
}

class _$RegisterModule extends RegisterModule {}
