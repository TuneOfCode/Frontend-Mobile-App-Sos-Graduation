import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sos_app/core/constants/local_storage_constant.dart';

class AuthenticationLocalStorage {
  final FlutterSecureStorage _localStorage;

  const AuthenticationLocalStorage(this._localStorage);

  Future<bool> isAccessTokenExist() async {
    return await _localStorage.containsKey(
      key: LocalStorage.LOGIN_ACCESS_TOKEN,
    );
  }

  Future<bool> isRefreshTokenExist() async {
    return await _localStorage.containsKey(
      key: LocalStorage.LOGIN_REFRESH_TOKEN,
    );
  }

  Future<void> setAccessToken({required String value}) async {
    await _localStorage.write(
        key: LocalStorage.LOGIN_ACCESS_TOKEN, value: value);
  }

  Future<String?> setRefreshToken({required String value}) async {
    return await _localStorage.read(key: LocalStorage.LOGIN_REFRESH_TOKEN);
  }

  Future<String?> getAccessToken() async {
    return await _localStorage.read(key: LocalStorage.LOGIN_ACCESS_TOKEN);
  }

  Future<String?> getRefreshToken() async {
    return await _localStorage.read(key: LocalStorage.LOGIN_REFRESH_TOKEN);
  }
}
