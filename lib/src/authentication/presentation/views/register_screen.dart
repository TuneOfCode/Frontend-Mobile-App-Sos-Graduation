import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sos_app/core/components/widgets/button_base.dart';
import 'package:sos_app/core/components/widgets/text_field_base.dart';
import 'package:sos_app/core/components/widgets/toast_error.dart';
import 'package:sos_app/core/constants/app_config_constant.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';
import 'package:sos_app/src/authentication/presentation/widgets/loading_column.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final box = GetStorage();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  CreateUserParams errorParams = const CreateUserParams(
    lastName: '',
    firstName: '',
    email: '',
    contactPhone: '',
    password: '',
    confirmPassword: '',
  );

  _handleListen(BuildContext context, AuthenticationState state) {
    if (state is CreateUserError) {
      setState(() {
        errorParams = CreateUserParams(
          lastName: AppConfig.getErrorFirst(state.errors, 'lastName'),
          firstName: AppConfig.getErrorFirst(state.errors, 'firstName'),
          email: AppConfig.getErrorFirst(state.errors, 'email'),
          contactPhone: AppConfig.getErrorFirst(state.errors, 'phone'),
          password: AppConfig.getErrorFirst(state.errors, 'password'),
          confirmPassword: AppConfig.getErrorFirst(state.errors, 'confirmPwd'),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        ToastError(message: state.message).build(context),
      );
    }

    if (state is UserCreated) {
      box.write('email', emailController.text.trim());
      widget.controller.animateToPage(
        2,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  _handleRegister(BuildContext context) {
    final params = CreateUserParams(
      lastName: lastNameController.text.trim(),
      firstName: firstNameController.text.trim(),
      email: emailController.text.trim(),
      contactPhone: contactPhoneController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );

    context.read<AuthenticationBloc>().add(CreateUserEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: _handleListen,
      builder: (context, state) {
        if (state is CreatingUser) {
          return const LoadingColumn(
            message: 'Đang xử lý',
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Image.asset(
                        "assets/images/vector-2.png",
                        width: 200,
                        height: 120,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        textDirection: TextDirection.ltr,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Đăng ký',
                            style: TextStyle(
                              color: Color(0xFF755DC1),
                              fontSize: 27,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextFieldBase(
                                controller: lastNameController,
                                labelText: 'Họ và tên đệm',
                                width: MediaQuery.of(context).size.width * 0.5,
                                errorText: errorParams.lastName,
                              ),
                              TextFieldBase(
                                controller: firstNameController,
                                labelText: 'Tên',
                                width: MediaQuery.of(context).size.width * 0.3,
                                errorText: errorParams.firstName,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFieldBase(
                            controller: emailController,
                            labelText: 'Địa chỉ email',
                            errorText: errorParams.email,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFieldBase(
                            controller: contactPhoneController,
                            labelText: 'Số điện thoại cá nhân',
                            errorText: errorParams.contactPhone,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFieldBase(
                            isTypePassword: true,
                            controller: passwordController,
                            labelText: 'Mật khẩu',
                            errorText: errorParams.password,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFieldBase(
                            isTypePassword: true,
                            controller: confirmPasswordController,
                            labelText: 'Nhập lại mật khẩu',
                            errorText: errorParams.confirmPassword,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: ButtonBase(
                              text: 'Đăng ký',
                              onPressed: () => _handleRegister(context),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Bạn đã có tài khoản?',
                                textAlign: TextAlign.center,
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
                                    0,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                },
                                child: const Text(
                                  'Đăng nhập',
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
            ),
          ),
        );
      },
    );
  }
}
