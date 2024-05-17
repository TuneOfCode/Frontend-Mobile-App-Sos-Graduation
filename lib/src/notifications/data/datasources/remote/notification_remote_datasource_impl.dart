import 'package:dio/dio.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/app_config_constant.dart';
import 'package:sos_app/core/exceptions/api_response_exception.dart';
import 'package:sos_app/core/services/http_client_service.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/notifications/data/datasources/remote/notification_remote_datasource.dart';
import 'package:sos_app/src/notifications/data/models/notification_model.dart';
import 'package:sos_app/src/notifications/domain/entities/notification.dart';
import 'package:sos_app/src/notifications/domain/params/get_notifications_params.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final AuthenticationLocalDataSource _authenticationLocalDataSource;
  final HttpClientService _httpClient;

  const NotificationRemoteDataSourceImpl(
    this._authenticationLocalDataSource,
    this._httpClient,
  );

  @override
  Future<List<NotificationEntity>> getNotifications(
      GetNotificationsParams params) async {
    try {
      String userId = params.userId;
      if (userId.isEmpty) {
        final user = await _authenticationLocalDataSource.getCurrentUser();
        userId = user.userId;
      }

      final String uri = '${NotificationEndpoint.ROOT}/$userId';

      final response = await _httpClient.httpGetAsync(uri);
      final data = List<dynamic>.from(response)
          .map((item) => NotificationModel.fromJson(item))
          .toList();

      return data;
    } on DioException catch (e) {
      throw ApiResponseException(
        exceptionMessage: AppConfig.GENERAL_ERROR_MSG,
        data: e.response,
      );
    }
  }
}
