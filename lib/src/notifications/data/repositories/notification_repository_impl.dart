import 'package:sos_app/core/services/api_interceptor_service.dart';
import 'package:sos_app/core/services/network_info_service.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/notifications/data/datasources/local/notification_local_datasource.dart';
import 'package:sos_app/src/notifications/data/datasources/remote/notification_remote_datasource.dart';
import 'package:sos_app/src/notifications/domain/entities/notification.dart';
import 'package:sos_app/src/notifications/domain/params/get_notifications_params.dart';
import 'package:sos_app/src/notifications/domain/respositories/notification_repository.dart';

class NotificationRepositoryImpl extends NotificationRepository {
  final NotificationRemoteDataSource _remote;
  final NotificationLocalDataSource _local;
  final NetworkInfoService _networkInfo;

  const NotificationRepositoryImpl(
    this._remote,
    this._local,
    this._networkInfo,
  );

  @override
  ResultFuture<List<NotificationEntity>> getNotifications(
      GetNotificationsParams params) async {
    if (!(await _networkInfo.isConnected)) {
      return apiInterceptorService(() => _local.getNotifications());
    }

    return apiInterceptorService(() => _remote.getNotifications(params));
  }
}
