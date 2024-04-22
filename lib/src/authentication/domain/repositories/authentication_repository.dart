import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/entities/auth.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/login_user.params.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  ResultVoid createUser(CreateUserParams params);

  ResultFuture<List<User>> getUsers();

  ResultFuture<Auth> loginUser(LoginUserParams params);

  ResultFuture<User> getProfile();

  ResultVoid updateUser(UpdateUserParams params);
}
