import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/src/authentication/presentation/widgets/loading_column.dart';
import 'package:sos_app/src/notifications/presentation/logic/notification_bloc.dart';
import 'package:sos_app/src/notifications/presentation/logic/notification_state.dart';
import 'package:sos_app/src/notifications/presentation/widgets/get_notification_listview.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Thông báo'),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Container(
              margin: const EdgeInsets.only(
                top: 20,
                left: 5,
                right: 5,
              ),
              child: (state is GettingNotifications
                  ? const LoadingColumn(message: 'Đang tải thông báo')
                  : state is NotificationsLoaded
                      ? Center(
                          child: GetNotificationListView(
                              notifications: state.notifications),
                        )
                      : const SizedBox.shrink()),
            ),
          ),
        );
      },
    );
  }
}
