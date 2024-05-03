import 'package:equatable/equatable.dart';

class VerifyUserParams extends Equatable {
  final String email;
  final String code;

  const VerifyUserParams({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];
}
