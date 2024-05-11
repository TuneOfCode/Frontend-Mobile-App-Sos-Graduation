import 'package:equatable/equatable.dart';
import 'package:sos_app/src/authentication/domain/params/change_password_params.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/login_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/resend_verify_code_params.dart';
import 'package:sos_app/src/authentication/domain/params/update_location_params.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/verify_user_params.dart';

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

class VerifyUserEvent extends AuthenticationEvent {
  final VerifyUserParams params;

  const VerifyUserEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class ResendVerifyCodeEvent extends AuthenticationEvent {
  final ResendVerifyCodeParams params;

  const ResendVerifyCodeEvent({required this.params});

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

class ChangePasswordEvent extends AuthenticationEvent {
  final ChangePasswordParams params;

  const ChangePasswordEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class UpdateLocationEvent extends AuthenticationEvent {
  final UpdateLocationParams params;

  const UpdateLocationEvent({required this.params});

  @override
  List<Object> get props => [params];
}

class LogoutUserEvent extends AuthenticationEvent {
  const LogoutUserEvent();

  @override
  List<Object> get props => [];
}
