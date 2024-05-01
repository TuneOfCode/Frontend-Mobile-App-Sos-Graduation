import 'package:equatable/equatable.dart';
import 'package:sos_app/src/friendship/domain/params/create_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/query_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/update_friendship_request_params.dart';

abstract class FriendshipRequestEvent extends Equatable {
  const FriendshipRequestEvent();

  @override
  List<Object> get props => [];
}

class GetFriendshipRequestByIdEvent extends FriendshipRequestEvent {
  final QueryFriendshipRequestParams params;

  const GetFriendshipRequestByIdEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class GetFriendshipRequestsSentByUserEvent extends FriendshipRequestEvent {
  final QueryFriendshipRequestParams params;

  const GetFriendshipRequestsSentByUserEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class GetFriendshipRequestsReceivedByUserEvent extends FriendshipRequestEvent {
  final QueryFriendshipRequestParams params;

  const GetFriendshipRequestsReceivedByUserEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class CreateFriendshipRequestEvent extends FriendshipRequestEvent {
  final CreateFriendshipRequestParams params;

  const CreateFriendshipRequestEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class AcceptFriendshipRequestEvent extends FriendshipRequestEvent {
  final UpdateFriendshipRequestParams params;

  const AcceptFriendshipRequestEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class RejectFriendshipRequestEvent extends FriendshipRequestEvent {
  final UpdateFriendshipRequestParams params;

  const RejectFriendshipRequestEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class CancelFriendshipRequestEvent extends FriendshipRequestEvent {
  final UpdateFriendshipRequestParams params;

  const CancelFriendshipRequestEvent({required this.params});

  @override
  List<Object> get props => [params];
}
