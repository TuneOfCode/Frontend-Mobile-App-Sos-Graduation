import 'package:equatable/equatable.dart';
import 'package:sos_app/src/notifications/domain/entities/notification.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class GettingNotifications extends NotificationState {
  const GettingNotifications();
}

class NotificationsLoaded extends NotificationState {
  final List<NotificationEntity> notifications;

  const NotificationsLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;
  final dynamic data;

  const NotificationError(this.message, this.data);

  @override
  List<Object> get props => [message, data];
}
