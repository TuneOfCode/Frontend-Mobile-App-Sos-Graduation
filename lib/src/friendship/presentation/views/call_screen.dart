// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/sockets/webrtc.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/friendship/data/models/call_info_model.dart';

class CallScreen extends StatefulWidget {
  final CallInfoModel? callInfoModel;
  final bool isCallVideo;
  const CallScreen({
    super.key,
    required this.callInfoModel,
    this.isCallVideo = false,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final _webRTCsHub = WebRTCsHub.instance.hubConnection;

  final _localRTCRenderer = RTCVideoRenderer();

  final _remoteRTCRenderer = RTCVideoRenderer();

  MediaStream? _localStream;

  RTCPeerConnection? _rtcPeerConnection;

  final List<RTCIceCandidate> _iceCandidates = [];

  bool isAudioOn = true;
  late bool isVideoOn = widget.isCallVideo;
  bool isFrontCameraActive = true;

  // bool isAcceptedReceiver = false;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   isVideoOn = widget.isCallVideo;
    // });

    _localRTCRenderer.initialize();
    _remoteRTCRenderer.initialize();

    _processWebRTCsEvents();

    _setupPeerConnection();
  }

  @override
  void dispose() {
    super.dispose();

    _localRTCRenderer.dispose();
    _remoteRTCRenderer.dispose();
    _localStream?.dispose();
    _rtcPeerConnection?.dispose();

    _webRTCsHub!.off("CallLeft");
    _webRTCsHub.off("CallAccepted");
    _webRTCsHub.off("CallDenied");
    _webRTCsHub.off("Offer");
    _webRTCsHub.off("OfferAnswer");
    _webRTCsHub.off("ReceiveIceCandidate");

    // setState(() {
    //   isAcceptedReceiver = false;
    // });
  }

  _processWebRTCsEvents() {
    _webRTCsHub!.on('CallLeft', (data) {
      // logger.i('data left call: $data');
      var fromUserId = data![0].toString();
      logger.i('fromUserId left call: $fromUserId');

      Navigator.of(context).pop();
    });

    _webRTCsHub.on('CallDenied', (data) {
      // logger.i('data denied call: $data');
      var toUserId = data![0].toString();
      logger.i('toUserId denied call: $toUserId');

      Navigator.of(context).pop();
    });
  }

  _setupPeerConnection() async {
    // create peer connection
    _rtcPeerConnection = await createPeerConnection({
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    });

    // listen for media tracks from our remote pal
    _rtcPeerConnection!.onTrack = (track) {
      logger.i('got track');
      _remoteRTCRenderer.srcObject = track.streams[0];
      setState(() {});
    };

    if (widget.isCallVideo) {
      setState(() {
        isVideoOn = true;
      });
    }

    // create our own stream
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': isAudioOn,
      'video': isVideoOn
          ? {
              'facingMode': isFrontCameraActive ? 'user' : 'environment',
            }
          : false,
    });

    // add my local media tracks ti the rtc peer connection
    _localStream!.getTracks().forEach((track) {
      _rtcPeerConnection!.addTrack(track, _localStream!);
    });

