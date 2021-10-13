import 'dart:collection';

import 'package:auto_route/auto_route.dart';
import '../../../../../extensions.dart';

class MessagesRequestModel {
  final String userId;
  final String type;
  final String message;
  final String mediaUrl;

  const MessagesRequestModel(
      {@required this.userId,
      @required this.type,
      @required this.message,
      this.mediaUrl = ''});

  HashMap<String, dynamic> get toMap => HashMap.from({
        "user_id": userId,
        "type": type,
        // "image": mediaUrl,
        "message": message,
      });
  Future<HashMap<String, dynamic>> toMapWithImage() async {
    return HashMap.from({
      "user_id": userId,
      "type": type,
      "image": await mediaUrl.toMultiPart(),
    });
  }
}
