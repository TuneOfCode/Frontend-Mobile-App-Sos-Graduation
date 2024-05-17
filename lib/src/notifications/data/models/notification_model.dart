import 'dart:convert';

import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/notifications/domain/entities/notification.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.notificationId,
    required super.title,
    required super.content,
    required super.thumbnailUrl,
    required super.createdAt,
  });

  NotificationModel.fromJson(DataMap json)
      : this(
          notificationId: json['notificationId'].toString(),
          title: json['title'].toString(),
          content: json['content'].toString(),
          thumbnailUrl: json['thumbnailUrl'].toString(),
          createdAt: json['createdAt'].toString(),
        );

  DataMap toJson() => {
        'notificationId': notificationId,
        'title': title,
        'content': content,
        'thumbnailUrl': thumbnailUrl,
        'createdAt': createdAt,
      };
}

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    jsonEncode(data.toJson());
