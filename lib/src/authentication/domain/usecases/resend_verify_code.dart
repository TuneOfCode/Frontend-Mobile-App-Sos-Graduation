import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/params/resend_verify_code_params.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';

class ResendVerifyCode extends UsecaseWithParams<void, ResendVerifyCodeParams> {
  final AuthenticationRepository _repository;

  const ResendVerifyCode(this._repository);

  @override
  ResultFuture<void> call(ResendVerifyCodeParams params) async =>
      _repository.resendVerifyCode(
        ResendVerifyCodeParams(
          email: params.email,
        ),
      );
}
