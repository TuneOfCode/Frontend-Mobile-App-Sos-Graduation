import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/core/components/widgets/toast_error.dart';
import 'package:sos_app/core/components/widgets/toast_success.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/utils/datetime_util.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship_request.dart';
import 'package:sos_app/src/friendship/domain/params/update_friendship_request_params.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_event.dart';

class ReceivedInvitationsTab extends StatelessWidget {
  final List<FriendshipRequest> friendshipRequests;
  const ReceivedInvitationsTab({super.key, required this.friendshipRequests});

  _handleAcceptFriendshipRequest(
      BuildContext context, FriendshipRequest friendshipRequest) {
    context.read<FriendshipRequestBloc>().add(
          AcceptFriendshipRequestEvent(
            params: UpdateFriendshipRequestParams(
              friendshipRequestId: friendshipRequest.friendshipRequestId,
            ),
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(ToastSuccess(
            message:
                'Bạn đã trở thành bạn bè với ${friendshipRequest.senderFullName}')
        .build(context));
  }

  _handleRejectFriendshipRequest(
      BuildContext context, FriendshipRequest friendshipRequest) {
    context.read<FriendshipRequestBloc>().add(
          RejectFriendshipRequestEvent(
            params: UpdateFriendshipRequestParams(
              friendshipRequestId: friendshipRequest.friendshipRequestId,
            ),
          ),
        );

    ScaffoldMessenger.of(context).showSnackBar(ToastError(
            message:
                'Bạn đã từ chối lời mời kết bạn từ ${friendshipRequest.senderFullName}')
        .build(context));
  }

  @override
  Widget build(BuildContext context) {
    if (friendshipRequests.isEmpty) {
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
        itemCount: friendshipRequests.length,
        itemBuilder: (context, index) {
          final friendshipRequest = friendshipRequests[index];
          final avatarUrl =
              "${ApiConfig.BASE_IMAGE_URL}${friendshipRequest.senderAvatar}";
          return ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: Image.network(avatarUrl).image,
            ),
            title: Text(friendshipRequest.senderFullName),
            subtitle: SizedBox(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => _handleAcceptFriendshipRequest(
                        context, friendshipRequest),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Chấp nhận',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _handleRejectFriendshipRequest(
                        context, friendshipRequest),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text(
                      'Từ chối',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            trailing: SizedBox(
              width: 80,
              child: Text(
                DatimeUtil.formatDateTime(
                  dateTimeStr: friendshipRequest.createdAt,
                ),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
