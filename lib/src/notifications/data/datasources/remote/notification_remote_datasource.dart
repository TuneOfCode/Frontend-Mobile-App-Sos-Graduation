import 'package:sos_app/src/notifications/domain/entities/notification.dart';
import 'package:sos_app/src/notifications/domain/params/get_notifications_params.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationEntity>> getNotifications(
      GetNotificationsParams params);
}
