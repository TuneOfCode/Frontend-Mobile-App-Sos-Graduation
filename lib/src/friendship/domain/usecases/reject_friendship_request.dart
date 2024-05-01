import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/friendship/domain/params/update_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/repositories/friendship_request_repository.dart';

class RejectFriendshipRequest
    extends UsecaseWithParams<void, UpdateFriendshipRequestParams> {
  final FriendshipRequestRepository _repository;

  const RejectFriendshipRequest(this._repository);

  @override
  ResultFuture<void> call(UpdateFriendshipRequestParams params) {
    return _repository.rejectFriendshipRequest(UpdateFriendshipRequestParams(
      friendshipRequestId: params.friendshipRequestId,
    ));
  }
}
