import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String notificationId;
  final String title;
  final String content;
  final String thumbnailUrl;
  final String createdAt;

  const NotificationEntity({
    required this.notificationId,
    required this.title,
    required this.content,
    required this.thumbnailUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        notificationId,
        title,
        content,
        thumbnailUrl,
        createdAt,
      ];
}
