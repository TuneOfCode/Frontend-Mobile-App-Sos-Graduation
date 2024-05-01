import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/friendship/domain/params/remove_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/repositories/friendship_repository.dart';

class RemoveFriendship extends UsecaseWithParams<void, RemoveFriendshipParams> {
  final FriendshipRepository _repository;

  const RemoveFriendship(this._repository);

  @override
  ResultFuture<void> call(RemoveFriendshipParams params) {
    return _repository.removeFriendship(RemoveFriendshipParams(
      userId: params.userId,
      friendId: params.friendId,
    ));
  }
}
