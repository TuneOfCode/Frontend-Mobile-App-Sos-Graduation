import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/notifications/domain/entities/notification.dart';
import 'package:sos_app/src/notifications/domain/params/get_notifications_params.dart';

abstract class NotificationRepository {
  const NotificationRepository();

  ResultFuture<List<NotificationEntity>> getNotifications(
      GetNotificationsParams params);
}
