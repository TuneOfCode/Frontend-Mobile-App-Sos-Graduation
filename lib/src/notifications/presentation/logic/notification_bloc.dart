import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/src/notifications/domain/params/get_notifications_params.dart';
import 'package:sos_app/src/notifications/domain/usecases/get_notifications_by_user.dart';
import 'package:sos_app/src/notifications/presentation/logic/notification_event.dart';
import 'package:sos_app/src/notifications/presentation/logic/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsByUser _getNotificationsByUser;

  NotificationBloc({
    required GetNotificationsByUser getNotificationsByUser,
  })  : _getNotificationsByUser = getNotificationsByUser,
        super(const NotificationInitial()) {
    on<GetNotificationsEvent>(_getNotificationsHandler);
  }

  FutureOr<void> _getNotificationsHandler(
      GetNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(const GettingNotifications());

    final result = await _getNotificationsByUser.call(
      GetNotificationsParams(
        userId: event.params.userId,
      ),
    );

    result.fold(
      (failure) => NotificationError(failure.errorMessageLog, failure.data),
      (notifications) => emit(NotificationsLoaded(notifications)),
    );
  }
}
