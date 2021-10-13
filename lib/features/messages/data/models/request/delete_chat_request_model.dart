import 'dart:collection';

class DeleteChatRequestModel{


  DeleteChatRequestModel({this.userId, this.deleteChat=false});

  final String userId;
  // ​Delete chat after clearing	E.g. One of these options (1/0)
  // 1 will will also delete user from the messages list
  // 0 will only delete chat history with the current user
  final bool deleteChat;

  HashMap<String,String> get toMap=>HashMap.from({
    "user_id":userId,
    "delete_chat":deleteChat?"1":"0",
  });

}