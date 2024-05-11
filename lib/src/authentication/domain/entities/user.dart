// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String fullName;
  final String firstName;
  final String lastName;
  final String email;
  final String contactPhone;
  final String avatarUrl;
  double longitude;
  double latitude;
  final String verifiedAt;
  final String createdAt;

  User({
    required this.userId,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactPhone,
    required this.avatarUrl,
    required this.longitude,
    required this.latitude,
    required this.verifiedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        userId,
        email,
      ];
}
