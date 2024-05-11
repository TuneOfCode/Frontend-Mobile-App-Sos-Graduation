import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/app_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/exceptions/api_response_exception.dart';
import 'package:sos_app/core/services/http_client_service.dart';
import 'package:sos_app/core/sockets/webrtc.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/authentication/data/datasources/remote/authentication_remote_datasource.dart';
import 'package:sos_app/src/authentication/data/models/user_model.dart';
import 'package:sos_app/src/authentication/data/models/verify_code_model.dart';
import 'package:sos_app/src/authentication/domain/entities/auth.dart';
import 'package:sos_app/src/authentication/domain/params/change_password_params.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/login_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/resend_verify_code_params.dart';
import 'package:sos_app/src/authentication/domain/params/update_location_params.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/verify_user_params.dart';
import 'package:universal_io/io.dart';

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final AuthenticationLocalDataSource _authenticationLocalDataSource;
  final HttpClientService _httpClient;

  AuthenticationRemoteDataSourceImpl(
    this._authenticationLocalDataSource,
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
          .map((item) => UserModel.fromJson(item))
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
      await _authenticationLocalDataSource.setAccessToken(data.accessToken);
      await _authenticationLocalDataSource.setRefreshToken(
        data.refreshToken,
      );
      final accessToken = await _authenticationLocalDataSource.getAccessToken();
      await WebRTCsHub.instance.init(accessToken!);
      await getProfile();

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
      final data = UserModel.fromJson(response);
      _authenticationLocalDataSource.setCurrentUser(userModelToJson(data));

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

      await getProfile();
    } on DioException catch (e) {
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<void> resendVerifyCode(ResendVerifyCodeParams params) async {
    try {
      await _httpClient.patchAsync(
        AuthenticationEndpoint.RESEND,
        VerifyCodeModel.toResendVerifyCode(params),
      );
    } on DioException catch (e) {
      throw ApiResponseException(
        exceptionMessage: AppConfig.GENERAL_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<void> verifyUser(VerifyUserParams params) async {
    try {
      await _httpClient.patchAsync(
        AuthenticationEndpoint.VERIFY,
        VerifyCodeModel.toVerifyUser(params),
      );
    } on DioException catch (e) {
      throw ApiResponseException(
        exceptionMessage: AppConfig.GENERAL_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<void> changePassword(ChangePasswordParams params) async {
    try {
      String userId = params.userId;
      if (userId.isEmpty) {
        final user = await _authenticationLocalDataSource.getCurrentUser();
        userId = user.userId;
      }
      final path =
          '${UserEndpoint.ROOT}/$userId/${UserEndpoint.CHANGE_PASSWORD}';
      await _httpClient.patchAsync(
        path,
        UserModel.toChangePassword(params),
      );
    } on DioException catch (e) {
      throw ApiResponseException(
        exceptionMessage: AppConfig.GENERAL_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<void> updateLocation(UpdateLocationParams params) async {
    try {
      String userId = params.userId;
      if (userId.isEmpty) {
        final user = await _authenticationLocalDataSource.getCurrentUser();
        userId = user.userId;
      }
      final path =
          '${UserEndpoint.ROOT}/$userId/${UserEndpoint.UPDATE_LOCATION}';
      await _httpClient.patchAsync(
        path,
        UserModel.toUpdateLocation(params),
      );
    } on DioException catch (e) {
      throw ApiResponseException(
        exceptionMessage: AppConfig.GENERAL_ERROR_MSG,
        data: e.response,
      );
    }
  }
}
