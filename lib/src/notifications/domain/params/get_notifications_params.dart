import 'package:equatable/equatable.dart';

class GetNotificationsParams extends Equatable {
  final String userId;

  const GetNotificationsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
