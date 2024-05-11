import 'package:sos_app/core/services/api_interceptor_service.dart';
import 'package:sos_app/core/services/network_info_service.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/authentication/data/datasources/remote/authentication_remote_datasource.dart';
import 'package:sos_app/src/authentication/data/models/user_model.dart';
import 'package:sos_app/src/authentication/domain/entities/auth.dart';
import 'package:sos_app/src/authentication/domain/params/change_password_params.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/login_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/resend_verify_code_params.dart';
import 'package:sos_app/src/authentication/domain/params/update_location_params.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';
import 'package:sos_app/src/authentication/domain/params/verify_user_params.dart';
import 'package:sos_app/src/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource _remoteDataSource;
  final AuthenticationLocalDataSource _localDataSource;
  final NetworkInfoService _networkInfo;

  const AuthenticationRepositoryImpl(
      this._remoteDataSource, this._localDataSource, this._networkInfo);

  @override
  ResultVoid createUser(CreateUserParams params) {
    return apiInterceptorService(() => _remoteDataSource.createUser(params));
  }

  @override
  ResultFuture<List<UserModel>> getUsers() {
    return apiInterceptorService(() => _remoteDataSource.getUsers());
  }

  @override
  ResultFuture<Auth> loginUser(LoginUserParams params) async {
    String? accessToken = await _localDataSource.getAccessToken();
    if (!await _networkInfo.isConnected || accessToken != null) {
      return apiInterceptorService(() => _localDataSource.getAuth());
    }

    return apiInterceptorService(() => _remoteDataSource.loginUser(params));
  }

  @override
  ResultFuture<UserModel> getProfile() async {
    final currentUser = await _localDataSource.getCurrentUser();
    if (!await _networkInfo.isConnected || currentUser.userId.isNotEmpty) {
      return apiInterceptorService(() => _localDataSource.getCurrentUser());
    }
    return apiInterceptorService(() => _remoteDataSource.getProfile());
  }

  @override
  ResultVoid updateUser(UpdateUserParams params) {
    return apiInterceptorService(() => _remoteDataSource.updateUser(params));
  }

  @override
  ResultFuture<void> resendVerifyCode(ResendVerifyCodeParams params) {
    return apiInterceptorService(
        () => _remoteDataSource.resendVerifyCode(params));
  }

  @override
  ResultVoid verifyUser(VerifyUserParams params) {
    return apiInterceptorService(() => _remoteDataSource.verifyUser(params));
  }

  @override
  ResultVoid changePassword(ChangePasswordParams params) {
    return apiInterceptorService(
        () => _remoteDataSource.changePassword(params));
  }

  @override
  ResultVoid updateLocation(UpdateLocationParams params) {
    return apiInterceptorService(
        () => _remoteDataSource.updateLocation(params));
  }
}
