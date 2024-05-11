import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/core/components/widgets/button_base.dart';
import 'package:sos_app/core/components/widgets/text_field_base.dart';
import 'package:sos_app/core/components/widgets/toast_error.dart';
import 'package:sos_app/core/components/widgets/toast_success.dart';
import 'package:sos_app/core/constants/app_config_constant.dart';
import 'package:sos_app/src/authentication/domain/params/change_password_params.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();
  ChangePasswordParams errorParams = const ChangePasswordParams(
    userId: '',
    currentPassword: '',
    password: '',
    confirmPassword: '',
  );

  _handleListener(BuildContext context, AuthenticationState state) {
    if (state is ChangePasswordError) {
      setState(() {
        errorParams = ChangePasswordParams(
          userId: AppConfig.getErrorFirst(state.errors, 'userId'),
          currentPassword:
              AppConfig.getErrorFirst(state.errors, 'currentPassword'),
          password: AppConfig.getErrorFirst(state.errors, 'newPassword'),
          confirmPassword: AppConfig.getErrorFirst(state.errors, 'confirm'),
        );
      });

      final errorPassword = AppConfig.getErrorFirst(state.errors, 'password');

      ScaffoldMessenger.of(context).showSnackBar(
        ToastError(
                message: errorPassword.isEmpty ? state.message : errorPassword)
            .build(context),
      );
    }

    if (state is PasswordChanged) {
      setState(() {
        errorParams = const ChangePasswordParams(
          userId: '',
          currentPassword: '',
          password: '',
          confirmPassword: '',
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const ToastSuccess(message: 'Thay đổi mật khẩu thành công!')
            .build(context),
      );
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }
  }

  _handleChangePassword(BuildContext context) {
    final params = ChangePasswordParams(
      userId: '',
      currentPassword: currentPasswordController.text.trim(),
      password: newPasswordController.text.trim(),
      confirmPassword: confirmNewPasswordController.text.trim(),
    );

    context.read<AuthenticationBloc>().add(ChangePasswordEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: _handleListener,
      builder: (context, state) {
        if (state is ChangingPassword) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'Thay đổi mật khẩu',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
                          const SizedBox(
                            height: 20,
                          ),
                          TextFieldBase(
                            isTypePassword: true,
                            controller: currentPasswordController,
                            labelText: 'Mật khẩu hiện tại',
                            errorText: errorParams.currentPassword,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFieldBase(
                            isTypePassword: true,
                            controller: newPasswordController,
                            labelText: 'Mật khẩu mới',
                            errorText: errorParams.password,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextFieldBase(
                            isTypePassword: true,
                            controller: confirmNewPasswordController,
                            labelText: 'Nhập lại mật khẩu mới',
                            errorText: errorParams.confirmPassword,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: ButtonBase(
                              text: 'Thay đổi',
                              onPressed: () => _handleChangePassword(context),
                            ),
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
