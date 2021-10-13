import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../../data/models/request/delete_chat_request_model.dart';
import '../repo/message_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAllMessagesUseCase
    extends UseCase<dynamic, DeleteChatRequestModel> {
  final MessageRepo messageRepo;
  DeleteAllMessagesUseCase(this.messageRepo);
  @override
  Future<Either<Failure, dynamic>> call(DeleteChatRequestModel params) {
    return messageRepo.deleteAllMessages(params);
  }
}
