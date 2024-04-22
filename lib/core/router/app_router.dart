import 'package:flutter/material.dart';
import 'package:sos_app/pages/home_page.dart';
import 'package:sos_app/src/authentication/presentation/views/auth_screen.dart';
import 'package:sos_app/src/authentication/presentation/views/profile_screen.dart';
import 'package:sos_app/src/authentication/presentation/views/update_profile_screen.dart';

class AppRouter {
  // home
  static const String home = '/';
  // authentication
  static const String authentication = '/authentication';
  static const String forgotPassword = '/forgot-password';
  static const String profile = '/profile';
  static const String changePassword = '/change-password';
  // users
  static const String updateProfile = '/update-profile';

  static Route<dynamic> onGenerateRoute(RouteSettings rouute) {
    switch (rouute.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case authentication:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case updateProfile:
        return MaterialPageRoute(builder: (_) => const UpdateProfileScreen());
      default:
        throw Exception('Không tìm thấy định tuyến!');
    }
  }
}
