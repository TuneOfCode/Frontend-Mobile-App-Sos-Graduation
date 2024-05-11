// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Friendship extends Equatable {
  final String userId;
  final String fullName;
  final String email;
  final String avatar;
  final double longitude;
  final double latitude;
  final String friendId;
  final String friendFullName;
  final String friendEmail;
  final String friendAvatar;
  double friendLongitude;
  double friendLatitude;
  final String createdAt;
  final String updatedAt;

  Friendship({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.avatar,
    required this.longitude,
    required this.latitude,
    required this.friendId,
    required this.friendFullName,
    required this.friendEmail,
    required this.friendAvatar,
    required this.friendLongitude,
    required this.friendLatitude,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [userId, friendId];
}
