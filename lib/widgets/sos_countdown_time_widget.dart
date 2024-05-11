import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sos_app/core/router/app_router.dart';

class SosCountdownTimeWidget extends StatefulWidget {
  const SosCountdownTimeWidget({super.key});

  @override
  State<SosCountdownTimeWidget> createState() => _SosCountdownTimeWidgetState();
}

class _SosCountdownTimeWidgetState extends State<SosCountdownTimeWidget> {
  static int maxSeconds = 10;
  late int seconds;
  static int maxSos = 0;
  late int sosCounter;
  static int blockTime = 5;
  Timer? timer;
  static DateTime? blockSpam;
  static DateTime? unblockSpam;

  @override
  void initState() {
    super.initState();
    seconds = maxSeconds;
    sosCounter = maxSos;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop();
        });
      }
    });
  }

  void checkSpam() {
    if (sosCounter == 0) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                    Text(
                      'Cảnh báo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
                content: Text(
                  'Bạn chỉ được phép nhấn tối đa $maxSos lần cảnh báo cứu hộ. '
                  'Chức năng cứu hộ sẽ tự động kích hoạt lại sau $blockTime giây nữa! '
                  '(từ $blockSpam đến $unblockSpam)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                  ),
                  textAlign: TextAlign.justify,
                ),
              ));
      if (blockSpam == null && unblockSpam == null) {
        setState(() {
          blockSpam = DateTime.now();
          unblockSpam = DateTime.now().add(
            Duration(
              seconds: blockTime,
            ),
          );
        });
      }
      return;
    }
  }

  void checkUnblockSpam() {
    if (unblockSpam != null && unblockSpam!.isBefore(DateTime.now())) {
      debugPrint('>>> đã hết chặn: ${unblockSpam!.isBefore(DateTime.now())}');
      setState(() {
        sosCounter = maxSos + 1;
        seconds = maxSeconds;
        blockSpam = null;
        unblockSpam = null;
      });
      startTimer();
      setSpam();
      return;
    }
  }

  void setSpam() {
    setState(() {
      sosCounter--;
    });
  }

  void stopTimer({bool isReset = false, bool isExist = false}) {
    if (isReset && sosCounter > 0) {
      setState(() {
        seconds = maxSeconds;
      });
      startTimer();
      setSpam();
      return;
    }

    if (isExist) {
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => const HomePage(),
      //   ),
      // );
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
      timer!.cancel();
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: seconds == 0,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: seconds / maxSeconds,
                    valueColor: const AlwaysStoppedAnimation(
                      Colors.white,
                    ),
                    strokeWidth: 12,
                    backgroundColor: Colors.redAccent,
                  ),
                  seconds == 0
                      ? const Center(
                          child: Text(
                            'SOS',
                            style: TextStyle(
                              fontSize: 80,
                              color: Colors.redAccent,
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            seconds < 10 ? '0$seconds' : '$seconds',
                            style: const TextStyle(
                              fontSize: 80,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                ],
              ),
            ),
            Visibility(
              visible: seconds > 0,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: Text(
                  'Cảnh báo SOS sẽ được gửi đến bạn bè của bạn sau ${seconds < 10 ? '0$seconds' : '$seconds'} giây',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red[600],
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (seconds > 0) ...[
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        seconds > 0 ? Colors.red : Colors.green[600],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Huỷ bỏ',
                    // : 'Phát lại tín hiệu cầu cứu ($sosCounter)',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    checkUnblockSpam();
                    checkSpam();
                    stopTimer(
                      isExist: seconds > 0,
                    );
                    // stopTimer(
                    //   isReset: seconds == 0,
                    //   isExist: seconds > 0 && unblockSpam != null,
                    // );
                    // stopTimer(
                    //   isReset: false,
                    //   isExist: true,
                    // );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
