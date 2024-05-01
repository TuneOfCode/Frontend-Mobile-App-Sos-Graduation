import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/friendship/domain/params/create_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/query_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/params/update_friendship_request_params.dart';
import 'package:sos_app/src/friendship/domain/usecases/accept_friendship_request.dart';
import 'package:sos_app/src/friendship/domain/usecases/cancel_friendship_request.dart';
import 'package:sos_app/src/friendship/domain/usecases/create_friendship_request.dart';
import 'package:sos_app/src/friendship/domain/usecases/get_friendship_request_by_id.dart';
import 'package:sos_app/src/friendship/domain/usecases/get_friendship_requests_received_by_user.dart';
import 'package:sos_app/src/friendship/domain/usecases/get_friendship_requests_sent_by_user.dart';
import 'package:sos_app/src/friendship/domain/usecases/reject_friendship_request.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_event.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_request_state.dart';

class FriendshipRequestBloc
    extends Bloc<FriendshipRequestEvent, FriendshipRequestState> {
  final AuthenticationLocalDataSource _authenticationLocalDataSource;
  final GetFriendshipRequestById _getFriendshipRequestById;
  final GetFriendshipRequestsSentByUser _getFriendshipRequestsSentByUser;
  final GetFriendshipRequestsReceivedByUser
      _getFriendshipRequestsReceivedByUser;
  final CreateFriendshipRequest _createFriendshipRequest;
  final AcceptFriendshipRequest _acceptFriendshipRequest;
  final RejectFriendshipRequest _rejectFriendshipRequest;
  final CancelFriendshipRequest _cancelFriendshipRequest;

  FriendshipRequestBloc({
    required AuthenticationLocalDataSource authenticationLocalDataSource,
    required GetFriendshipRequestById getFriendshipRequestById,
    required GetFriendshipRequestsSentByUser getFriendshipRequestsSentByUser,
    required GetFriendshipRequestsReceivedByUser
        getFriendshipRequestsReceivedByUser,
    required CreateFriendshipRequest createFriendshipRequest,
    required AcceptFriendshipRequest acceptFriendshipRequest,
    required RejectFriendshipRequest rejectFriendshipRequest,
    required CancelFriendshipRequest cancelFriendshipRequest,
  })  : _authenticationLocalDataSource = authenticationLocalDataSource,
        _getFriendshipRequestById = getFriendshipRequestById,
        _getFriendshipRequestsSentByUser = getFriendshipRequestsSentByUser,
        _getFriendshipRequestsReceivedByUser =
            getFriendshipRequestsReceivedByUser,
        _createFriendshipRequest = createFriendshipRequest,
        _acceptFriendshipRequest = acceptFriendshipRequest,
        _rejectFriendshipRequest = rejectFriendshipRequest,
        _cancelFriendshipRequest = cancelFriendshipRequest,
        super(const FriendshipRequestInitial()) {
    on<GetFriendshipRequestByIdEvent>(_getFriendshipRequestByIdHandler);
    on<GetFriendshipRequestsSentByUserEvent>(
        _getFriendshipRequestsSentByUserHandler);
    on<GetFriendshipRequestsReceivedByUserEvent>(
        _getFriendshipRequestsReceivedByUserHandler);
    on<CreateFriendshipRequestEvent>(_createFriendshipRequestHandler);
    on<AcceptFriendshipRequestEvent>(_acceptFriendshipRequestHandler);
    on<RejectFriendshipRequestEvent>(_rejectFriendshipRequestHandler);
    on<CancelFriendshipRequestEvent>(_cancelFriendshipRequestHandler);
  }

  FutureOr<void> _getFriendshipRequestByIdHandler(
      GetFriendshipRequestByIdEvent event,
      Emitter<FriendshipRequestState> emit) async {
    emit(const GettingFriendshipRequestById());

    final result = await _getFriendshipRequestById.call(
      QueryFriendshipRequestParams(
        friendshipRequestId: event.params.friendshipRequestId,
      ),
    );

    result.fold(
      (failure) =>
          FriendshipRequestError(failure.errorMessageLog, failure.data),
      (friendshipRequest) =>
          emit(FriendshipRequestByIdLoaded(friendshipRequest)),
    );
  }

  FutureOr<void> _getFriendshipRequestsSentByUserHandler(
      GetFriendshipRequestsSentByUserEvent event,
      Emitter<FriendshipRequestState> emit) async {
    emit(const GettingFriendshipRequestsSentByUser());

    final result = await _getFriendshipRequestsSentByUser.call(
      QueryFriendshipRequestParams(
        userId: event.params.userId,
      ),
    );

    result.fold(
      (failure) =>
          FriendshipRequestError(failure.errorMessageLog, failure.data),
      (friendshipRequests) =>
          emit(FriendshipRequestsSentByUserLoaded(friendshipRequests)),
    );
  }

  FutureOr<void> _getFriendshipRequestsReceivedByUserHandler(
      GetFriendshipRequestsReceivedByUserEvent event,
      Emitter<FriendshipRequestState> emit) async {
    emit(const GettingFriendshipRequestsReceivedByUser());

    final result = await _getFriendshipRequestsReceivedByUser.call(
      QueryFriendshipRequestParams(
        userId: event.params.userId,
      ),
    );

    result.fold(
      (failure) =>
          FriendshipRequestError(failure.errorMessageLog, failure.data),
      (friendshipRequests) =>
          emit(FriendshipRequestsReceivedByUserLoaded(friendshipRequests)),
    );
  }

  FutureOr<void> _createFriendshipRequestHandler(
      CreateFriendshipRequestEvent event,
      Emitter<FriendshipRequestState> emit) async {
    emit(const CreatingFriendshipRequest());

    String senderId = event.params.senderId;
    if (senderId.isEmpty) {
      senderId = (await _authenticationLocalDataSource.getCurrentUser()).userId;
    }

    final result = await _createFriendshipRequest.call(
      CreateFriendshipRequestParams(
        senderId: senderId,
        receiverId: event.params.receiverId,
      ),
    );

    result.fold(
      (failure) =>
          FriendshipRequestError(failure.errorMessageLog, failure.data),
      (_) => emit(const FriendshipRequestCreated()),
    );
  }

  FutureOr<void> _acceptFriendshipRequestHandler(
      AcceptFriendshipRequestEvent event,
      Emitter<FriendshipRequestState> emit) async {
    emit(const AcceptingFriendshipRequest());

    final result = await _acceptFriendshipRequest.call(
      UpdateFriendshipRequestParams(
        friendshipRequestId: event.params.friendshipRequestId,
      ),
    );

    result.fold(
      (failure) =>
          FriendshipRequestError(failure.errorMessageLog, failure.data),
      (_) => emit(const FriendshipRequestAccepted()),
    );
  }

  FutureOr<void> _rejectFriendshipRequestHandler(
      RejectFriendshipRequestEvent event,
      Emitter<FriendshipRequestState> emit) async {
    emit(const RejectingFriendshipRequest());

    final result = await _rejectFriendshipRequest.call(
      UpdateFriendshipRequestParams(
        friendshipRequestId: event.params.friendshipRequestId,
      ),
    );

    result.fold(
      (failure) =>
          FriendshipRequestError(failure.errorMessageLog, failure.data),
      (_) => emit(const FriendshipRequestRejected()),
    );
  }

  FutureOr<void> _cancelFriendshipRequestHandler(
      CancelFriendshipRequestEvent event,
      Emitter<FriendshipRequestState> emit) async {
    emit(const CancelingFriendshipRequest());

    final result = await _cancelFriendshipRequest.call(
      UpdateFriendshipRequestParams(
        friendshipRequestId: event.params.friendshipRequestId,
      ),
    );

    result.fold(
      (failure) =>
          FriendshipRequestError(failure.errorMessageLog, failure.data),
      (_) => emit(const FriendshipRequestCancelled()),
    );
  }
}
