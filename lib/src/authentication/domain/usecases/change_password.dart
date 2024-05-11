import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/params/change_password_params.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';

class ChangePassword extends UsecaseWithParams<void, ChangePasswordParams> {
  final AuthenticationRepository _repository;

  const ChangePassword(this._repository);

  @override
  ResultFuture<void> call(ChangePasswordParams params) async =>
      _repository.changePassword(
        ChangePasswordParams(
            userId: params.userId,
            currentPassword: params.currentPassword,
            password: params.password,
            confirmPassword: params.confirmPassword),
      );
}
