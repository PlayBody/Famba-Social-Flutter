import 'package:auto_route/auto_route.dart';
class ChatRequestModel{
  final String userId;
  final String offset;
  final String searchQuery;

  ChatRequestModel({
    @required this.userId,
    @required this.offset,
    this.searchQuery
});
}