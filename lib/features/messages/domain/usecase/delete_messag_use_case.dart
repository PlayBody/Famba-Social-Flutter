import '../../../../core/common/failure.dart';
import '../../../../core/common/usecase.dart';
import '../repo/message_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteMessageUseCase extends UseCase<dynamic, String> {
  final MessageRepo messageRepo;

  DeleteMessageUseCase(this.messageRepo);
  @override
  Future<Either<Failure, dynamic>> call(String params) {
    return messageRepo.deleteMessage(params);
  }
}
