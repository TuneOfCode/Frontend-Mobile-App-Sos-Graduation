import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship_request.dart';
import 'package:sos_app/src/friendship/domain/params/create_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/query_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/update_friendship_request_params.dart';

abstract class FriendshipRequestRepository {
  const FriendshipRequestRepository();

  ResultFuture<FriendshipRequest> getFriendshipRequestById(
      QueryFriendshipRequestParams params);

  ResultFuture<List<FriendshipRequest>> getFriendshipRequestsSentByUser(
      QueryFriendshipRequestParams params);

  ResultFuture<List<FriendshipRequest>> getFriendshipRequestsReceivedByUser(
      QueryFriendshipRequestParams params);

  ResultVoid createFriendshipRequest(CreateFriendshipRequestParams params);

  ResultVoid acceptFriendshipRequest(UpdateFriendshipRequestParams params);

  ResultVoid rejectFriendshipRequest(UpdateFriendshipRequestParams params);

  ResultVoid cancelFriendshipRequest(UpdateFriendshipRequestParams params);
}
