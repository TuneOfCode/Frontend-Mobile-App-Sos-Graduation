import 'package:flutter/material.dart';
import 'package:sos_app/src/friendship/data/models/call_info_model.dart';

class IncomingCall extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(callInfoModel!.receiverAvatar!),
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
                  callInfoModel!.receiverFullName!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton(
                      onPressed: () => denyCall!(),
                      heroTag: const Key('Từ chối cuộc gọi'),
                      elevation: 0,
                      backgroundColor: Colors.red[500],
                      child: const Icon(Icons.call_end_outlined),
                    ),
                    FloatingActionButton(
                      onPressed: () => acceptCall!(),
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
