// ignore_for_file: avoid_web_libraries_in_flutter, avoid_returning_null_for_void
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:universal_html/html.dart' as web;

class AppNotify {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = sl();

  const AppNotify._();

  static void onNotificationTap(NotificationResponse notificationResponse) {
    notificationResponse.payload!;
  }

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) => null);
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  static Future<void> showNotification(
      {required String title,
      String? body,
      dynamic payload,
      String? icon}) async {
    if (kIsWeb) {
      var permission = web.Notification.permission;
      if (permission != 'granted') {
        permission = await web.Notification.requestPermission();
      }
      if (permission == 'granted') {
        web.Notification(title, body: body, icon: icon).onClick.listen((event) {
          Navigator.of(payload['context']).pushNamed(
            payload['route'],
            arguments: payload['arguments'],
          );
        });
      }
      return;
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'sos id',
      'sos name',
      channelDescription: 'sos description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload.toString());
  }
}
