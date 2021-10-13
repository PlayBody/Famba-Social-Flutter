import 'dart:collection';

import 'api_constants.dart';
import '../failure.dart';
import '../../datasource/local_data_source.dart';
import '../../di/injection.dart';
import '../../../features/authentication/data/models/login_response.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class ApiHelper {
  final Dio dio = getIt<Dio>();
  final LocalDataSource localDataSource;
  ApiHelper(this.localDataSource) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    final interceptor = InterceptorsWrapper(
      onError: (e, handler) {
        if (e?.response?.data != null)
          print("error in response ${e.response?.data["message"]}");
      },
      onResponse: (res, handler) async {
        handler.next(res);
      },
      onRequest: (req, handler) async {
        // adding auth token
        final UserAuth loginResponse = await localDataSource.getUserAuth();
        if (loginResponse != null) {
          req.headers.addAll({"session_id": loginResponse.authToken});
          if (req.method == "GET") {
            req.queryParameters.addAll({"session_id": loginResponse.authToken});
          } else {
            final updatedReq = (req.data as FormData)
              ..fields.add(MapEntry("session_id", loginResponse.authToken));
            req.data = updatedReq;
          }
        }
        handler.next(req);
      },
    );
    dio.interceptors
      ..add(interceptor)
      ..add(
        LogInterceptor(
          request: true,
          responseBody: true,
          requestBody: true,
        ),
      );
  }

  Future<Either<Failure, Response>> post(
    String path,
    HashMap<String, dynamic> body, {
    dynamic headers,
  }) async =>
      await safeApiHelperRequest(
        () async {
          final Response _res = await dio.post(
            path,
            data: FormData.fromMap(body),
            options: Options(headers: headers),
          );

          return _res;
        },
      );

  Future<Either<Failure, Response>> get<T>(
    String path, {
    Map<String, dynamic> headers,
    Map<String, dynamic> queryParameters,
  }) async =>
      safeApiHelperRequest(
        () => dio.get(path,
            options: Options(headers: headers),
            queryParameters: queryParameters),
      );

  Future<Either<Failure, Response>> put<T>(
    String path, {
    Map<String, dynamic> headers,
    dynamic body,
  }) async =>
      safeApiHelperRequest(
        () => dio.put(
          path,
          options: Options(headers: headers),
          data: body,
        ),
      );

  Future<Either<Failure, Response>> safeApiHelperRequest(
    Future<dynamic> Function() function,
  ) async {
    try {
      // stores what is returned from this function
      final Response response = await function.call();
      print(response);
      // he never reaches this line so we need to handle before call
      if (response.data["code"] == 200 || response.data["status"] == 200)
        return Right(response);
      else if (response.data["code"] == 204)
        return left(NoDataFoundFailure(
            response.data["message"] ?? "Something went wrong"));
      return Left(
          ServerFailure(response.data["message"] ?? "Something went wrong"));
    } on DioError catch (e) {
      return Left(ServerFailure(_handleError(e)));
    }
  }

  String _handleError(DioError error) {
    String errorDescription = "";
    if (error is DioError) {
      DioError dioError = error;
      switch (dioError.type) {
        case DioErrorType.connectTimeout:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.sendTimeout:
          errorDescription = "Send timeout in connection with API server";
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.response:
          errorDescription =
              "Received invalid status code: ${dioError.response.statusCode}";
          break;
        case DioErrorType.cancel:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.other:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }
}
