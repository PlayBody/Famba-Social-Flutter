import '../entity/report_profile_entity.dart';

import '../../../../core/common/failure.dart';
import '../../../feed/domain/entity/post_entity.dart';
import '../../data/models/request/profile_posts_model.dart';
import '../../data/models/request/update_password_request.dart';
import '../../data/models/request/update_setting_request_model.dart';
import '../../data/models/request/verify_request_model.dart';
import '../entity/follower_entity.dart';
import '../entity/profile_entity.dart';
import '../entity/setting_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ProfileEntity>> getProfileData(String userId);

  Future<Either<Failure, List<PostEntity>>> getUserPostByCategory(
      PostCategoryModel model);

  Future<Either<Failure, List<PostEntity>>> getBookmarks(String offsetId);

  Future<Either<Failure, List<FollowerEntity>>> getFollower(
      PostCategoryModel model);

  Future<Either<Failure, List<FollowerEntity>>> getFollowing(
      PostCategoryModel model);

  Future<Either<Failure, dynamic>> followUnFollow(String userId);

  Future<Either<Failure, SettingEntity>> getUserSettings();

  Future<Either<Failure, AccountPrivacyEntity>> getUserPrivacySettings();

  Future<Either<Failure, dynamic>> updateUserSetting(
    UpdateSettingsRequestModel model,
  );

  Future<Either<Failure, dynamic>> updatePassword(UpdatePasswordRequest model);

  Future<Either<Failure, dynamic>> updatePrivacy(AccountPrivacyEntity model);

  Future<Either<Failure, dynamic>> logOutUser();

  Future<Either<Failure, dynamic>> deleteAccount(String password);

  Future<Either<Failure, dynamic>> verifyUserAccount(VerifyRequestModel model);

  Future<Either<Failure, String>> changeLanguage(String lang);

  Future<Either<Failure, String>> updateAvatar(String lang);

  Future<Either<Failure, String>> updateCover(String lang);

  Future<Either<Failure, bool>> getLoginMode();

  Future<Either<Failure, dynamic>> reportProfile(
      ReportProfileEntity profileEntity);
}
