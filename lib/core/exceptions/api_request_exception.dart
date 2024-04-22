import 'package:dio/dio.dart';

class ApiRequestException implements Exception {
  final Response response;

  const ApiRequestException(this.response);

  @override
  String toString() => "Api Request Status Code: ${response.statusCode}";
}
