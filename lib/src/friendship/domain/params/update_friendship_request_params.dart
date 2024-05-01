import 'package:equatable/equatable.dart';

class UpdateFriendshipRequestParams extends Equatable {
  final String friendshipRequestId;

  const UpdateFriendshipRequestParams({
    required this.friendshipRequestId,
  });

  @override
  List<Object?> get props => [friendshipRequestId];
}
