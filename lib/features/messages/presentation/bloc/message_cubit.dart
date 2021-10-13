import 'package:bloc/bloc.dart';
import '../../domain/usecase/delete_messag_use_case.dart';
import '../../../../core/common/failure.dart';
import '../../../../core/common/stream_validators.dart';
import '../../data/models/request/delete_chat_request_model.dart';
import '../../domain/entity/chat_entity.dart';
import '../../domain/entity/message_entity.dart';
import '../../domain/usecase/delete_all_messages_use_case.dart';
import '../../domain/usecase/get_messages_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

// import 'message_state.dart';
import 'message_state.dart';

export 'message_state.dart';

@injectable
class MessageCubit extends Cubit<MessageState> {
  // final messageController=BehaviorSubject<List<String>>();
  // Function(List<String>) get changeMessageList=>messageController.sink.add;
  // Stream<List<String>> get messageList=>messageController.stream;

  final _messageItemsController = BehaviorSubject<List<MessageEntity>>();

  Function(List<MessageEntity>) get changeMessageItems =>
      _messageItemsController.sink.add;

  Stream<List<MessageEntity>> get messageItems =>
      _messageItemsController.stream;

  // saving all list privately
  List<MessageEntity> _items = [];

  // searching
  final _searchMessagesController = BehaviorSubject<String>();

  Function(String) get changeSearchItem => _searchMessagesController.sink.add;

  Stream<String> get searchItem => _searchMessagesController.stream;

  final searchQuery = FieldValidators(null, null);

  // use cases
  final GetMessagesUseCase getMessagesUseCase;

  final DeleteAllMessagesUseCase deleteAllMessageUseCase;

  final DeleteMessageUseCase deleteMessageUseCase;

  MessageCubit(this.getMessagesUseCase, this.deleteAllMessageUseCase,
      this.deleteMessageUseCase)
      : super(const MessageState.initial());

  getMessages() async {
    emit(const MessageState.loading());
    var either = await getMessagesUseCase(unit);
    either.fold(
        (l) => emit(l is NoDataFoundFailure
            ? const MessageState.noData()
            : MessageState.error(l.errorMessage)), (r) {
      _items = r;
      changeMessageItems(r);
      emit(MessageState.success(r));
    });
  }

  Future<bool> deletAllMessages(int index) async {
    // emit(MessageState.loading());
    var either = await deleteAllMessageUseCase(DeleteChatRequestModel(
        deleteChat: true, userId: _messageItemsController.value[index].userId));
    // emit(MessageState.success(false));
    return either.fold((l) => false, (r) => true);
  }

  // helps the clear or delete the use chat
  deleteChat(int index) {
    var allItems = _messageItemsController.value;
    if (allItems.length == 1) {
      emit(const MessageState.noData());
    } else {
      _messageItemsController.value..removeAt(index);
      changeMessageItems(_messageItemsController.value);
    }
    // _messageItemsController.value[index] = value.copyWith(message: '');
    // emit(const MessageState.noData());
    // if(_messageItemsController.value.isNotEmpty)
  }

  clearChat(int index) {
    var value = _messageItemsController.value[index];
    _messageItemsController.value[index] = value.copyWith(message: '');
    changeMessageItems(_messageItemsController.value);
  }

  void updateCurrentMessage(int index, ChatEntity s) {
    var value = _messageItemsController.value[index];
    _messageItemsController.value[index] =
        value.copyWith(message: s.message, time: s.time);
    changeMessageItems(_messageItemsController.value);
  }

  void doSearching(String text) {
    changeSearchItem(text);
    if (text.isEmpty)
      changeMessageItems(_items);
    else
      changeMessageItems(_items
          .where((element) =>
              element.fullName.toLowerCase().contains(text.toLowerCase()))
          .toList());
  }
}
