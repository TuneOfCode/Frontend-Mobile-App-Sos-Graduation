import 'package:equatable/equatable.dart';

class QueryFriendshipRequestParams extends Equatable {
  final String? friendshipRequestId;
  final String? userId;

  const QueryFriendshipRequestParams({
    this.friendshipRequestId,
    this.userId,
  });

  @override
  List<Object?> get props => [friendshipRequestId, userId];
}
