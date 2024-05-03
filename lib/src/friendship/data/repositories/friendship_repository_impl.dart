import 'package:sos_app/core/services/api_interceptor_service.dart';
import 'package:sos_app/core/services/network_info_service.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';
import 'package:sos_app/src/friendship/data/datasources/local/friendship_local_datasource.dart';
import 'package:sos_app/src/friendship/data/datasources/remote/friendship_remote_datasource.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/params/remove_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/repositories/friendship_repository.dart';

class FriendshipRepositoryImpl implements FriendshipRepository {
  final FriendshipRemoteDataSource _remote;
  final FriendshipLocalDataSource _local;
  final NetworkInfoService _networkInfo;

  const FriendshipRepositoryImpl(
    this._remote,
    this._local,
    this._networkInfo,
  );

  @override
  ResultFuture<List<Friendship>> getFriendships(
      GetFriendshipParams params) async {
    List<Friendship> friendships = await _local.getFriendships();
    if (!await _networkInfo.isConnected || friendships.isNotEmpty) {
      return apiInterceptorService(() => _local.getFriendships());
    }
    return apiInterceptorService(() => _remote.getFriendships(params));
  }

  @override
  ResultVoid removeFriendship(RemoveFriendshipParams params) {
    return apiInterceptorService(() => _remote.removeFriendship(params));
  }

  @override
  ResultFuture<List<User>> getFriendshipRecommends(GetFriendshipParams params) {
    return apiInterceptorService(() => _remote.getFriendshipRecommends(params));
  }
}
