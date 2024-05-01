import 'package:equatable/equatable.dart';

class CreateFriendshipRequestParams extends Equatable {
  final String senderId;
  final String receiverId;

  const CreateFriendshipRequestParams({
    required this.senderId,
    required this.receiverId,
  });

  @override
  List<Object?> get props => [senderId, receiverId];
}
