import 'package:flutter/material.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:sos_app/core/sockets/webrtc.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/friendship/data/models/call_info_model.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship.dart';
import 'package:sos_app/src/friendship/presentation/views/call_screen.dart';
import 'package:sos_app/src/friendship/presentation/widgets/incoming_call.dart';

class GetFriendshipListView extends StatefulWidget {
  final List<Friendship> friendships;
  const GetFriendshipListView({super.key, required this.friendships});

  @override
  State<GetFriendshipListView> createState() => _GetFriendshipListViewState();
}

class _GetFriendshipListViewState extends State<GetFriendshipListView> {
  final _webRTCsHub = WebRTCsHub.instance.hubConnection;

  bool hasIncomingCall = false;

  CallInfoModel callInfoModel = CallInfoModel(isCaller: false);

  @override
  void initState() {
    super.initState();

    _webRTCsHub!.on('IncommingCall', (data) async {
      _webRTCsHub.on('CallLeft', (data) async {
        final currentUser =
            await sl<AuthenticationLocalDataSource>().getCurrentUser();

        var fromUserId = data![0].toString();

        final callerInFriendships = widget.friendships
            .where((f) => f.friendId == fromUserId || f.userId == fromUserId)
            .singleOrNull;

        if (currentUser.userId != fromUserId &&
            callerInFriendships!.friendId == fromUserId) {
          setState(() {
            hasIncomingCall = false;
          });
        }
      });
      final currentUser =
          await sl<AuthenticationLocalDataSource>().getCurrentUser();

      var fromUserId = data![0].toString();

      // current user is not caller
      if (currentUser.userId != fromUserId) {
        final callerInFriendships = widget.friendships
            .where((f) => f.friendId == fromUserId || f.userId == fromUserId)
            .singleOrNull;

        setState(() {
          callInfoModel.callerId = fromUserId;
          callInfoModel.callerFullName = callerInFriendships!.fullName;
          callInfoModel.callerAvatar =
              "${ApiConfig.BASE_IMAGE_URL}${callerInFriendships.avatar}";
          hasIncomingCall = true;
          callInfoModel.receiverId = callerInFriendships.friendId;
          callInfoModel.receiverFullName = callerInFriendships.friendFullName;
          callInfoModel.receiverAvatar =
              "${ApiConfig.BASE_IMAGE_URL}${callerInFriendships.friendAvatar}";
          callInfoModel.isCaller = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _webRTCsHub!.off('IncommingCall');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (hasIncomingCall) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetAnimationCurve: Curves.bounceIn,
        child: SafeArea(
          child: IncomingCall(
            callInfoModel: callInfoModel,
            acceptCall: _acceptCall,
            denyCall: _denyCall,
          ),
        ),
      );
    }

    if (widget.friendships.isEmpty) {
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
              itemCount: widget.friendships.length,
              itemBuilder: (context, index) {
                final friendship = widget.friendships[index];
                final avatarUrl =
                    "${ApiConfig.BASE_IMAGE_URL}${friendship.friendAvatar}";
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: Image.network(avatarUrl).image,
                  ),
                  title: Text(friendship.friendFullName),
                  subtitle: Text(friendship.friendEmail),
                  trailing: IconButton(
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
                        );
                      },
                      icon: const Icon(Icons.video_call)),
                );
              }),
        ),
      ),
    );
  }

  _acceptCall() {
    logger.i('===== Accepting Call =====');
    _webRTCsHub!
        .invoke('AcceptCall', args: [callInfoModel.receiverId.toString()]);
    setState(() {
      hasIncomingCall = false;
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CallScreen(callInfoModel: callInfoModel)));
  }

  _denyCall() {
    logger.i('===== Denying Call =====');
    _webRTCsHub!
        .invoke('DenyCall', args: [callInfoModel.receiverId.toString()]);
    setState(() {
      hasIncomingCall = false;
    });
  }

  void _setInfo(CallInfoModel info) {
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
        builder: (context) => CallScreen(callInfoModel: callInfoModel)));
  }
}