    // if (_localStream == null ||
    //     (_localStream != null && _localStream!.getAudioTracks().isEmpty ||
    //         _localStream!.getVideoTracks().isEmpty)) {
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialogBase(
    //         title: Row(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             const Icon(
    //               Icons.warning_amber_rounded,
    //               color: Colors.redAccent,
    //               size: 30,
    //             ),
    //             Text(
    //               'Thông báo',
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.red[600],
    //               ),
    //             ),
    //           ],
    //         ),
    //         content: Text(
    //           'Có vẻ như thiết bị của bạn không hỗ trợ âm thanh hoặc máy ảnh!',
    //           style: TextStyle(
    //             fontSize: 16,
    //             fontWeight: FontWeight.bold,
    //             color: Colors.red[600],
    //           ),
    //           textAlign: TextAlign.justify,
    //         ),
    //       );
    //     },
    //   );

    //   Navigator.of(context).pop();

    //   return;
    // }

    // set the source for my local renderer
    _localRTCRenderer.srcObject = _localStream;

    // update the page so state can be reflected
    setState(() {});

    if (widget.callInfoModel!.isCaller) {
      // listen for my ice candidates and add them to the ice candidate list
      _rtcPeerConnection!.onIceCandidate = (candidate) {
        setState(() => _iceCandidates.add(candidate));
      };

      // listen for whether the receiver accepts our call
      // if they accept, we create an offer and send it to them
      _webRTCsHub!.on("CallAccepted", (data) async {
        // logger.i("call answered: $data");
        // setState(() {
        //   isAcceptedReceiver = true;
        // });

        // create sdp offer
        var offer = await _rtcPeerConnection!.createOffer();

        // set it as our local description
        await _rtcPeerConnection!.setLocalDescription(offer);

        // send it to the fella we called
        // logger.f("offer: ${offer.toMap()}");
        // _webRTCsHub.invoke("Offer", args: [
        //   widget.callInfoModel!.callerId.toString(),
        //   jsonEncode(offer.toMap())
        // ]);
        _webRTCsHub.invoke("Offer", args: [
          widget.callInfoModel!.receiverId.toString(),
          jsonEncode(offer.toMap())
        ]);
      });

      // listen for offer answered event
      _webRTCsHub.on("OfferAnswer", (data) async {
        // logger.f("======> offer answered: ${data![0]}");

        var dataJson = jsonDecode(data![0].toString());

        // we set the answer as ouR remote sdp
        await _rtcPeerConnection!.setRemoteDescription(
            RTCSessionDescription(dataJson['sdp'], dataJson['type']));

        // we then send all collected ice candidates to the receiver
        for (var iceCandidate in _iceCandidates) {
          DataMap candidate = {
            "sdpMid": iceCandidate.sdpMid,
            "candidate": iceCandidate.candidate,
            "sdpMLineIndex": iceCandidate.sdpMLineIndex,
          };
          _webRTCsHub.invoke("SendIceCandidate", args: [
            widget.callInfoModel!.receiverId.toString(),
            jsonEncode(candidate),
          ]);
        }
      });

      // // initiate call to the remote peer
      // _webRTCsHub.invoke("StartCall",
      //     args: [widget.callInfoModel!.receiverId.toString()]);
      // logger.i(
      //     'call started in call screen: ${widget.callInfoModel!.receiverId}');
    }

    if (!widget.callInfoModel!.isCaller) {
      // watch out for offer
      // set it as remote sdp description,
      // generate an answer and set it as local sdp description then send it to our caller
      _webRTCsHub!.on("Offer", (data) async {
        // logger.i(
        //     "got offer in not is caller ${data![0]} and runtime type ${data[0].runtimeType}");

        var dataJson = jsonDecode(data![0].toString());

        // set it as remote sdp description,
        await _rtcPeerConnection!.setRemoteDescription(
            RTCSessionDescription(dataJson['sdp'], dataJson['type']));

        // generate an answer
        RTCSessionDescription answer = await _rtcPeerConnection!.createAnswer();

        // set answer as local sdp description then
        _rtcPeerConnection!.setLocalDescription(answer);

        // send answer to our caller
        _webRTCsHub.invoke("OfferAnswer", args: [
          widget.callInfoModel!.receiverId.toString(),
          jsonEncode(answer.toMap()),
        ]);

        // _webRTCsHub.invoke("OfferAnswer", args: [
        //   widget.callInfoModel!.callerId.toString(),
        //   jsonEncode(answer.toMap()),
        // ]);
      });

      // watch out for ice candidates and add them as candidates
      _webRTCsHub.on("ReceiveIceCandidate", (data) {
        // logger.i("got ice candidate in not is caller ${data![0]}");

        var dataJson = jsonDecode(data![0].toString());

        String candidate = dataJson["candidate"];
        String sdpMid = dataJson["sdpMid"];
        int sdpMLineIndex = dataJson["sdpMLineIndex"];

        // add it
        _rtcPeerConnection!
            .addCandidate(RTCIceCandidate(candidate, sdpMid, sdpMLineIndex));
      });

      // accept call
      _webRTCsHub.invoke("AcceptCall",
          args: [widget.callInfoModel!.receiverId.toString()]);
      // logger.i("answering call");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // the person im chatting with
          Positioned.fill(
            child: RTCVideoView(_remoteRTCRenderer,
                objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                placeholderBuilder: (_) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    "Đang chờ ${widget.callInfoModel!.receiverFullName} bắt máy...",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }),
          ),

          // my video
          if (_localRTCRenderer.srcObject != null)
            Positioned(
              right: 16,
              bottom: 72,
              height: screenSize.height / 4,
              // width: 120,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: RTCVideoView(
                    _localRTCRenderer,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    mirror: true,
                  ),
                ),
              ),
            ),

          // calling with name
          Positioned(
            top: 32,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(.4),
                ),
                child: Text(
                  widget.callInfoModel!.receiverFullName!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // stream controls
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // mute / unmute audio
                    FloatingActionButton(
                      onPressed: _toggleAudio,
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      mini: true,
                      heroTag: " bật / tắt mic",
                      child: Icon(isAudioOn
                          ? Icons.mic_none_rounded
                          : Icons.mic_off_rounded),
                    ),

                    // show / unshow video
                    FloatingActionButton(
                        onPressed: _toggleVideo,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        mini: true,
                        heroTag: "bật / tắt video",
                        child: Icon(isVideoOn
                            ? Icons.videocam_rounded
                            : Icons.videocam_off_rounded)),

                    if (isVideoOn) ...[
                      // show / unshow camera switch
                      FloatingActionButton(
                          onPressed: _switchCamera,
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          mini: true,
                          heroTag: "chuyển camera sau / chuyển camera trước",
                          child: const Icon(Icons.cameraswitch_rounded)),
                    ],

                    // leave call
                    FloatingActionButton(
                      onPressed: _leaveCall,
                      backgroundColor: Colors.red[500],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      mini: true,
                      heroTag: "rời cuộc gọi",
                      child: const Icon(Icons.call_end_outlined),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  _toggleAudio() {
    isAudioOn = !isAudioOn;

    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });
    setState(() {});
  }

  _toggleVideo() {
    isVideoOn = !isVideoOn;

    _localStream?.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
    setState(() {});

    // if (widget.isCallVideo) {
    //   setState(() {});
    // }
  }

  _switchCamera() {
    _localStream?.getVideoTracks().forEach((track) async {
      await Helper.switchCamera(track, null, _localStream);
    });
    setState(() {});
  }

  _leaveCall() {
    _webRTCsHub!.invoke("LeaveCall",
        args: [widget.callInfoModel!.receiverId.toString()]);

    Navigator.pop(context);
  }
}
