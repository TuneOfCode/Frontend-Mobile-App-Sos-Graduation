import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/repositories/friendship_repository.dart';

class GetFriendships
    extends UsecaseWithParams<List<Friendship>, GetFriendshipParams> {
  final FriendshipRepository _repository;

  const GetFriendships(this._repository);

  @override
  ResultFuture<List<Friendship>> call(GetFriendshipParams params) {
    return _repository.getFriendships(
      GetFriendshipParams(
        userId: params.userId,
        page: params.page,
        pageSize: params.pageSize,
      ),
    );
  }
}
