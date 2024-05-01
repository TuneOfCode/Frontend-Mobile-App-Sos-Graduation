import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sos_app/core/constants/local_datasource_constant.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/authentication/data/models/user_model.dart';
import 'package:sos_app/src/authentication/domain/entities/auth.dart';

class AuthenticationLocalDataSourceImpl
    implements AuthenticationLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  const AuthenticationLocalDataSourceImpl(this._secureStorage);

  @override
  Future<void> setAccessToken(String value) async {
    await _secureStorage.write(key: LocalDataSource.ACCESS_TOKEN, value: value);
  }

  @override
  Future<void> setRefreshToken(String value) async {
    await _secureStorage.write(
        key: LocalDataSource.REFRESH_TOKEN, value: value);
  }

  @override
  Future<void> setCurrentUser(String value) async {
    // final box = GetStorage(LocalDataSource.CURRENT_USER);
    // await box.write(LocalDataSource.CURRENT_USER, value);
    await _secureStorage.write(key: LocalDataSource.CURRENT_USER, value: value);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: LocalDataSource.ACCESS_TOKEN);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: LocalDataSource.REFRESH_TOKEN);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // final box = GetStorage(LocalDataSource.CURRENT_USER);
    // final data = box.read(LocalDataSource.CURRENT_USER);

    final data = await _secureStorage.read(key: LocalDataSource.CURRENT_USER);

    UserModel userModel = await UserModel.empty();

    if (data != null && data.isNotEmpty) {
      userModel = userModelFromJson(data);
    }

    // logger.f('getCurrentUser: $userModel');

    return userModel;
  }

  @override
  Future<void> clearCache() async {
    await _secureStorage.deleteAll();
    final box = GetStorage();
    await box.erase();
  }

  @override
  Future<Auth> getAuth() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return Auth(accessToken: accessToken!, refreshToken: refreshToken!);
  }
}
