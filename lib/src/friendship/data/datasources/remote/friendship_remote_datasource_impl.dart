import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/app_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/exceptions/api_response_exception.dart';
import 'package:sos_app/core/services/http_client_service.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/authentication/data/models/user_model.dart';
import 'package:sos_app/src/friendship/data/datasources/local/friendship_local_datasource.dart';
import 'package:sos_app/src/friendship/data/datasources/remote/friendship_remote_datasource.dart';
import 'package:sos_app/src/friendship/data/models/friendship_model.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/params/remove_friendship_params.dart';

class FriendshipRemoteDataSourceImpl implements FriendshipRemoteDataSource {
  final AuthenticationLocalDataSource _authenticationLocalDataSource;
  final FriendshipLocalDataSource _friendshipLocalDataSource;
  final HttpClientService _httpClient;

  FriendshipRemoteDataSourceImpl(
    this._authenticationLocalDataSource,
    this._friendshipLocalDataSource,
    this._httpClient,
  );

  @override
  Future<List<FriendshipModel>> getFriendships(
      GetFriendshipParams params) async {
    try {
      String userId = params.userId;
      if (userId.isEmpty) {
        final user = await _authenticationLocalDataSource.getCurrentUser();
        userId = user.userId;
      }
      final String uri = '${FriendshipEndpoint.ROOT}/$userId';
      final queryParams = FriendshipModel.toQueryParams(params);
      final response = await _httpClient.getAsync(uri, query: queryParams);
      final data = List<dynamic>.from(response['data'])
          .map((item) => FriendshipModel.fromJson(item))
          .toList();

      final friendships = List<Friendship>.from(
        data.map((x) => FriendshipModel.fromJson(x.toJson())),
      );

      await _friendshipLocalDataSource.setFriendships(jsonEncode(friendships));

      return data;
    } on DioException catch (e) {
      logger.e('Remote getFriendships error: $e');
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<void> removeFriendship(RemoveFriendshipParams params) async {
    try {
      final String uri =
          '${FriendshipEndpoint.ROOT}/${params.userId}/${FriendshipEndpoint.REMOVE}/${params.friendId}';
      await _httpClient.patchAsync(uri, params);
    } on DioException catch (e) {
      logger.e('Remote removeFriendship error: $e');
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }

  @override
  Future<List<UserModel>> getFriendshipRecommends(
      GetFriendshipParams params) async {
    try {
      String userId = params.userId;
      if (userId.isEmpty) {
        final user = await _authenticationLocalDataSource.getCurrentUser();
        userId = user.userId;
      }
      final String uri =
          '${FriendshipEndpoint.ROOT}/$userId/${FriendshipEndpoint.GET_RECOMMEND}';
      final queryParams = FriendshipModel.toQueryParams(params);
      final response = await _httpClient.getAsync(uri, query: queryParams);
      final data = List<dynamic>.from(response['data'])
          .map((item) => UserModel.fromJson(item))
          .toList();

      return data;
    } on DioException catch (e) {
      logger.e('Remote getFriendshipRecommends error: $e');
      throw ApiResponseException(
        exceptionMessage: AppConfig.BAD_REQUEST_ERROR_MSG,
        data: e.response,
      );
    }
  }
}
