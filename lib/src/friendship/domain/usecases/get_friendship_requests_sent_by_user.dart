import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship_request.dart';
import 'package:sos_app/src/friendship/domain/params/query_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/repositories/friendship_request_repository.dart';

class GetFriendshipRequestsSentByUser extends UsecaseWithParams<
    List<FriendshipRequest>, QueryFriendshipRequestParams> {
  final FriendshipRequestRepository _repository;

  const GetFriendshipRequestsSentByUser(this._repository);

  @override
  ResultFuture<List<FriendshipRequest>> call(
      QueryFriendshipRequestParams params) {
    return _repository
        .getFriendshipRequestsSentByUser(QueryFriendshipRequestParams(
      userId: params.userId,
    ));
  }
}
