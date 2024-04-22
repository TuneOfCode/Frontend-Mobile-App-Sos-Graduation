import 'package:sos_app/src/authentication/data/models/user_model.dart';
import 'package:sos_app/src/authentication/domain/entities/auth.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/login_user.params.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser(CreateUserParams params);

  Future<List<UserModel>> getUsers();

  Future<Auth> loginUser(LoginUserParams params);

  Future<UserModel> getProfile();

  Future<void> updateUser(UpdateUserParams params);
}
