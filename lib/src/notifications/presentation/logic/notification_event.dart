import 'package:equatable/equatable.dart';
import 'package:sos_app/src/notifications/domain/params/get_notifications_params.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetNotificationsEvent extends NotificationEvent {
  final GetNotificationsParams params;

  const GetNotificationsEvent({required this.params});

  @override
  List<Object> get props => [params];
}
