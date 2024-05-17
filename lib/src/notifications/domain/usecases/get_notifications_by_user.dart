import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/notifications/domain/entities/notification.dart';
import 'package:sos_app/src/notifications/domain/params/get_notifications_params.dart';
import 'package:sos_app/src/notifications/domain/respositories/notification_repository.dart';

class GetNotificationsByUser extends UsecaseWithParams<List<NotificationEntity>,
    GetNotificationsParams> {
  final NotificationRepository _repository;

  const GetNotificationsByUser(this._repository);

  @override
  ResultFuture<List<NotificationEntity>> call(GetNotificationsParams params) {
    return _repository.getNotifications(
      GetNotificationsParams(
        userId: params.userId,
      ),
    );
  }
}
