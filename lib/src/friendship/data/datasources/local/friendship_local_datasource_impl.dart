import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:sos_app/core/constants/local_datasource_constant.dart';
import 'package:sos_app/src/friendship/data/datasources/local/friendship_local_datasource.dart';
import 'package:sos_app/src/friendship/data/models/friendship_model.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship.dart';

class FriendshipLocalDataSourceImpl implements FriendshipLocalDataSource {
  final box = GetStorage();

  @override
  Future<List<Friendship>> getFriendships() {
    List<Friendship> friendships = [];
    final data = box.read(LocalDataSource.FRIENDSHIPS);

    if (data != null) {
      friendships = List<Friendship>.from(
          jsonDecode(data).map((x) => FriendshipModel.fromJson(x)));
    }
    return Future.value(friendships);
  }

  @override
  Future<void> setFriendships(String value) async {
    await box.write(LocalDataSource.FRIENDSHIPS, value);
  }

  @override
  Future<void> clearFriendships() async {
    await box.remove(LocalDataSource.FRIENDSHIPS);
  }
}
