import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../data/models/request/chat_request_model.dart';
import '../entity/chat_entity.dart';
import '../repo/message_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetChatUseCase extends UseCase<List<ChatEntity>, ChatRequestModel> {
  final MessageRepo messageRepo;

  GetChatUseCase(this.messageRepo);
  @override
  Future<Either<Failure, List<ChatEntity>>> call(ChatRequestModel params) {
    return messageRepo.getChats(params);
  }
}
