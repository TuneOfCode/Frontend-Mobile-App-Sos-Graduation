import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/core/components/widgets/toast_error.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship_request.dart';
import 'package:sos_app/src/friendship/domain/params/update_friendship_request_params.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_event.dart';

class SentInvitationsTab extends StatelessWidget {
  final TabController tabController;
  final List<FriendshipRequest> friendshipRequests;
  const SentInvitationsTab({
    super.key,
    required this.tabController,
    required this.friendshipRequests,
  });

  _handleCancelFriendshipRequest(
      BuildContext context, FriendshipRequest friendshipRequest) {
    context.read<FriendshipRequestBloc>().add(
          CancelFriendshipRequestEvent(
            params: UpdateFriendshipRequestParams(
              friendshipRequestId: friendshipRequest.friendshipRequestId,
            ),
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(ToastError(
            message:
                'Đã huỷ yêu cầu kết bạn với ${friendshipRequest.receiverFullName}')
        .build(context));
  }

  @override
  Widget build(BuildContext context) {
    if (friendshipRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Danh sách trống',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  tabController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  'Đề xuất kết bạn',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      );
    }

    return Center(
      child: ListView.builder(
        itemCount: friendshipRequests.length,
        itemBuilder: (context, index) {
          final friendshipRequest = friendshipRequests[index];
          final avatarUrl =
              "${ApiConfig.BASE_IMAGE_URL}${friendshipRequest.receiverAvatar}";
          return ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: Image.network(avatarUrl).image,
            ),
            title: Text(friendshipRequest.receiverFullName),
            // subtitle: Text(friendshipRequest.status),
            trailing: ElevatedButton(
                onPressed: () =>
                    _handleCancelFriendshipRequest(context, friendshipRequest),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text(
                  'Huỷ yêu cầu',
                  style: TextStyle(color: Colors.white),
                )),
          );
        },
      ),
    );
  }
}
