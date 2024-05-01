import 'package:equatable/equatable.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship_request.dart';

abstract class FriendshipRequestState extends Equatable {
  const FriendshipRequestState();

  @override
  List<Object> get props => [];
}

class FriendshipRequestInitial extends FriendshipRequestState {
  const FriendshipRequestInitial();
}

// get friendship request by id
class GettingFriendshipRequestById extends FriendshipRequestState {
  const GettingFriendshipRequestById();
}

class FriendshipRequestByIdLoaded extends FriendshipRequestState {
  final FriendshipRequest friendshipRequest;

  const FriendshipRequestByIdLoaded(this.friendshipRequest);

  @override
  List<Object> get props => [friendshipRequest];
}

// get friendship requests sent by user
class GettingFriendshipRequestsSentByUser extends FriendshipRequestState {
  const GettingFriendshipRequestsSentByUser();
}

class FriendshipRequestsSentByUserLoaded extends FriendshipRequestState {
  final List<FriendshipRequest> friendshipRequests;

  const FriendshipRequestsSentByUserLoaded(this.friendshipRequests);

  @override
  List<Object> get props => [friendshipRequests];
}

// get friendship requests received by user
class GettingFriendshipRequestsReceivedByUser extends FriendshipRequestState {
  const GettingFriendshipRequestsReceivedByUser();
}

class FriendshipRequestsReceivedByUserLoaded extends FriendshipRequestState {
  final List<FriendshipRequest> friendshipRequests;

  const FriendshipRequestsReceivedByUserLoaded(this.friendshipRequests);

  @override
  List<Object> get props => [friendshipRequests];
}

// create friendship request
class CreatingFriendshipRequest extends FriendshipRequestState {
  const CreatingFriendshipRequest();
}

class FriendshipRequestCreated extends FriendshipRequestState {
  const FriendshipRequestCreated();
}

// accept friendship request

class AcceptingFriendshipRequest extends FriendshipRequestState {
  const AcceptingFriendshipRequest();
}

class FriendshipRequestAccepted extends FriendshipRequestState {
  const FriendshipRequestAccepted();
}

// reject friendship request
class RejectingFriendshipRequest extends FriendshipRequestState {
  const RejectingFriendshipRequest();
}

class FriendshipRequestRejected extends FriendshipRequestState {
  const FriendshipRequestRejected();
}

// cancel friendship request
class CancelingFriendshipRequest extends FriendshipRequestState {
  const CancelingFriendshipRequest();
}

class FriendshipRequestCancelled extends FriendshipRequestState {
  const FriendshipRequestCancelled();
}

class FriendshipRequestError extends FriendshipRequestState {
  final String message;
  final dynamic errors;

  const FriendshipRequestError(this.message, this.errors);

  @override
  List<Object> get props => [message, errors];
}
