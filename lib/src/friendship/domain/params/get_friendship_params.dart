import 'package:equatable/equatable.dart';

class GetFriendshipParams extends Equatable {
  final String userId;
  final int? page;
  final int? pageSize;

  const GetFriendshipParams({
    required this.userId,
    this.page,
    this.pageSize,
  });

  @override
  List<Object?> get props => [userId];
}
