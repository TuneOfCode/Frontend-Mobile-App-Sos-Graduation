// ignore_for_file: constant_identifier_names

class ApiConfig {
  const ApiConfig._();
  static const HOST = '192.168.1.7'; // 192.168.1.7
  // kIsWeb
  //     ? 'localhost'
  //     : '192.168.1.7'; // web: localhost, emulator android: 10.0.2.2
  static const PORT = "6868"; // https: 7162, http: 5032
  static const BASE_URL = "http://$HOST:$PORT/api";
  static const BASE_SOCKET_URL = "http://$HOST:$PORT";
  static const BASE_IMAGE_URL = "http://$HOST:$PORT";

  // // use ngrok host
  // static const BASE_URL = "https://correct-pegasus-rich.ngrok-free.app/api";
  // static const BASE_IMAGE_URL = "https://correct-pegasus-rich.ngrok-free.app";
}

class AuthenticationEndpoint {
  const AuthenticationEndpoint._();
  static const ROOT = "/authentication";
  static const LOGIN = "$ROOT/login";
  static const VERIFY = "$ROOT/verify";
  static const RESEND = "$ROOT/resend-verify-code";
  static const REGISTER = "$ROOT/register";
  static const ME = "$ROOT/me";
}

class UserEndpoint {
  const UserEndpoint._();
  static const ROOT = "/users";
  static const CHANGE_PASSWORD = "change-password";
  static const UPDATE_LOCATION = "update-location";
}

class FriendshipRequestEndpoint {
  const FriendshipRequestEndpoint._();
  static const ROOT = "/friendship-requests";
  static const GET_SENT = "sent";
  static const GET_RECEIVED = "received";
  static const ACCEPT = "accept";
  static const REJECT = "reject";
  static const CANCEL = "cancel";
}

class FriendshipEndpoint {
  const FriendshipEndpoint._();
  static const ROOT = "/friendships";
  static const GET_RECOMMEND = "recommend";
  static const REMOVE = "remove";
}
