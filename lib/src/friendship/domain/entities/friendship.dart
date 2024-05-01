import 'package:equatable/equatable.dart';

class Friendship extends Equatable {
  final String userId;
  final String fullName;
  final String email;
  final String avatar;
  final String friendId;
  final String friendFullName;
  final String friendEmail;
  final String friendAvatar;
  final String createdAt;
  final String updatedAt;

  const Friendship({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.avatar,
    required this.friendId,
    required this.friendFullName,
    required this.friendEmail,
    required this.friendAvatar,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [userId, friendId];
}
