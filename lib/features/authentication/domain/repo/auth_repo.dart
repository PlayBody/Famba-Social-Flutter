import 'dart:collection';
import '../../../../core/common/failure.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Failure, dynamic>> signIn(HashMap<String, dynamic> hashMap);
  Future<Either<Failure, dynamic>> signUp(HashMap<String, dynamic> hashMap);
  Future<Either<Failure, String>> fbLogin();
  Future<Either<Failure, String>> googleLogin();
  Future<Either<Failure, String>> resetPassword(String email);
}
