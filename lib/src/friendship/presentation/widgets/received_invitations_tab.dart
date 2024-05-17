// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sos_app/core/components/widgets/toast_error.dart';
import 'package:sos_app/core/components/widgets/toast_success.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/local_datasource_constant.dart';
import 'package:sos_app/core/utils/datetime_util.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship_request.dart';
import 'package:sos_app/src/friendship/domain/params/update_friendship_request_params.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_event.dart';

class ReceivedInvitationsTab extends StatelessWidget {
  final List<FriendshipRequest> friendshipRequests;
  const ReceivedInvitationsTab({super.key, required this.friendshipRequests});

  _handleAcceptFriendshipRequest(
      BuildContext context, FriendshipRequest friendshipRequest) async {
    await GetStorage().remove(LocalDataSource.FRIENDSHIPS);

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
              radius: 30,
              backgroundImage: Image.network(avatarUrl).image,
            ),
            title: Text(
              friendshipRequest.senderFullName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: SingleChildScrollView(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () => _handleAcceptFriendshipRequest(
                          context, friendshipRequest),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        fixedSize: const Size.fromWidth(80),
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Chấp nhận',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _handleRejectFriendshipRequest(
                          context, friendshipRequest),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        fixedSize: const Size.fromWidth(80),
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Từ chối',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
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
