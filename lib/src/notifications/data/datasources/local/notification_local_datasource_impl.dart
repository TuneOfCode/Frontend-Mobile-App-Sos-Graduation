import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:sos_app/core/constants/local_datasource_constant.dart';
import 'package:sos_app/src/notifications/data/datasources/local/notification_local_datasource.dart';
import 'package:sos_app/src/notifications/data/models/notification_model.dart';
import 'package:sos_app/src/notifications/domain/entities/notification.dart';

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final box = GetStorage();

  @override
  Future<void> clearNotifications() async {
    await box.remove(LocalDataSource.NOTIFICATIONS);
  }

  @override
  Future<List<NotificationEntity>> getNotifications() {
    List<NotificationEntity> notifications = [];
    final data = box.read(LocalDataSource.NOTIFICATIONS);

    if (data != null) {
      notifications = List<NotificationEntity>.from(
          jsonDecode(data).map((x) => NotificationModel.fromJson(x)));
    }
    return Future.value(notifications);
  }

  @override
  Future<void> setNotifications(String value) async {
    await box.write(LocalDataSource.NOTIFICATIONS, value);
  }
}
