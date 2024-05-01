import 'package:equatable/equatable.dart';

class RemoveFriendshipParams extends Equatable {
  final String userId;
  final String friendId;

  const RemoveFriendshipParams({
    required this.userId,
    required this.friendId,
  });

  @override
  List<Object?> get props => [userId, friendId];
}
