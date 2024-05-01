import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/domain/params/remove_friendship_params.dart';

class FriendshipModel extends Friendship {
  const FriendshipModel({
    required super.userId,
    required super.fullName,
    required super.email,
    required super.avatar,
    required super.friendId,
    required super.friendFullName,
    required super.friendEmail,
    required super.friendAvatar,
    required super.createdAt,
    required super.updatedAt,
  });

  FriendshipModel.fromJson(DataMap json)
      : this(
          userId: json['userId'].toString(),
          fullName: json['fullName'].toString(),
          email: json['email'].toString(),
          avatar: json['avatar'].toString(),
          friendId: json['friendId'].toString(),
          friendFullName: json['friendFullName'].toString(),
          friendEmail: json['friendEmail'].toString(),
          friendAvatar: json['friendAvatar'].toString(),
          createdAt: json['createdAt'].toString(),
          updatedAt: json['updatedAt'].toString(),
        );

  static DataMap toQueryParams(GetFriendshipParams params) {
    if (!params.page!.isNaN) {
      return {
        'page': params.page.toString(),
      };
    }

    return {
      'page': params.page.toString(),
      'pageSize': params.pageSize.toString(),
    };
  }

  static DataMap toRemoveFriendship(RemoveFriendshipParams params) => {
        'userId': params.userId,
        'friendId': params.friendId,
      };
}
