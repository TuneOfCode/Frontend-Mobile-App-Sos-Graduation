import 'package:dartz/dartz.dart';
import 'package:sos_app/core/errors/api_request_failure.dart';
import 'package:sos_app/core/errors/api_response_failure.dart';
import 'package:sos_app/core/exceptions/api_request_exception.dart';
import 'package:sos_app/core/exceptions/api_response_exception.dart';
import 'package:sos_app/core/utils/typedef.dart';

ResultFuture<R> apiInterceptorService<R>(Future<R>? Function() func) async {
  try {
    final res = await func();
    return Right(res as R);
  } on ApiRequestException catch (e) {
    return Left(ApiRequestFailure(e.response));
  } on ApiResponseException catch (e) {
    return Left(ApiResponseFailure(
      errMessage: e.exceptionMessage,
      errData: e.data,
    ));
  }
}
