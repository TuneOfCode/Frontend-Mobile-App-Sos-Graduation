import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship_request.dart';
import 'package:sos_app/src/friendship/domain/params/create_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/update_friendship_request_params.dart';

class FriendshipRequestModel extends FriendshipRequest {
  const FriendshipRequestModel({
    required super.friendshipRequestId,
    required super.senderId,
    required super.senderFullName,
    required super.senderAvatar,
    required super.receiverId,
    required super.receiverFullName,
    required super.receiverAvatar,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  FriendshipRequestModel.fromJson(DataMap dataMap)
      : this(
          friendshipRequestId: dataMap['friendshipRequestId'].toString(),
          senderId: dataMap['senderId'] ?? '',
          senderFullName: dataMap['senderFullName'] ?? '',
          senderAvatar: dataMap['senderAvatar'] ?? '',
          receiverId: dataMap['receiverId'] ?? '',
          receiverFullName: dataMap['receiverFullName'] ?? '',
          receiverAvatar: dataMap['receiverAvatar'] ?? '',
          status: dataMap['status'].toString(),
          createdAt: dataMap['createdAt'].toString(),
          updatedAt: dataMap['updatedAt'].toString(),
        );

  static DataMap toCreateFriendshipRequest(
          CreateFriendshipRequestParams params) =>
      {
        'senderId': params.senderId,
        'receiverId': params.receiverId,
      };

  static DataMap toUpdateFriendshipRequest(
          UpdateFriendshipRequestParams params) =>
      {
        'friendshipRequestId': params.friendshipRequestId,
      };
}
