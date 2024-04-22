import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';

class GetProfile extends Usecase<User> {
  final AuthenticationRepository _repository;

  const GetProfile(this._repository);

  @override
  ResultFuture<User> call() async => _repository.getProfile();
}
