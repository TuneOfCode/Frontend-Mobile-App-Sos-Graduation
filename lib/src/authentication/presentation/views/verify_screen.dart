import 'package:flutter/material.dart';
import '../widgets/otp_form.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String? varifyCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 13, right: 15),
              child: Image.asset(
                "assets/images/vector-1.png",
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Nhập mã xác thực\n',
                    style: TextStyle(
                      color: Color(0xFF755DC1),
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: 329,
                    height: 56,
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 1, color: const Color(0xFF9F7BFF)),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: OtpForm(
                        callBack: (code) {
                          varifyCode = code;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: 329,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9F7BFF),
                        ),
                        child: const Text(
                          'Xác thực',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Mã xác thực có hạn sau ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      // TimerCountdown(
                      //   spacerWidth: 0,
                      //   enableDescriptions: false,
                      //   colonsTextStyle: const TextStyle(
                      //     color: Color(0xFF755DC1),
                      //     fontSize: 13,

                      //     fontWeight: FontWeight.w400,
                      //   ),
                      //   timeTextStyle: const TextStyle(
                      //     color: Color(0xFF755DC1),
                      //     fontSize: 13,

                      //     fontWeight: FontWeight.w400,
                      //   ),
                      //   format: CountDownTimerFormat.minutesSeconds,
                      //   endTime: DateTime.now().add(
                      //     const Duration(
                      //       minutes: 2,
                      //       seconds: 0,
                      //     ),
                      //   ),
                      //   onEnd: () {},
                      // ),
                      InkWell(
                        onTap: () {},
                        child: const Text(
                          'Gửi lại ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF755DC1),
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 37,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: InkWell(
                onTap: () {
                  widget.controller.animateToPage(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                },
                child: const Text(
                  'Quay lại đăng nhập',
                  style: TextStyle(
                    color: Color(0xFF837E93),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
