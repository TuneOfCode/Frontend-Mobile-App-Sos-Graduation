import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
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
  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();

    player.setReleaseMode(ReleaseMode.loop);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player
          .setSource(DeviceFileSource('assets/audios/bell-call-video.mp3'));
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
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20),
          color: Colors.purple[50],
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.callInfoModel!.receiverAvatar!),
                  radius: 60,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Cuộc gọi đến từ",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.callInfoModel!.receiverFullName!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 250),
                Row(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
