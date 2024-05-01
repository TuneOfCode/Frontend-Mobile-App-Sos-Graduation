import 'package:sos_app/src/friendship/data/models/friendship_request_model.dart';
import 'package:sos_app/src/friendship/domain/params/create_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/query_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/update_friendship_request_params.dart';

abstract class FriendshipRequestRemoteDataSource {
  Future<FriendshipRequestModel> getFriendshipRequestById(
      QueryFriendshipRequestParams params);

  Future<List<FriendshipRequestModel>> getFriendshipRequestsSentByUser(
      QueryFriendshipRequestParams params);

  Future<List<FriendshipRequestModel>> getFriendshipRequestsReceivedByUser(
      QueryFriendshipRequestParams params);

  Future<void> createFriendshipRequest(CreateFriendshipRequestParams params);

  Future<void> acceptFriendshipRequest(UpdateFriendshipRequestParams params);

  Future<void> rejectFriendshipRequest(UpdateFriendshipRequestParams params);

  Future<void> cancelFriendshipRequest(UpdateFriendshipRequestParams params);
}
