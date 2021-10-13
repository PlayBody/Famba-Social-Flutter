import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../entity/message_entity.dart';
import '../repo/message_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetMessagesUseCase extends UseCase<List<MessageEntity>, Unit> {
  final MessageRepo messageRepo;
  GetMessagesUseCase(this.messageRepo);
  @override
  Future<Either<Failure, List<MessageEntity>>> call(Unit params) {
    return messageRepo.getMessages();
  }
}
