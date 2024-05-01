import 'package:sos_app/core/services/api_interceptor_service.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/friendship/data/datasources/remote/friendship_request_remote_datasource.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship_request.dart';
import 'package:sos_app/src/friendship/domain/params/create_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/query_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/update_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/repositories/friendship_request_repository.dart';

class FriendshipRequestRepositoryImpl implements FriendshipRequestRepository {
  final FriendshipRequestRemoteDataSource _remote;

  const FriendshipRequestRepositoryImpl(this._remote);

  @override
  ResultVoid acceptFriendshipRequest(UpdateFriendshipRequestParams params) {
    return apiInterceptorService(() => _remote.acceptFriendshipRequest(params));
  }

  @override
  ResultVoid cancelFriendshipRequest(UpdateFriendshipRequestParams params) {
    return apiInterceptorService(() => _remote.cancelFriendshipRequest(params));
  }

  @override
  ResultVoid createFriendshipRequest(CreateFriendshipRequestParams params) {
    return apiInterceptorService(() => _remote.createFriendshipRequest(params));
  }

  @override
  ResultFuture<FriendshipRequest> getFriendshipRequestById(
      QueryFriendshipRequestParams params) {
    return apiInterceptorService(
        () => _remote.getFriendshipRequestById(params));
  }

  @override
  ResultFuture<List<FriendshipRequest>> getFriendshipRequestsReceivedByUser(
      QueryFriendshipRequestParams params) {
    return apiInterceptorService(
        () => _remote.getFriendshipRequestsReceivedByUser(params));
  }

  @override
  ResultFuture<List<FriendshipRequest>> getFriendshipRequestsSentByUser(
      QueryFriendshipRequestParams params) {
    return apiInterceptorService(
        () => _remote.getFriendshipRequestsSentByUser(params));
  }

  @override
  ResultVoid rejectFriendshipRequest(UpdateFriendshipRequestParams params) {
    return apiInterceptorService(() => _remote.rejectFriendshipRequest(params));
  }
}
