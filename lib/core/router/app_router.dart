import 'package:flutter/material.dart';
import 'package:sos_app/pages/home_page.dart';
import 'package:sos_app/src/authentication/presentation/views/auth_screen.dart';
import 'package:sos_app/src/authentication/presentation/views/change_password_screen.dart';
import 'package:sos_app/src/authentication/presentation/views/profile_screen.dart';
import 'package:sos_app/src/authentication/presentation/views/setting_screen.dart';
import 'package:sos_app/src/authentication/presentation/views/update_profile_screen.dart';
import 'package:sos_app/src/friendship/presentation/views/contact_screen.dart';
import 'package:sos_app/src/friendship/presentation/widgets/get_user_media_sample.dart';
import 'package:sos_app/src/notifications/presentation/views/notification_screen.dart';

class AppRouter {
  // home
  static const String home = '/';
  // authentication
  static const String authentication = '/authentication';
  static const String forgotPassword = '/forgot-password';
  static const String profile = '/profile';
  static const String changePassword = '/change-password';
  static const String setting = '/setting';
  // users
  static const String updateProfile = '/update-profile';
  static const String videoCall = '/video-call';
  // contacts
  static const String contacts = '/contacts';
  // notification
  static const String notifications = '/notifications';

  static Route<dynamic> onGenerateRoute(RouteSettings route) {
    switch (route.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case authentication:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case setting:
        return MaterialPageRoute(builder: (_) => const SettingScreen());
      case updateProfile:
        return MaterialPageRoute(builder: (_) => const UpdateProfileScreen());
      case contacts:
        return MaterialPageRoute(
            builder: (_) => ContactScreen(tabIndex: route.arguments as int));
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case videoCall:
        return MaterialPageRoute(builder: (_) => const GetUserMediaSample());
      default:
        throw Exception('Không tìm thấy định tuyến!');
    }
  }
}
