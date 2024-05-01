import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/friendship/domain/params/create_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/repositories/friendship_request_repository.dart';

class CreateFriendshipRequest
    extends UsecaseWithParams<void, CreateFriendshipRequestParams> {
  final FriendshipRequestRepository _repository;

  const CreateFriendshipRequest(this._repository);

  @override
  ResultFuture<void> call(CreateFriendshipRequestParams params) {
    return _repository.createFriendshipRequest(CreateFriendshipRequestParams(
      senderId: params.senderId,
      receiverId: params.receiverId,
    ));
  }
}
