import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/params/remove_friendship_params.dart';

abstract class FriendshipRepository {
  const FriendshipRepository();

  ResultFuture<List<Friendship>> getFriendships(GetFriendshipParams params);

  ResultFuture<List<User>> getFriendshipRecommends(GetFriendshipParams params);

  ResultVoid removeFriendship(RemoveFriendshipParams params);
}
