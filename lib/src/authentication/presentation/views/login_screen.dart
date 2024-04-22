import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/core/components/widgets/button_base.dart';
import 'package:sos_app/core/components/widgets/text_field_base.dart';
import 'package:sos_app/core/components/widgets/toast_error.dart';
import 'package:sos_app/core/constants/app_config_constant.dart';
import 'package:sos_app/core/router/app_router.dart';
import 'package:sos_app/src/authentication/domain/params/login_user.params.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController(text: 'kingproup1111@gmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: '123456');
  LoginUserParams errorParams = const LoginUserParams(email: '', password: '');

  _handleListen(BuildContext context, AuthenticationState state) {
    if (state is LoggingUserError) {
      setState(() {
        errorParams = LoginUserParams(
          email: AppConfig.getErrorFirst(state.errors, 'email'),
          password: AppConfig.getErrorFirst(state.errors, 'password'),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        ToastError(message: state.message).build(context),
      );
    }

    if (state is UserLogged) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.home,
        ModalRoute.withName(''),
      );
    }
  }

  _handleLogin(BuildContext context) {
    final params = LoginUserParams(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    context.read<AuthenticationBloc>().add(LoginUserEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) => _handleListen(context, state),
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
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
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    textDirection: TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Color(0xFF755DC1),
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextFieldBase(
                        controller: emailController,
                        labelText: 'Địa chỉ email',
                        width: MediaQuery.of(context).size.width - 50,
                        errorText: errorParams.email,
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              errorParams = const LoginUserParams(
                                email: '',
                                password: '',
                              );
                            }
                          });
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFieldBase(
                        controller: passwordController,
                        labelText: 'Mật khẩu',
                        width: MediaQuery.of(context).size.width - 50,
                        errorText: errorParams.password,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              errorParams = const LoginUserParams(
                                email: '',
                                password: '',
                              );
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      InkWell(
                        onTap: () {
                          widget.controller.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        child: const Text(
                          'Quên mật khẩu?',
                          style: TextStyle(
                            color: Color(0xFF755DC1),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ButtonBase(
                          text: 'Đăng nhập',
                          onPressed: () => _handleLogin(context),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Bạn chưa có tài khoản?',
                            style: TextStyle(
                              color: Color(0xFF837E93),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 2.5,
                          ),
                          InkWell(
                            onTap: () {
                              widget.controller.animateToPage(
                                1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: const Text(
                              'Đăng ký',
                              style: TextStyle(
                                color: Color(0xFF755DC1),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
