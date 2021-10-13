import 'package:dartz/dartz.dart';
import 'failure.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParam {}
