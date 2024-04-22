import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/app_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/exceptions/api_response_exception.dart';
import 'package:sos_app/core/services/http_client_service.dart';
import 'package:sos_app/src/authentication/data/datasources/authentication_local_storage.dart';
import 'package:sos_app/src/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:sos_app/src/authentication/data/models/user_model.dart';
import 'package:sos_app/src/authentication/domain/entities/auth.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/login_user.params.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';
import 'package:universal_io/io.dart';

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final AuthenticationLocalStorage _authenticationLocalStorage;
  final HttpClientService _httpClient;

  AuthenticationRemoteDataSourceImpl(
    this._authenticationLocalStorage,
    this._httpClient,
  );

  @override
  Future<void> createUser(CreateUserParams params) async {
    try {
      await _httpClient.postAsync(
          AuthenticationEndpoint.REGISTER, UserModel.toCreateUser(params));
    } on DioException catch (e) {
      // logger.e('Remote createUser error: $e');
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _httpClient.getAsync(UserEndpoint.ROOT);
      final data = List<dynamic>.from(response['data'])
          .map((item) => UserModel.fromMap(item))
          .toList();
      return data;
    } on DioException catch (e) {
      throw ApiResponseException(
        exceptionMessage: AppConfig.GENERAL_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<Auth> loginUser(LoginUserParams params) async {
    try {
      final response = await _httpClient.postAsync(
          AuthenticationEndpoint.LOGIN, UserModel.toLoginUser(params));
      final data = Auth.fromMap(response);
      await _authenticationLocalStorage.setAccessToken(value: data.accessToken);
      await _authenticationLocalStorage.setRefreshToken(
        value: data.refreshToken,
      );
      return data;
    } on DioException catch (e) {
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _httpClient.getAsync(AuthenticationEndpoint.ME);
      final data = UserModel.fromMap(response);
      return data;
    } on DioException catch (e) {
      throw ApiResponseException(
        exceptionMessage: AppConfig.GENERAL_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<void> updateUser(UpdateUserParams params) async {
    try {
      final String uri = '${UserEndpoint.ROOT}/${params.userId}';
      var request = UserModel.toUpdateUser(params);
      FormData formData = FormData.fromMap({
        ...request,
      });

      if (params.avatar != null) {
        if (kIsWeb) {
          formData.files.add(
            MapEntry(
              'avatar',
              MultipartFile.fromBytes(
                await params.avatar!.readAsBytes(),
                filename: params.avatar!.name,
              ),
            ),
          );
        } else {
          File file = File(params.avatar!.path);
          if (file.path.isNotEmpty) {
            formData.files
                .add(MapEntry('avatar', MultipartFile.fromFileSync(file.path)));
          }
        }
      }
      logger.f('formData: ${formData.fields}');

      await _httpClient.patchAsync(
        uri,
        formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data', // application/octet-stream
          },
        ),
      );
    } on DioException catch (e) {
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }
}
