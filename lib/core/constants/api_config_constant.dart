// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

class ApiConfig {
  const ApiConfig._();
  static const HOST = kIsWeb
      ? 'localhost'
      : '10.0.2.2'; // web: localhost, emulator android: 10.0.2.2
  static const PORT = "5032"; // https: 7162, http: 5032
  static const BASE_URL = "http://$HOST:$PORT/api";
  static const BASE_IMAGE_URL = "http://$HOST:$PORT";
}

class AuthenticationEndpoint {
  const AuthenticationEndpoint._();
  static const ROOT = "/authentication";
  static const LOGIN = "$ROOT/login";
  static const REGISTER = "$ROOT/register";
  static const ME = "$ROOT/me";
}

class UserEndpoint {
  const UserEndpoint._();
  static const ROOT = "/users";
}
