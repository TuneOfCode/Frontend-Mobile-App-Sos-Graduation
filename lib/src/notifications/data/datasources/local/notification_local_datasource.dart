import 'package:sos_app/src/notifications/domain/entities/notification.dart';

abstract class NotificationLocalDataSource {
  Future<List<NotificationEntity>> getNotifications();

  Future<void> setNotifications(String value);

  Future<void> clearNotifications();
}
