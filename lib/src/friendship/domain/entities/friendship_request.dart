import 'package:equatable/equatable.dart';

class FriendshipRequest extends Equatable {
  final String friendshipRequestId;
  final String senderId;
  final String senderFullName;
  final String senderAvatar;
  final String receiverId;
  final String receiverFullName;
  final String receiverAvatar;
  final String status;
  final String createdAt;
  final String updatedAt;

  const FriendshipRequest({
    required this.friendshipRequestId,
    required this.senderId,
    required this.senderFullName,
    required this.senderAvatar,
    required this.receiverId,
    required this.receiverFullName,
    required this.receiverAvatar,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [friendshipRequestId];
}
