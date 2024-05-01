import 'package:equatable/equatable.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/login_user.params.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CreateUserEvent extends AuthenticationEvent {
  final CreateUserParams params;

  const CreateUserEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class GetUsersEvent extends AuthenticationEvent {
  const GetUsersEvent();

  @override
  List<Object> get props => [];
}

class LoginUserEvent extends AuthenticationEvent {
  final LoginUserParams params;

  const LoginUserEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class GetProfileEvent extends AuthenticationEvent {
  const GetProfileEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserEvent extends AuthenticationEvent {
  final UpdateUserParams params;

  const UpdateUserEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class LogoutUserEvent extends AuthenticationEvent {
  const LogoutUserEvent();

  @override
  List<Object> get props => [];
}
