import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String userId;
  final String fullName;
  final String firstName;
  final String lastName;
  final String email;
  final String contactPhone;
  final String avatarUrl;
  final String verifiedAt;
  final String createdAt;

  const User({
    required this.userId,
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactPhone,
    required this.avatarUrl,
    required this.verifiedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        userId,
        email,
      ];
}
