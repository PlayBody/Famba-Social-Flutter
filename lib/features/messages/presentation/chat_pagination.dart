import '../../../core/common/failure.dart';
import '../../../core/common/pagination/custom_pagination.dart';
import '../data/models/request/chat_request_model.dart';
import '../domain/entity/chat_entity.dart';
import '../domain/usecase/get_chats_use_case.dart';
import '../domain/usecase/search_chats_use_case.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatPagination extends CustomPagination<ChatEntity>
    with SearchingMixin<ChatEntity> {
  final GetChatUseCase getChatUseCase;
  final SearchChatUseCase searchChatUseCase;
  String userId;
  bool searchChat = false;

  ChatPagination(this.getChatUseCase, this.searchChatUseCase) {
    enableSearch();
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> getItems(int pageKey) async {
    if (searchChat && queryText.isNotEmpty) {
      final response = await searchChatUseCase(ChatRequestModel(
          offset: pageKey.toString(), userId: userId, searchQuery: queryText));
      return response.fold((l) => left(l), (r) => right(r.reversed.toList()));
    } else {
      final response = await getChatUseCase(
          ChatRequestModel(offset: pageKey.toString(), userId: userId));
      return response.fold((l) => left(l), (r) => right(r.reversed.toList()));
    }
  }

  @override
  ChatEntity getLastItemWithoutAd(List<ChatEntity> item) => item.last;

  @override
  int getNextKey(ChatEntity item) => int.tryParse(item.offSetId);

  @override
  bool isLastPage(List<ChatEntity> item) =>
      searchChat ? true : commonLastPage(item);
}
