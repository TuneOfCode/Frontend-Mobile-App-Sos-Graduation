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
