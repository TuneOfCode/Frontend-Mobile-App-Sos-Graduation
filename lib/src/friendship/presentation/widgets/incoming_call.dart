import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/src/friendship/data/models/call_info_model.dart';

class IncomingCall extends StatefulWidget {
  final Function? acceptCall;
  final Function? denyCall;
  final CallInfoModel? callInfoModel;

  const IncomingCall({
    super.key,
    this.acceptCall,
    this.denyCall,
    this.callInfoModel,
  });

  @override
  State<IncomingCall> createState() => _IncomingCallState();
}

class _IncomingCallState extends State<IncomingCall> {
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();

    player.setReleaseMode(ReleaseMode.loop);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(
          UrlSource('${ApiConfig.BASE_IMAGE_URL}/medias/bell-call-video.mp3'));
      await player.resume();
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.purple[50],
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 180,
                height: 180,
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.callInfoModel!.receiverAvatar!),
                  radius: 60,
                ),
              ),
            ),
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Text(
                "Cuộc gọi đến từ",
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              top: 280,
              left: 0,
              right: 0,
              child: Text(
                widget.callInfoModel!.receiverFullName!,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      await player.pause();
                      widget.denyCall!();
                    },
                    heroTag: const Key('Từ chối cuộc gọi'),
                    elevation: 0,
                    backgroundColor: Colors.red[500],
                    child: const Icon(Icons.call_end_outlined),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      await player.pause();
                      widget.acceptCall!();
                    },
                    heroTag: const Key('Chấp nhận cuộc gọi'),
                    elevation: 0,
                    backgroundColor: Colors.green[500],
                    child: const Icon(Icons.call_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
