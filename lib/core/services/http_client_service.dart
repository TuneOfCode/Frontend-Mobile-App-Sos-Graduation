import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/app_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/exceptions/api_request_exception.dart';
import 'package:sos_app/core/exceptions/api_response_exception.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/data/datasources/authentication_local_storage.dart';

class HttpClientService {
  final Dio _dio;
  final AuthenticationLocalStorage _authenticationLocalStorage;
  late Response response;

  HttpClientService(
    this._dio,
    this._authenticationLocalStorage,
  );

  Future<Options> get defaultOptions async {
    final String? accessToken =
        await _authenticationLocalStorage.getAccessToken();

    return Options(
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );
  }

  Future<dynamic> getAsync(String endpoint, {Options? options}) async {
    String path = ApiConfig.BASE_URL + endpoint;
    logger.i('[CALL API]: $path');

    response = await _dio
        .get(
          path,
          options: options ?? await defaultOptions,
        )
        .then(_handleResponse)
        .catchError(_handleError);

    return processResponse(response, endpoint);
  }

  Future<dynamic> postAsync(String endpoint, dynamic request,
      {Options? options}) async {
    String path = ApiConfig.BASE_URL + endpoint;
    logger.i('[CALL API]: $path');
    logger.i('[REQUEST postAsync]: ${jsonEncode(request)}');

    response = await _dio
        .post(
          path,
          data: jsonEncode(request),
          options: await defaultOptions,
        )
        .then(_handleResponse)
        .catchError(_handleError);

    // return Future.value(response);
    return processResponse(response, endpoint);
  }

  Future<dynamic> putAsync(String endpoint, dynamic request,
      {Options? options}) async {
    String path = ApiConfig.BASE_URL + endpoint;
    logger.i('[CALL API]: $path');
    logger.i('[REQUEST putAsync]: ${jsonEncode(request)}');

    if (options != null && options.contentType == 'multipart/form-data') {
      final String? accessToken =
          await _authenticationLocalStorage.getAccessToken();
      options.headers = {
        'Authorization': 'Bearer $accessToken',
      };
    } else {
      request = jsonEncode(request);
    }

    response = await _dio
        .put(
          path,
          data: request,
          options: options ?? await defaultOptions,
        )
        .then(_handleResponse)
        .catchError(_handleError);

    return Future.value(response);
  }

  Future<dynamic> patchAsync(String endpoint, dynamic request,
      {Options? options}) async {
    String path = ApiConfig.BASE_URL + endpoint;
    logger.i('[CALL API]: $path');

    if (options != null &&
            options.headers?['Content-Type'] == 'multipart/form-data' ||
        options?.headers?['Content-Type'] == 'application/octet-stream') {
      final String? accessToken =
          await _authenticationLocalStorage.getAccessToken();
      options?.headers = {
        'Authorization': 'Bearer $accessToken',
      };
    } else {
      request = jsonEncode(request);
    }
    logger.f(
        '[REQUEST patchAsync]: ${request is FormData ? request.fields : request}');

    response = await _dio
        .patch(
          path,
          data: request,
          options: options ?? await defaultOptions,
        )
        .then(_handleResponse)
        .catchError(_handleError);

    return Future.value(response);
  }

  Future<dynamic> deleteAsync(String endpoint, dynamic request,
      {Options? options}) async {
    String path = ApiConfig.BASE_URL + endpoint;
    logger.i('[CALL API]: $path');
    logger.i('[REQUEST patchAsync]: ${jsonEncode(request)}');

    if (kIsWeb) {}

    response = await _dio
        .delete(
          path,
          data: jsonEncode(request),
          options: options ?? await defaultOptions,
        )
        .then(_handleResponse)
        .catchError(_handleError);

    return Future.value(response);
  }

  dynamic _handleResponse(dynamic response) {
    // logger.i("[HTTP CLIENT] _handleResponse: $response");
    if (![HttpStatus.ok, HttpStatus.created].contains(response.statusCode)) {
      throw ApiResponseException(exceptionMessage: response["message"]);
    }

    return response;
  }

  dynamic _handleError(dynamic errors) {
    logger.e("[HTTP CLIENT] _handleError errors: $errors");
    if (errors == null) {
      throw ApiResponseException(
        exceptionMessage: AppConfig.GENERAL_ERROR_MSG,
      );
    }
    logger.e(
        "[HTTP CLIENT] _handleError status code: ${errors.response.statusCode}");
    switch (errors.response.statusCode) {
      case HttpStatus.unauthorized:
        throw ApiResponseException(
            exceptionMessage: AppConfig.UNAUTHORIZED_ERROR_MSG);
      case HttpStatus.badRequest:
        // logger.e(
        //     "[HTTP CLIENT] _handleError errors.response: ${errors.response}");
        throw ApiResponseException(
          exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
          data: errors.response,
        );
      default:
        DataMap error = jsonDecode(errors.response.toString());
        throw ApiResponseException(
            exceptionMessage: error["message"] != null &&
                    error["message"].toString().isNotEmpty
                ? error["message"]
                : AppConfig.GENERAL_ERROR_MSG);
    }
  }

  DataMap processResponse(Response response, String endpoint) {
    logger.i("[HTTP CLIENT] processResponse Response: $response");
    // logger.i("[HTTP CLIENT] Handler Response Data: ${response.data}");

    if (![HttpStatus.ok, HttpStatus.created, HttpStatus.accepted]
        .contains(response.statusCode)) {
      throw ApiRequestException(response);
    }

    if (response.data is Map) {
      return response.data;
    }

    try {
      return jsonDecode(response.data);
    } catch (e) {
      logger.e("[HTTP CLIENT] processResponse Handler Error: ${e.toString()}");
      throw ApiResponseException(exceptionMessage: AppConfig.GENERAL_ERROR_MSG);
    }
  }
}
