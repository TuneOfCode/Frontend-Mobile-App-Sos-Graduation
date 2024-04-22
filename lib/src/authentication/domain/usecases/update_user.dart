import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';

class UpdateUser extends UsecaseWithParams<void, UpdateUserParams> {
  final AuthenticationRepository _repository;

  const UpdateUser(this._repository);

  @override
  ResultFuture<void> call(UpdateUserParams params) async =>
      _repository.updateUser(
        UpdateUserParams(
          userId: params.userId,
          firstName: params.firstName,
          lastName: params.lastName,
          contactPhone: params.contactPhone,
          avatar: params.avatar,
        ),
      );
}
