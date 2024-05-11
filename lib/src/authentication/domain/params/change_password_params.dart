import 'package:equatable/equatable.dart';

class ChangePasswordParams extends Equatable {
  final String userId;
  final String currentPassword;
  final String password;
  final String confirmPassword;

  const ChangePasswordParams({
    required this.userId,
    required this.currentPassword,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [
        userId,
        currentPassword,
        password,
        confirmPassword,
      ];
}
