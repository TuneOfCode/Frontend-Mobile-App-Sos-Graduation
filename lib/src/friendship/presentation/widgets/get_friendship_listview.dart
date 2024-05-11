import 'package:flutter/material.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:sos_app/core/sockets/webrtc.dart';
import 'package:sos_app/src/authentication/presentation/widgets/loading_column.dart';
import 'package:sos_app/src/friendship/data/datasources/local/friendship_local_datasource.dart';
import 'package:sos_app/src/friendship/data/models/call_info_model.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship.dart';
import 'package:sos_app/src/friendship/presentation/views/call_screen.dart';

class GetFriendshipListView extends StatefulWidget {
  const GetFriendshipListView({
    super.key,
  });

  @override
  State<GetFriendshipListView> createState() => _GetFriendshipListViewState();
}

class _GetFriendshipListViewState extends State<GetFriendshipListView> {
  List<Friendship> friendships = [];

  final _webRTCsHub = WebRTCsHub.instance.hubConnection;

  bool hasIncomingCall = false;

  CallInfoModel callInfoModel = CallInfoModel(isCaller: false);

  bool isLoading = true;

  Future<void> getLocalFriendships() async {
    final friendships = await sl<FriendshipLocalDataSource>().getFriendships();
    setState(() {
      this.friendships = friendships;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocalFriendships();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingColumn(message: 'Đang tải danh sách bạn bè');
    }

    if (friendships.isEmpty) {
      return const Center(
        child: Text(
          'Danh sách bạn bè trống',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }

    return SafeArea(
      child: SizedBox(
        height: double.maxFinite,
        child: Center(
          child: ListView.builder(
              itemCount: friendships.length,
              itemBuilder: (context, index) {
                final friendship = friendships[index];
                final avatarUrl =
                    "${ApiConfig.BASE_IMAGE_URL}${friendship.friendAvatar}";
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: Image.network(avatarUrl).image,
                  ),
                  title: Text(
                    friendship.friendFullName,
                    maxLines: 1,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  subtitle: Text(
                    friendship.friendEmail,
                    maxLines: 1,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _setInfo(
                            CallInfoModel(
                              callerId: friendship.userId,
                              callerFullName: friendship.fullName,
                              callerAvatar:
                                  "${ApiConfig.BASE_IMAGE_URL}${friendship.avatar}",
                              isCaller: true,
                              receiverId: friendship.friendId,
                              receiverFullName: friendship.friendFullName,
                              receiverAvatar:
                                  "${ApiConfig.BASE_IMAGE_URL}${friendship.friendAvatar}",
                            ),
                            true,
                          );
                        },
                        icon: const Icon(Icons.phone),
                      ),
                      IconButton(
                        onPressed: () {
                          _setInfo(
                            CallInfoModel(
                              callerId: friendship.userId,
                              callerFullName: friendship.fullName,
                              callerAvatar:
                                  "${ApiConfig.BASE_IMAGE_URL}${friendship.avatar}",
                              isCaller: true,
                              receiverId: friendship.friendId,
                              receiverFullName: friendship.friendFullName,
                              receiverAvatar:
                                  "${ApiConfig.BASE_IMAGE_URL}${friendship.friendAvatar}",
                            ),
                            true,
                          );
                        },
                        icon: const Icon(Icons.videocam_sharp),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  void _setInfo(CallInfoModel info, bool isCallVideo) {
    logger.i('===== Set Info =====');
    setState(() {
      callInfoModel.callerId = info.callerId;
      callInfoModel.callerFullName = info.callerFullName;
      callInfoModel.callerAvatar = info.callerAvatar;
      callInfoModel.receiverId = info.receiverId;
      callInfoModel.receiverFullName = info.receiverFullName;
      callInfoModel.receiverAvatar = info.receiverAvatar;
      callInfoModel.isCaller = true;
    });

    // initiate call to the remote peer
    _webRTCsHub!
        .invoke("StartCall", args: [callInfoModel.receiverId.toString()]);
    logger.i('call started: ${callInfoModel.receiverId}');

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CallScreen(
              callInfoModel: callInfoModel,
              isCallVideo: isCallVideo,
            )));
  }
}
