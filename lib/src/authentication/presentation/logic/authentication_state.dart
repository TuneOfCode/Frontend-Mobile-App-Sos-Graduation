import 'package:equatable/equatable.dart';
import 'package:sos_app/src/authentication/domain/entities/auth.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

// create user state
class CreatingUser extends AuthenticationState {
  const CreatingUser();
}

class UserCreated extends AuthenticationState {
  const UserCreated();
}

class CreateUserError extends AuthenticationState {
  final String message;
  final dynamic errors;

  const CreateUserError(this.message, this.errors);

  @override
  List<Object?> get props => [message, errors];
}

// get user state
class GettingUsers extends AuthenticationState {
  const GettingUsers();
}

class UsersLoaded extends AuthenticationState {
  final List<User> users;

  const UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

// login user state
class LoggingUser extends AuthenticationState {
  const LoggingUser();
}

class UserLogged extends AuthenticationState {
  final Auth auth;

  const UserLogged(this.auth);

  @override
  List<Object?> get props => [auth];
}

class LoggingUserError extends AuthenticationState {
  final String message;
  final dynamic errors;

  const LoggingUserError(this.message, this.errors);

  @override
  List<Object?> get props => [message, errors];
}

// verify user state
class VerifingUser extends AuthenticationState {
  const VerifingUser();
}

class UserVerified extends AuthenticationState {
  const UserVerified();

  @override
  List<Object?> get props => [];
}

class VerifyUserError extends AuthenticationState {
  final String message;
  final dynamic errors;

  const VerifyUserError(this.message, this.errors);

  @override
  List<Object?> get props => [message, errors];
}

// resend verify code state
class ResendingVerifyCode extends AuthenticationState {
  const ResendingVerifyCode();
}

class VerifyCodeResent extends AuthenticationState {
  const VerifyCodeResent();

  @override
  List<Object?> get props => [];
}

// get profile state

class GettingProfile extends AuthenticationState {
  const GettingProfile();
}

class ProfileLoaded extends AuthenticationState {
  final User user;

  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

// update user state
class UpdatingUser extends AuthenticationState {
  const UpdatingUser();
}

class UserUpdated extends AuthenticationState {
  const UserUpdated();
}

class UpdateUserError extends AuthenticationState {
  final String message;
  final dynamic errors;

  const UpdateUserError(this.message, this.errors);

  @override
  List<Object?> get props => [message, errors];
}

// change password state
class ChangingPassword extends AuthenticationState {
  const ChangingPassword();
}

class PasswordChanged extends AuthenticationState {
  const PasswordChanged();
}

class ChangePasswordError extends AuthenticationState {
  final String message;
  final dynamic errors;

  const ChangePasswordError(this.message, this.errors);

  @override
  List<Object?> get props => [message, errors];
}

// update location state
class UpdatingLocation extends AuthenticationState {
  const UpdatingLocation();
}

class LocationUpdated extends AuthenticationState {
  const LocationUpdated();
}

class UpdateLocationError extends AuthenticationState {
  final String message;
  final dynamic errors;

  const UpdateLocationError(this.message, this.errors);

  @override
  List<Object?> get props => [message, errors];
}

// logout user state
class LoggingUserOut extends AuthenticationState {
  const LoggingUserOut();
}

class UserLoggedOut extends AuthenticationState {
  const UserLoggedOut();
}

// general state
class AuthenticationError extends AuthenticationState {
  final String message;

  const AuthenticationError(this.message);

  @override
  List<Object?> get props => [message];
}
