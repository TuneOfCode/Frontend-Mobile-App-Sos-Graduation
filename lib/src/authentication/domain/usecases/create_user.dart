import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';

import '../params/create_user_params.dart';

class CreateUser extends UsecaseWithParams<void, CreateUserParams> {
  final AuthenticationRepository _repository;

  const CreateUser(this._repository);

  @override
  ResultFuture<void> call(CreateUserParams params) async =>
      _repository.createUser(
        CreateUserParams(
          firstName: params.firstName,
          lastName: params.lastName,
          email: params.email,
          contactPhone: params.contactPhone,
          password: params.password,
          confirmPassword: params.confirmPassword,
        ),
      );
}
