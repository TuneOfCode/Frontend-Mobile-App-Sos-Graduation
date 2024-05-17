import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/router/app_router.dart';
import 'package:sos_app/core/utils/datetime_util.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/params/query_friendship_request_params.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_event.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_event.dart';
import 'package:sos_app/src/friendship/presentation/views/friendship_screen.dart';
import 'package:sos_app/src/notifications/domain/entities/notification.dart';

class GetNotificationListView extends StatelessWidget {
  final List<NotificationEntity> notifications;
  const GetNotificationListView({super.key, required this.notifications});

  handleTapNotificationItem(
      BuildContext context, NotificationEntity notification) {
    if (notification.content.contains('gửi')) {
      context.read<FriendshipRequestBloc>().add(
          const GetFriendshipRequestsReceivedByUserEvent(
              params: QueryFriendshipRequestParams(userId: '')));
      Navigator.of(context).pushNamed(AppRouter.contacts, arguments: 2);
    } else if (notification.content.contains('chấp nhận')) {
      Navigator.of(context).pushNamed(AppRouter.home);
      context.read<FriendshipBloc>().add(
            const GetFriendshipsEvent(
              params: GetFriendshipParams(userId: '', page: 1),
            ),
          );
      showDialog(
          context: context,
          builder: (context) {
            return const FriendshipScreen();
          });
    } else {
      Navigator.of(context).pushNamed(AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const Center(
        child: Text(
          'Không có thông báo nào',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return Center(
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final thumbnailUrl =
              "${ApiConfig.BASE_IMAGE_URL}${notification.thumbnailUrl}";
          return InkWell(
            onTap: () => handleTapNotificationItem(context, notification),
            child: ListTile(
              leading: Image.network(
                thumbnailUrl,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: Colors.red[800]);
                },
              ),
              title: Text(
                notification.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                notification.content,
                style: const TextStyle(
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: SizedBox(
                width: 80,
                child: Text(
                  DatimeUtil.formatDateTime(
                    dateTimeStr:
                        notification.createdAt.replaceAll('+07:00', ''),
                  ),
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
