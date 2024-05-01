import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/params/remove_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/usecases/get_friendship_recommends.dart';
import 'package:sos_app/src/friendship/domain/usecases/get_friendships.dart';
import 'package:sos_app/src/friendship/domain/usecases/remove_friendship.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_event.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_state.dart';

class FriendshipBloc extends Bloc<FriendshipEvent, FriendshipState> {
  final GetFriendships _getFriendships;
  final GetFriendshipRecommends _getFriendshipRecommends;
  final RemoveFriendship _removeFriendship;

  FriendshipBloc({
    required GetFriendships getFriendships,
    required GetFriendshipRecommends getFriendshipRecommends,
    required RemoveFriendship removeFriendship,
  })  : _getFriendships = getFriendships,
        _getFriendshipRecommends = getFriendshipRecommends,
        _removeFriendship = removeFriendship,
        super(const FriendshipInitial()) {
    on<GetFriendshipsEvent>(_getFriendshipsHandler);
    on<GetFriendshipRecommendsEvent>(_getFriendshipRecommendsHandler);
    on<RemoveFriendshipEvent>(_removeFriendshipHandler);
  }

  FutureOr<void> _getFriendshipsHandler(
      GetFriendshipsEvent event, Emitter<FriendshipState> emit) async {
    emit(const GettingFriendships());

    final result = await _getFriendships.call(
      GetFriendshipParams(
          userId: event.params.userId,
          page: event.params.page,
          pageSize: event.params.pageSize),
    );

    result.fold(
      (failure) => FriendshipError(failure.errorMessageLog, failure.data),
      (friendships) => emit(FriendshipsLoaded(friendships)),
    );
  }

  FutureOr<void> _removeFriendshipHandler(
      RemoveFriendshipEvent event, Emitter<FriendshipState> emit) async {
    emit(const RemovingFriendship());

    final result = await _removeFriendship.call(
      RemoveFriendshipParams(
        userId: event.params.userId,
        friendId: event.params.friendId,
      ),
    );

    result.fold(
      (failure) => FriendshipError(failure.errorMessageLog, failure.data),
      (_) => emit(const FriendshipRemoved()),
    );
  }

  FutureOr<void> _getFriendshipRecommendsHandler(
      GetFriendshipRecommendsEvent event, Emitter<FriendshipState> emit) async {
    emit(const GettingFriendshipRecommends());

    final result = await _getFriendshipRecommends.call(
      GetFriendshipParams(
        userId: event.params.userId,
        page: event.params.page,
        pageSize: event.params.pageSize,
      ),
    );

    result.fold(
      (failure) => FriendshipError(failure.errorMessageLog, failure.data),
      (users) => emit(FriendshipRecommendsLoaded(users)),
    );
  }
}
