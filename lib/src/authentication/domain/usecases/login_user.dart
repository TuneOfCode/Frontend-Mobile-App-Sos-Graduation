import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/entities/auth.dart';
import 'package:sos_app/src/authentication/domain/params/login_user_params.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';

class LoginUser extends UsecaseWithParams<Auth, LoginUserParams> {
  final AuthenticationRepository _repository;

  const LoginUser(this._repository);

  @override
  ResultFuture<Auth> call(LoginUserParams params) async =>
      _repository.loginUser(
        LoginUserParams(
          email: params.email,
          password: params.password,
        ),
      );
}
