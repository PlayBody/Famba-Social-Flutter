import 'dart:collection';

import '../../../../core/common/api/api_constants.dart';
import '../../../../core/common/api/api_helper.dart';
import '../../../../core/common/failure.dart';
import '../../../../core/datasource/local_data_source.dart';
import '../models/request/chat_request_model.dart';
import '../models/request/messages_request_model.dart';
import '../models/response/chats_response.dart';
import '../models/response/messages_response.dart';
import '../models/request/delete_chat_request_model.dart';
import '../models/response/send_message_response.dart';
import '../../domain/entity/chat_entity.dart';
import '../../domain/entity/message_entity.dart';
import '../../domain/repo/message_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: MessageRepo)
class MessageRepoImpl extends MessageRepo {
  final ApiHelper apiHelper;
  final LocalDataSource localDataSource;
  MessageRepoImpl(this.apiHelper, this.localDataSource);
  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages() async {
    // var userData = localDataSource.getUserData();
    var either = await apiHelper.get(ApiConstants.getMessages);
    return either.fold((l) => left(l), (r) {
      var messages = MessagesResponse.fromJson(r.data).data;
      return right(messages.map((e) => MessageEntity.fromResponse(e)).toList());
    });
  }

  @override
  Future<Either<Failure, dynamic>> deleteAllMessages(
          DeleteChatRequestModel model) async =>
      await apiHelper.post(ApiConstants.deleteAllMessages, model.toMap);

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats(
      ChatRequestModel chatRequestModel) async {
    final either = await apiHelper.get(ApiConstants.getChatMessages,
        queryParameters: HashMap.from({
          "user_id": chatRequestModel.userId,
          "offset_up": chatRequestModel.offset,
          "page_size": ApiConstants.pageSize.toString(),
          // "page_size":100,
        }));
    return either.fold((l) => left(l), (r) {
      final chatsResponse = ChatsResponse.fromJson(r.data);
      return right(
          chatsResponse.data.map((e) => ChatEntity.fromResponse(e)).toList());
    });
  }

  @override
  Future<Either<Failure, SendMessageResponse>> sendMessage(
      MessagesRequestModel model) async {
    // if there is image in message then create map with multipart
    // else get map without multipart
    var map =
        model.mediaUrl.isNotEmpty ? await model.toMapWithImage() : model.toMap;
    var either = await apiHelper.post(ApiConstants.sendMessage, map);
    return either.fold(
        (l) => left(l), (r) => right(SendMessageResponse.fromJson(r.data)));
  }

  @override
  Future<Either<Failure, dynamic>> deleteMessage(String messageId) async {
    return await apiHelper.post(
        ApiConstants.deleteMessage, HashMap.from({"message_id": messageId}));
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> searchMessage(
      ChatRequestModel chatRequestModel) async {
    final either = await apiHelper.get(ApiConstants.searchMessage,
        queryParameters: HashMap.from({
          "user_id": chatRequestModel.userId,
          "offset_up": int.parse(chatRequestModel.offset),
          "page_size": ApiConstants.pageSize.toString(),
          "query": chatRequestModel.searchQuery
        }));
    return either.fold((l) => left(l), (r) {
      final chatsResponse = ChatsResponse.fromJson(r.data);
      return right(chatsResponse.data
          .map((e) => ChatEntity.fromResponse(e))
          .toList()
          .reversed
          .toList());
    });
  }
}
