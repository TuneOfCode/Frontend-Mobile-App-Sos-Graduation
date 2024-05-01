import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship_request.dart';
import 'package:sos_app/src/friendship/domain/params/query_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/repositories/friendship_request_repository.dart';

class GetFriendshipRequestById
    extends UsecaseWithParams<FriendshipRequest, QueryFriendshipRequestParams> {
  final FriendshipRequestRepository _repository;

  const GetFriendshipRequestById(this._repository);

  @override
  ResultFuture<FriendshipRequest> call(QueryFriendshipRequestParams params) {
    return _repository.getFriendshipRequestById(QueryFriendshipRequestParams(
      friendshipRequestId: params.friendshipRequestId,
    ));
  }
}
