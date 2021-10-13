import '../../../../core/routes/routes.gr.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'all_home_screens.freezed.dart';

@freezed
abstract class ScreenType with _$ScreenType {
  const factory ScreenType.home() = Home;
  const factory ScreenType.message() = Message;
  const factory ScreenType.notification() = Notification;
  const factory ScreenType.search() = Search;
  const factory ScreenType.profile(ProfileScreenArguments arguments) = Profile;
  const factory ScreenType.settings(bool fromProfile) = Settings;
  const factory ScreenType.bookmarks() = BookMarks;
}
