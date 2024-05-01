import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/core/components/widgets/toast_success.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';
import 'package:sos_app/src/friendship/domain/params/create_friendship_request_params.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_event.dart';

class RecommendFriendsTab extends StatelessWidget {
  final List<User> users;
  const RecommendFriendsTab({super.key, required this.users});

  _handleCreateFriendshipRequest(BuildContext context, User user) {
    context.read<FriendshipRequestBloc>().add(
          CreateFriendshipRequestEvent(
            params: CreateFriendshipRequestParams(
              senderId: '',
              receiverId: user.userId,
            ),
          ),
        );

    // AppNotify.showNotification(
    //   title: 'Lời mời kết bạn mới',
    //   body: 'Đã gửi lời mời kết bạn đến ${user.fullName}',
    //   payload: {
    //     'context': context,
    //     'route': AppRouter.contacts,
    //     'arguments': 2,
    //   },
    // );

    ScaffoldMessenger.of(context).showSnackBar(
        ToastSuccess(message: 'Đã gửi lời mời kết bạn đến ${user.fullName}')
            .build(context));
  }

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(
        child: Text(
          'Danh sách trống',
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
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final avatarUrl = "${ApiConfig.BASE_IMAGE_URL}${user.avatarUrl}";
          return ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: Image.network(avatarUrl).image,
            ),
            title: Text(user.fullName),
            subtitle: Text(user.email),
            trailing: ElevatedButton(
                onPressed: () => _handleCreateFriendshipRequest(context, user),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  'Thêm bạn bè',
                  style: TextStyle(color: Colors.white),
                )),
          );
        },
      ),
    );
  }
}
