import '../../../../core/common/failure.dart';
import '../../data/models/request/chat_request_model.dart';
import '../../data/models/request/messages_request_model.dart';
import '../../data/models/request/delete_chat_request_model.dart';
import '../../data/models/response/send_message_response.dart';
import '../entity/chat_entity.dart';
import '../entity/message_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MessageRepo {
  Future<Either<Failure, List<MessageEntity>>> getMessages();
  Future<Either<Failure, dynamic>> deleteAllMessages(
      DeleteChatRequestModel model);
  Future<Either<Failure, List<ChatEntity>>> getChats(
      ChatRequestModel chatRequestModel);
  Future<Either<Failure, SendMessageResponse>> sendMessage(
      MessagesRequestModel model);
  Future<Either<Failure, dynamic>> deleteMessage(String messageId);
  Future<Either<Failure, List<ChatEntity>>> searchMessage(
      ChatRequestModel chatRequestModel);
}
