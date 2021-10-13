import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../extensions.dart';

abstract class Failure implements Exception {
  final String errorMessage;
  Failure(this.errorMessage);
}

// server failure class
class ServerFailure extends Failure {
  ServerFailure(errorMessage) : super(errorMessage);
}

class NoDataFoundFailure extends Failure {
  NoDataFoundFailure(errorMessage) : super(errorMessage);
}

class UnAuthorized extends Failure {
  UnAuthorized(errorMessage) : super(errorMessage);
}

// cache failure
class CacheFailure extends Failure {
  CacheFailure(String errorMessage) : super(errorMessage);
}

Either<Failure, T> handleApiErrors<T>(Exception e) {
  if (e is ServerFailure) {
    return Left(NoDataFoundFailure(e.errorMessage));
  } else if (e is NoDataFoundFailure) {
    return Left(NoDataFoundFailure(e.errorMessage));
  } else {
    var exception = e as DioError;
    if (exception.response?.statusCode == 401) {
      return Left(UnAuthorized("Access denied due to unautorzied access"));
    }
    exception.handleError;
    return Left(ServerFailure(exception.handleError));
  }
}
