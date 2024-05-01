import 'package:dio/dio.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/app_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/exceptions/api_response_exception.dart';
import 'package:sos_app/core/services/http_client_service.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/friendship/data/datasources/remote/friendship_request_remote_datasource.dart';
import 'package:sos_app/src/friendship/data/models/friendship_request_model.dart';
import 'package:sos_app/src/friendship/domain/params/create_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/query_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/update_friendship_request_params.dart';

class FriendshipRequestRemoteDataSourceImpl
    implements FriendshipRequestRemoteDataSource {
  final AuthenticationLocalDataSource _authenticationLocalDataSource;
  final HttpClientService _httpClient;

  FriendshipRequestRemoteDataSourceImpl(
    this._authenticationLocalDataSource,
    this._httpClient,
  );

  @override
  Future<void> acceptFriendshipRequest(
      UpdateFriendshipRequestParams params) async {
    try {
      final String uri =
          '${FriendshipRequestEndpoint.ROOT}/${params.friendshipRequestId}/${FriendshipRequestEndpoint.ACCEPT}';
      await _httpClient.patchAsync(
        uri,
        FriendshipRequestModel.toUpdateFriendshipRequest(params),
      );
    } on DioException catch (e) {
      logger.e('Remote accept error: $e');
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<void> cancelFriendshipRequest(
      UpdateFriendshipRequestParams params) async {
    try {
      final String uri =
          '${FriendshipRequestEndpoint.ROOT}/${params.friendshipRequestId}/${FriendshipRequestEndpoint.CANCEL}';
      await _httpClient.patchAsync(
        uri,
        FriendshipRequestModel.toUpdateFriendshipRequest(params),
      );
    } on DioException catch (e) {
      logger.e('Remote cancel error: $e');
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<void> createFriendshipRequest(
      CreateFriendshipRequestParams params) async {
    try {
      await _httpClient.postAsync(
        FriendshipRequestEndpoint.ROOT,
        FriendshipRequestModel.toCreateFriendshipRequest(params),
      );
    } on DioException catch (e) {
      logger.e('Remote create error: $e');
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<FriendshipRequestModel> getFriendshipRequestById(
      QueryFriendshipRequestParams params) async {
    try {
      final String uri =
          '${FriendshipRequestEndpoint.ROOT}/${params.friendshipRequestId}';
      final response = await _httpClient.getAsync(uri);
      return FriendshipRequestModel.fromJson(response);
    } on DioException catch (e) {
      logger.e('Remote getFriendshipRequestById error: $e');
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<List<FriendshipRequestModel>> getFriendshipRequestsReceivedByUser(
      QueryFriendshipRequestParams params) async {
    try {
      String? userId = params.userId;
      if (userId!.isEmpty) {
        final user = await _authenticationLocalDataSource.getCurrentUser();
        logger.f('Get current user in local storage: $user');
        userId = user.userId;
      }
      final String uri =
          '${FriendshipRequestEndpoint.ROOT}/$userId/${FriendshipRequestEndpoint.GET_RECEIVED}';
      final response = await _httpClient.getAsync(uri);
      final data =
          List<dynamic>.from(response['listFriendshipRequestByReceiver'])
              .map((item) => FriendshipRequestModel.fromJson(item))
              .toList();
      return data;
    } on DioException catch (e) {
      logger.e('Remote getFriendshipRequestsReceivedByUser error: $e');
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<List<FriendshipRequestModel>> getFriendshipRequestsSentByUser(
      QueryFriendshipRequestParams params) async {
    try {
      String? userId = params.userId;
      if (userId!.isEmpty) {
        final user = await _authenticationLocalDataSource.getCurrentUser();
        logger.f('Get current user in local storage: $user');
        userId = user.userId;
      }
      final String uri =
          '${FriendshipRequestEndpoint.ROOT}/$userId/${FriendshipRequestEndpoint.GET_SENT}';
      final response = await _httpClient.getAsync(uri);
      final data = List<dynamic>.from(response['listFriendshipRequestBySender'])
          .map((item) => FriendshipRequestModel.fromJson(item))
          .toList();
      return data;
    } on DioException catch (e) {
      logger.e('Remote getFriendshipRequestsSentByUser error: $e');
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<void> rejectFriendshipRequest(
      UpdateFriendshipRequestParams params) async {
    try {
      final String uri =
          '${FriendshipRequestEndpoint.ROOT}/${params.friendshipRequestId}/${FriendshipRequestEndpoint.REJECT}';
      await _httpClient.patchAsync(
        uri,
        FriendshipRequestModel.toUpdateFriendshipRequest(params),
      );
    } on DioException catch (e) {
      logger.e('Remote reject error: $e');
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }
}
