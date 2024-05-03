import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sos_app/core/components/widgets/toast_error.dart';
import 'package:sos_app/core/components/widgets/toast_success.dart';
import 'package:sos_app/core/constants/app_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/src/authentication/domain/params/resend_verify_code_params.dart';
import 'package:sos_app/src/authentication/domain/params/verify_user_params.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';
import 'package:sos_app/src/authentication/presentation/widgets/loading_column.dart';

import '../widgets/otp_form.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final box = GetStorage();
  late String email;
  String? verifyCode;
  Timer? timer;
  late int minutes;
  late int seconds;

  @override
  void initState() {
    email = box.read('email');
    logger.i('email');
    minutes = 2;
    seconds = 59;
    verifyTimer();
    super.initState();
  }

  void verifyTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          if (minutes > 0) {
            minutes--;
            seconds = 59;
          } else {
            timer.cancel();
          }
        }
      });
    });
  }

  _handleListen(BuildContext context, AuthenticationState state) {
    if (state is VerifyUserError) {
      final errorVerifyCode = AppConfig.getErrorFirst(state.errors, 'code');

      ScaffoldMessenger.of(context).showSnackBar(
        ToastError(
                message:
                    errorVerifyCode.isEmpty ? state.message : errorVerifyCode)
            .build(context),
      );
    }

    if (state is UserVerified) {
      box.remove('email');

      ScaffoldMessenger.of(context).showSnackBar(
        const ToastSuccess(
          message: 'Tài khoản đã được xác minh!',
        ).build(context),
      );

      Future.delayed(
        const Duration(seconds: 2),
        () {
          widget.controller.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        },
      );
    }
  }

  _handleVerifyUser(BuildContext context) {
    final params = VerifyUserParams(
      email: email,
      code: verifyCode!,
    );

    context.read<AuthenticationBloc>().add(VerifyUserEvent(params: params));
  }

  _handleResendCode(BuildContext context) {
    final params = ResendVerifyCodeParams(
      email: email,
    );

    context
        .read<AuthenticationBloc>()
        .add(ResendVerifyCodeEvent(params: params));

    setState(() {
      minutes = 2;
      seconds = 59;
    });
    verifyTimer();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: _handleListen,
      builder: (context, state) {
        if (state is VerifingUser || state is ResendingVerifyCode) {
          return const LoadingColumn(
            message: 'Đang xử lý',
          );
        }
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
                          border: Border.all(
                              width: 1, color: const Color(0xFF9F7BFF)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: OtpForm(
                            callBack: (code) {
                              verifyCode = code;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: SizedBox(
                          width: 329,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => _handleVerifyUser(context),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (minutes > 0 || seconds > 0) ...[
                            const Text(
                              'Mã xác thực sẽ hết hạn sau ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              '${minutes < 10 ? '0$minutes' : '$minutes'}:${seconds < 10 ? '0$seconds' : '$seconds'}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red[600],
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                          if (minutes == 0 && seconds == 0) ...[
                            InkWell(
                              onTap: () => _handleResendCode(context),
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
                          ]
                        ],
                      ),
                      const SizedBox(
                        width: 50,
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
      },
    );
  }
}
