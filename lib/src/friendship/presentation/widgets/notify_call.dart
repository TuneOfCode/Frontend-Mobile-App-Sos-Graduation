import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:sos_app/core/sockets/webrtc.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/friendship/data/datasources/local/friendship_local_datasource.dart';
import 'package:sos_app/src/friendship/data/models/call_info_model.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_event.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_state.dart';
import 'package:sos_app/src/friendship/presentation/views/call_screen.dart';
import 'package:sos_app/src/friendship/presentation/widgets/incoming_call.dart';

class NotifyCall extends StatefulWidget {
  final Widget child;
  const NotifyCall({
    super.key,
    required this.child,
  });

  @override
  State<NotifyCall> createState() => _NotifyCallState();
}

class _NotifyCallState extends State<NotifyCall> {
  List<Friendship> friendships = [];

  late HubConnection? _webRTCsHub;

  bool hasIncomingCall = false;

  CallInfoModel callInfoModel = CallInfoModel(isCaller: false);

  Future<void> getWebRTC() async {
    final accessToken =
        await sl<AuthenticationLocalDataSource>().getAccessToken();

    if (accessToken != null) {
      await WebRTCsHub.instance.init(accessToken);
      final localFriendships =
          await sl<FriendshipLocalDataSource>().getFriendships();
      if (friendships.isEmpty && localFriendships.isNotEmpty) {
        setState(() {
          friendships = localFriendships;
        });
        Future.delayed(
          Duration.zero,
          () {
            context.read<FriendshipBloc>().add(const GetFriendshipsEvent(
                params: GetFriendshipParams(userId: '', page: 1)));
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getWebRTC();

    setState(() {
      _webRTCsHub = WebRTCsHub.instance.hubConnection;
    });

    if (_webRTCsHub != null) {
      _webRTCsHub!.on('IncommingCall', (data) async {
        _webRTCsHub!.on('CallLeft', (data) async {
          final currentUser =
              await sl<AuthenticationLocalDataSource>().getCurrentUser();

          var fromUserId = data![0].toString();

          final callerInFriendships = friendships
              .where((f) => f.friendId == fromUserId || f.userId == fromUserId)
              .singleOrNull;

          // logger.i(callerInFriendships);

          if (mounted &&
              currentUser.userId != fromUserId &&
              callerInFriendships != null &&
              callerInFriendships.friendId == fromUserId) {
            setState(() {
              hasIncomingCall = false;
            });
            // _webRTCsHub!.off('IncommingCall');
            // _webRTCsHub!.off('CallLeft');
          }
        });
        final currentUser =
            await sl<AuthenticationLocalDataSource>().getCurrentUser();

        var fromUserId = data![0].toString();

        // current user is not caller
        if (mounted && currentUser.userId != fromUserId) {
          final callerInFriendships = friendships
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
  }

  @override
  void dispose() {
    if (_webRTCsHub != null) {
      _webRTCsHub!.off('IncommingCall');
    }
    super.dispose();
  }

  _acceptCall() {
    logger.i('===== Accepting Call =====');
    _webRTCsHub!
        .invoke('AcceptCall', args: [callInfoModel.receiverId.toString()]);
    setState(() {
      hasIncomingCall = false;
    });
    // Navigator.of(context).pop();
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
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (hasIncomingCall) {
      return IncomingCall(
        callInfoModel: callInfoModel,
        acceptCall: _acceptCall,
        denyCall: _denyCall,
      );
    }
    // if (hasIncomingCall) {
    //   Future.delayed(Duration.zero, () {
    //     showDialog(
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
    return BlocConsumer<FriendshipBloc, FriendshipState>(
      listener: (context, state) {
        if (state is FriendshipsLoaded) {
          setState(() {
            friendships = state.friendships;
          });
        }
      },
      builder: (context, state) {
        return widget.child;
      },
    );
  }
}
