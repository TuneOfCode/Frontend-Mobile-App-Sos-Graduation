import 'package:flutter/material.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:sos_app/core/sockets/webrtc.dart';
import 'package:sos_app/src/friendship/data/datasources/local/friendship_local_datasource.dart';
import 'package:sos_app/src/friendship/data/models/call_info_model.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship.dart';
import 'package:sos_app/src/friendship/presentation/views/call_screen.dart';

class GetFriendshipListView extends StatefulWidget {
  // final List<Friendship> friendships;
  const GetFriendshipListView({
    super.key,
    // required this.friendships,
  });

  @override
  State<GetFriendshipListView> createState() => _GetFriendshipListViewState();
}

class _GetFriendshipListViewState extends State<GetFriendshipListView> {
  List<Friendship> friendships = [];

  final _webRTCsHub = WebRTCsHub.instance.hubConnection;

  bool hasIncomingCall = false;

  CallInfoModel callInfoModel = CallInfoModel(isCaller: false);

  Future<void> getLocalFriendships() async {
    final friendships = await sl<FriendshipLocalDataSource>().getFriendships();
    setState(() {
      this.friendships = friendships;
    });
  }

  @override
  void initState() {
    super.initState();
    getLocalFriendships();

    // _webRTCsHub!.on('IncommingCall', (data) async {
    //   _webRTCsHub.on('CallLeft', (data) async {
    //     final currentUser =
    //         await sl<AuthenticationLocalDataSource>().getCurrentUser();

    //     var fromUserId = data![0].toString();

    //     final callerInFriendships = widget.friendships
    //         .where((f) => f.friendId == fromUserId || f.userId == fromUserId)
    //         .singleOrNull;

    //     if (currentUser.userId != fromUserId &&
    //         callerInFriendships!.friendId == fromUserId) {
    //       setState(() {
    //         hasIncomingCall = false;
    //       });
    //     }
    //   });
    //   final currentUser =
    //       await sl<AuthenticationLocalDataSource>().getCurrentUser();

    //   var fromUserId = data![0].toString();

    //   // current user is not caller
    //   if (currentUser.userId != fromUserId) {
    //     final callerInFriendships = widget.friendships
    //         .where((f) => f.friendId == fromUserId || f.userId == fromUserId)
    //         .singleOrNull;

    //     setState(() {
    //       callInfoModel.callerId = fromUserId;
    //       callInfoModel.callerFullName = callerInFriendships!.fullName;
    //       callInfoModel.callerAvatar =
    //           "${ApiConfig.BASE_IMAGE_URL}${callerInFriendships.avatar}";
    //       hasIncomingCall = true;
    //       callInfoModel.receiverId = callerInFriendships.friendId;
    //       callInfoModel.receiverFullName = callerInFriendships.friendFullName;
    //       callInfoModel.receiverAvatar =
    //           "${ApiConfig.BASE_IMAGE_URL}${callerInFriendships.friendAvatar}";
    //       callInfoModel.isCaller = false;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    // _webRTCsHub!.off('IncommingCall');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (hasIncomingCall) {
    //   return IncomingCall(
    //     callInfoModel: callInfoModel,
    //     acceptCall: _acceptCall,
    //     denyCall: _denyCall,
    //   );
    // }
    // if (hasIncomingCall) {
    //   Future.delayed(Duration.zero, () async {
    //     await showDialog(
    //         context: context,
    //         builder: (BuildContext context) {
    //           return IncomingCall(
    //             callInfoModel: callInfoModel,
    //             acceptCall: _acceptCall,
    //             denyCall: _denyCall,
    //           );
    //         });
    //   });
    // }

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
                    // crossAxisAlignment: CrossAxisAlignment.end,
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
                            false,
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

  // _acceptCall() {
  //   logger.i('===== Accepting Call =====');
  //   _webRTCsHub!
  //       .invoke('AcceptCall', args: [callInfoModel.receiverId.toString()]);
  //   setState(() {
  //     hasIncomingCall = false;
  //   });
  //   // Navigator.of(context).pop();
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => CallScreen(callInfoModel: callInfoModel)));
  // }

  // _denyCall() {
  //   logger.i('===== Denying Call =====');
  //   _webRTCsHub!
  //       .invoke('DenyCall', args: [callInfoModel.receiverId.toString()]);
  //   setState(() {
  //     hasIncomingCall = false;
  //   });
  //   // Navigator.of(context).pop();
  // }

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
