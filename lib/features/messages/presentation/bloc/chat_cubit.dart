import 'package:bloc/bloc.dart';
import '../../../../core/common/stream_validators.dart';
import '../../../../core/common/uistate/common_ui_state.dart';
import '../../data/models/request/messages_request_model.dart';
import '../../data/models/request/delete_chat_request_model.dart';
import '../../domain/entity/chat_entity.dart';
import '../../domain/usecase/delete_all_messages_use_case.dart';
import '../../domain/usecase/delete_messag_use_case.dart';
import '../../domain/usecase/get_chats_use_case.dart';
import '../../domain/usecase/send_chat_message_use_case.dart';
import '../chat_pagination.dart';
import '../../../search/presentation/pagination/hashtag_pagination.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
part 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<CommonUIState> {
  final messageController = BehaviorSubject<List<ChatEntity>>.seeded([]);
  Function(List<ChatEntity>) get changeMessageList =>
      messageController.sink.add;
  Stream<List<ChatEntity>> get messageList => messageController.stream;

  final _scrollHelperController = BehaviorSubject<bool>.seeded(true);
  Function(bool) get changeScrollValue => _scrollHelperController.sink.add;
  Stream<bool> get isScrolling => _scrollHelperController.stream;

  final searchQuery = FieldValidators(null, null);

  final message = FieldValidators(null, null);

  // use case

  final GetChatUseCase getChatUseCase;

  final SendChatMessageUseCase sendChatMessageUseCase;

  final DeleteAllMessagesUseCase deleteAllMessagesUseCase;

  final DeleteMessageUseCase deleteMessageUseCase;

  final ChatPagination chatPagination;

  final HashTagPagination hashTagPagination;

  GlobalKey<AnimatedListState> animatedKey = GlobalKey<AnimatedListState>();
  ChatCubit(
      this.getChatUseCase,
      this.hashTagPagination,
      this.sendChatMessageUseCase,
      this.deleteMessageUseCase,
      this.deleteAllMessagesUseCase,
      this.chatPagination)
      : super(const CommonUIState.success(unit)) {}

  sendMessage(String otherUserId) async {
    emit(const CommonUIState.loading());

    var messageText = ChatEntity(
        isSender: true,
        message: message.text,
        time: "a moment ago",
        messageId: null);

    var chatRequestModel = MessagesRequestModel(
        type: "text", message: message.text, userId: otherUserId);
    var either = await sendChatMessageUseCase(chatRequestModel);

    either.fold(
      (l) => emit(CommonUIState.error(l.errorMessage)),
      (r) {
        chatPagination.pagingController.itemList ??= [];
        chatPagination.pagingController..itemList.insert(0, messageText);
        emit(const CommonUIState.success(unit));
      },
    );
  }

  sendImage(String path, String otherUserId) async {
    emit(const CommonUIState.loading());
    final messageText = ChatEntity(
        messageId: null,
        isSender: true,
        profileUrl: path,
        chatMediaType: ChatMediaType.IMAGE,
        message: 'Image',
        time: "a moment ago");

    var chatRequestModel = MessagesRequestModel(
        type: "media",
        message: message.text,
        userId: otherUserId,
        mediaUrl: path);
    var either = await sendChatMessageUseCase(chatRequestModel);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) {
      chatPagination.pagingController.itemList ??= [];
      chatPagination.pagingController..itemList.insert(0, messageText);
      emit(const CommonUIState.success(unit));
    });
  }

  deleteAllMessages(DeleteChatRequestModel deleteChatRequestModel) async {
    emit(const CommonUIState.loading());
    final either = await deleteAllMessagesUseCase(deleteChatRequestModel);
    either.fold((l) => emit(CommonUIState.error(l.errorMessage)), (r) {
      // clearing chat only
      if (!deleteChatRequestModel.deleteChat) {
        chatPagination.onRefresh();
      }
      emit(CommonUIState.success(deleteChatRequestModel.deleteChat
          ? "Chat Deleted Successfully"
          : "Chat Cleared Successfully"));
    });
  }

  // sending last message to the previous screen
  getLastMessage() {
    if (chatPagination.pagingController.itemList == null ||
        chatPagination?.pagingController?.itemList?.isEmpty == true) return '';
    return chatPagination?.pagingController?.itemList[0];
  }

  deleteMessage(String message_id) async {
    emit(const CommonUIState.loading());
    var either = await deleteMessageUseCase(message_id);
    print(either);
    either.fold(
      (l) => emit(CommonUIState.error(l.errorMessage)),
      (r) {
        emit(CommonUIState.success(r));
      },
    );
  }
}
