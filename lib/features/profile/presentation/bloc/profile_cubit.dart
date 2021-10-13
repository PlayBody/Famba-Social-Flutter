import 'package:bloc/bloc.dart';
import 'package:colibri/core/datasource/local_data_source.dart';
import 'package:colibri/core/di/injection.dart';
import '../../domain/entity/report_profile_entity.dart';
import '../../domain/usecase/report_profile_use_case.dart';
import '../../../../core/common/uistate/common_ui_state.dart';
import '../../../posts/domain/usecases/log_out_use_case.dart';
import '../../domain/entity/profile_entity.dart';
import '../../domain/usecase/follow_unfollow_use_case.dart';
import '../../domain/usecase/get_profile_data_use_case.dart';
import '../../domain/usecase/update_profile_cover_use_case.dart';
import '../../domain/usecase/uppdate_profile_avatar_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<CommonUIState> {
  final _profileEntityController = BehaviorSubject<ProfileEntity>();
  final _localDataSource = getIt<LocalDataSource>();
  Function(ProfileEntity) get changeProfileEntity =>
      _profileEntityController.sink.add;

  Stream<ProfileEntity> get profileEntity => _profileEntityController.stream;

  // use cases
  final GetProfileUseCase _getProfileUseCase;

  final FollowUnFollowUseCase followUnFollowUseCase;

  final LogOutUseCase logOutUseCase;

  final UpdateProfileCoverUseCase _updateProfileCoverUseCase;

  final UpdateAvatarProfileUseCase _updateAvatarProfileUseCase;

  final ReportProfileUseCase _reportProfileUseCase;

  bool isPrivateUser = false;

  ProfileCubit(
    this._getProfileUseCase,
    // this.mediaPagination,
    // this.profileLikesPagination,
    this.followUnFollowUseCase,
    this.logOutUseCase,
    this._updateProfileCoverUseCase,
    this._updateAvatarProfileUseCase,
    this._reportProfileUseCase,
  ) : super(const CommonUIState.initial());

  getUserProfile(String userId, String coverUrl, String profileUrl) async {
    emit(const CommonUIState.loading());
    final either = await _getProfileUseCase(userId);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) {
      final profileEntity = r.copyWith(
        profileUrl: profileUrl,
        coverUrl: coverUrl,
      );
      changeProfileEntity(profileEntity);
      emit(CommonUIState.success(profileEntity));
    });
  }

  followUnFollow() async {
    var item = _profileEntityController.value;
    await followUnFollowUseCase(item.id);
    changeProfileEntity(item.copyWith(isFollowing: !item.isFollowing));
  }

  updateProfileCover(String imagePath) async {
    emit(const CommonUIState.loading());
    var either = await _updateProfileCoverUseCase(imagePath);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)),
        (r) => emit(CommonUIState.success(r)));
  }

  updateProfileAvatar(String imagePath) async {
    emit(const CommonUIState.loading());
    var either = await _updateAvatarProfileUseCase(imagePath);

    either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) async {
      final _newModel = _localDataSource.getUserData()
        ..data.user.profilePicture = imagePath;
      await _localDataSource.saveUserData(_newModel);
      emit(CommonUIState.success(r));
    });
  }

  logoutUser() async {
    var either = await logOutUseCase(unit);
    either.fold((l) => null, (r) => null);
  }

  reportProfile(ReportProfileEntity reportProfileEntity) async {
    final either = await _reportProfileUseCase(reportProfileEntity);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)),
        (r) => emit(CommonUIState.success(r)));
  }
}
