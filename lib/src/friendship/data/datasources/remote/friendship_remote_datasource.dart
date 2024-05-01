import 'package:sos_app/src/authentication/data/models/user_model.dart';
import 'package:sos_app/src/friendship/data/models/friendship_model.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/params/remove_friendship_params.dart';

abstract class FriendshipRemoteDataSource {
  Future<List<FriendshipModel>> getFriendships(GetFriendshipParams params);

  Future<List<UserModel>> getFriendshipRecommends(GetFriendshipParams params);

  Future<void> removeFriendship(RemoveFriendshipParams params);
}
