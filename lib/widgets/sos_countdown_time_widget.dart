// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sos_app/core/components/views/alert_dialog.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/local_datasource_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/router/app_router.dart';

class SosCountdownTimeWidget extends StatefulWidget {
  const SosCountdownTimeWidget({super.key});

  @override
  State<SosCountdownTimeWidget> createState() => _SosCountdownTimeWidgetState();
}

class _SosCountdownTimeWidgetState extends State<SosCountdownTimeWidget> {
  static int maxSeconds = 5;
  late int seconds;
  static int maxSos = 0;
  late int sosCounter;
  static int blockTime = 5;
  Timer? timer;
  static DateTime? blockSpam;
  static DateTime? unblockSpam;
  final box = GetStorage();
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(UrlSource(
          '${ApiConfig.BASE_IMAGE_URL}/medias/bell-countdown-5s.mp3'));
      await player.resume();
    });

    seconds = maxSeconds;
    sosCounter = maxSos;
    startTimer();
  }

  void checkEnableSos() {
    final isVictim = box.read(LocalDataSource.IS_VICTIM);
    if (isVictim != null && isVictim) {
      if (mounted) {
        timer?.cancel();
      }

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialogBase(
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
                  'Thông báo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[600],
                  ),
                ),
              ],
            ),
            content: Text(
              'Bạn đã phát tín hiệu trước đó!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
              textAlign: TextAlign.justify,
            ),
          );
        },
      );

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.home,
          ModalRoute.withName(''),
        );
      });
    }
    return;
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (seconds > 0) {
        checkEnableSos();
        setState(() {
          seconds--;
        });
      } else {
        logger.f('Phát tín hiệu SOS');
        box.write(LocalDataSource.IS_VICTIM, true);
        box.write(LocalDataSource.DATETIME_SOS,
            DateTime.now().add(const Duration(seconds: 30)).toString());
        if (mounted) {
          timer.cancel();
        }
        await player.stop();
        player.dispose();
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRouter.home,
          ModalRoute.withName(''),
        );
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
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
      if (mounted) {
        timer!.cancel();
      }
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (mounted) {
      timer!.cancel();
    }
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
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
