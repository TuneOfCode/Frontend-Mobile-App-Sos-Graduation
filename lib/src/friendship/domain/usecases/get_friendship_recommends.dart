import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/repositories/friendship_repository.dart';

class GetFriendshipRecommends
    extends UsecaseWithParams<List<User>, GetFriendshipParams> {
  final FriendshipRepository _repository;

  const GetFriendshipRecommends(this._repository);

  @override
  ResultFuture<List<User>> call(GetFriendshipParams params) {
    return _repository.getFriendshipRecommends(
      GetFriendshipParams(
        userId: params.userId,
        page: params.page,
        pageSize: params.pageSize,
      ),
    );
  }
}
