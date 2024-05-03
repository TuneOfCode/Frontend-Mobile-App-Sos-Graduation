import 'package:flutter/material.dart';
import 'package:sos_app/core/components/widgets/button_base.dart';
import 'package:sos_app/core/components/widgets/text_field_base.dart';
import 'package:sos_app/src/friendship/presentation/widgets/notify_call.dart';

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

  @override
  Widget build(BuildContext context) {
    return NotifyCall(
      child: Scaffold(
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
                          // errorText: errorParams.password,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFieldBase(
                          isTypePassword: true,
                          controller: newPasswordController,
                          labelText: 'Mật khẩu mới',
                          // errorText: errorParams.password,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFieldBase(
                          isTypePassword: true,
                          controller: confirmNewPasswordController,
                          labelText: 'Nhập lại mật khẩu mới',
                          // errorText: errorParams.confirmPassword,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Center(
                          child: ButtonBase(
                            text: 'Thay đổi',
                            onPressed: () {},
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
      ),
    );
  }
}
