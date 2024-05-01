import 'package:equatable/equatable.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship.dart';

abstract class FriendshipState extends Equatable {
  const FriendshipState();

  @override
  List<Object> get props => [];
}

class FriendshipInitial extends FriendshipState {
  const FriendshipInitial();
}

// get friendships
class GettingFriendships extends FriendshipState {
  const GettingFriendships();
}

class FriendshipsLoaded extends FriendshipState {
  final List<Friendship> friendships;

  const FriendshipsLoaded(this.friendships);

  @override
  List<Object> get props => [friendships];
}

// get friendship recommends
class GettingFriendshipRecommends extends FriendshipState {
  const GettingFriendshipRecommends();
}

class FriendshipRecommendsLoaded extends FriendshipState {
  final List<User> users;

  const FriendshipRecommendsLoaded(this.users);

  @override
  List<Object> get props => [users];
}

// remove friendship
class RemovingFriendship extends FriendshipState {
  const RemovingFriendship();
}

class FriendshipRemoved extends FriendshipState {
  const FriendshipRemoved();
}

class FriendshipError extends FriendshipState {
  final String message;
  final dynamic data;

  const FriendshipError(this.message, this.data);

  @override
  List<Object> get props => [message, data];
}
