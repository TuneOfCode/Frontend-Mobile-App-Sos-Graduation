import 'package:sos_app/src/authentication/data/models/user_model.dart';
import 'package:sos_app/src/authentication/domain/entities/auth.dart';

abstract class AuthenticationLocalDataSource {
  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<Auth> getAuth();

  Future<UserModel> getCurrentUser();

  Future<void> setAccessToken(String value);

  Future<void> setRefreshToken(String value);

  Future<void> setCurrentUser(String value);

  Future<void> clearCache();
}
