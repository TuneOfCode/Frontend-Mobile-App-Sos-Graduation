import 'package:sos_app/core/services/api_interceptor_service.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:sos_app/src/authentication/domain/entities/auth.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/login_user.params.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource _remoteDataSource;

  const AuthenticationRepositoryImpl(this._remoteDataSource);

  @override
  ResultVoid createUser(CreateUserParams params) {
    return apiInterceptorService(() => _remoteDataSource.createUser(params));
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    return apiInterceptorService(() => _remoteDataSource.getUsers());
  }

  @override
  ResultFuture<Auth> loginUser(LoginUserParams params) async {
    return apiInterceptorService(() => _remoteDataSource.loginUser(params));
  }

  @override
  ResultFuture<User> getProfile() {
    return apiInterceptorService(() => _remoteDataSource.getProfile());
  }

  @override
  ResultVoid updateUser(UpdateUserParams params) {
    return apiInterceptorService(() => _remoteDataSource.updateUser(params));
  }
}
