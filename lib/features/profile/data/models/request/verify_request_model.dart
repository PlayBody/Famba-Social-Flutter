import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import '../../../../../extensions.dart';

class VerifyRequestModel {
  final String message;
  final String video;
  final String fullName;

  VerifyRequestModel(
      {@required this.message, @required this.video, @required this.fullName});

  Future<HashMap<String, dynamic>> get toMap async => HashMap.from({
        "text_message": message,
        "video_message": await video.toMultiPart(),
        "full_name": fullName,
      });
}
