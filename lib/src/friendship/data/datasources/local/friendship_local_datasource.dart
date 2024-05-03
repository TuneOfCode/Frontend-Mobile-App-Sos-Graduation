import 'package:sos_app/src/friendship/domain/entities/friendship.dart';

abstract class FriendshipLocalDataSource {
  Future<List<Friendship>> getFriendships();

  Future<void> setFriendships(String value);
}
