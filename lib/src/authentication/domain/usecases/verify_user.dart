import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/params/verify_user_params.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';

class VerifyUser extends UsecaseWithParams<void, VerifyUserParams> {
  final AuthenticationRepository _repository;

  const VerifyUser(this._repository);

  @override
  ResultFuture<void> call(VerifyUserParams params) async =>
      _repository.verifyUser(
        VerifyUserParams(
          email: params.email,
          code: params.code,
        ),
      );
}
