import 'package:flutter/material.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';

class GetUsersListView extends StatelessWidget {
  final List<User> users;

  const GetUsersListView({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          // scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final avatarUrl = "${ApiConfig.BASE_IMAGE_URL}${user.avatarUrl}";
            return ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: Image.network(avatarUrl).image,
              ),
              title: Text(user.fullName),
              subtitle: Text(user.email),
            );
          }),
    );
  }
}
