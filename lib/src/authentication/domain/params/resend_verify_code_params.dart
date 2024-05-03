import 'package:equatable/equatable.dart';

class ResendVerifyCodeParams extends Equatable {
  final String email;

  const ResendVerifyCodeParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}
