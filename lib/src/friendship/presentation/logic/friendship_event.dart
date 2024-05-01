import 'package:equatable/equatable.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/params/remove_friendship_params.dart';

abstract class FriendshipEvent extends Equatable {
  const FriendshipEvent();

  @override
  List<Object> get props => [];
}

class GetFriendshipsEvent extends FriendshipEvent {
  final GetFriendshipParams params;

  const GetFriendshipsEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class GetFriendshipRecommendsEvent extends FriendshipEvent {
  final GetFriendshipParams params;

  const GetFriendshipRecommendsEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class RemoveFriendshipEvent extends FriendshipEvent {
  final RemoveFriendshipParams params;

  const RemoveFriendshipEvent({required this.params});

  @override
  List<Object> get props => [params];
}
