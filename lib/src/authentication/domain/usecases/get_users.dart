import 'package:sos_app/core/usecases/usecase.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends Usecase<List<User>> {
  final AuthenticationRepository _repository;

  const GetUsers(this._repository);

  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}
