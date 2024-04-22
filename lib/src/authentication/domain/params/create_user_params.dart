import 'package:equatable/equatable.dart';

class CreateUserParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String contactPhone;
  final String password;
  final String confirmPassword;

  const CreateUserParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.contactPhone,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        contactPhone,
        password,
        confirmPassword,
      ];
}
