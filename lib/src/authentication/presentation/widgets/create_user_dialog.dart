import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sos_app/src/authentication/domain/params/create_user_params.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';

class CreateUserDialog extends StatefulWidget {
  final TextEditingController lastNameController;
  final TextEditingController firstNameController;
  final TextEditingController emailController;
  final TextEditingController contactPhoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const CreateUserDialog({
    super.key,
    required this.lastNameController,
    required this.firstNameController,
    required this.emailController,
    required this.contactPhoneController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is CreateUserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: widget.lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Họ và tên đệm',
                      // errorText: state is CreateUserError
                      //     ? AppConfig.getErrorFirst(state.errors, "lastName")
                      //         .message
                      //     : null,
                    ),
                  ),
                  TextField(
                    controller: widget.firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên',
                      // errorText: state is CreateUserError
                      //     ? AppConfig.getErrorFirst(state.errors, "firstName")
                      //         .message
                      //     : null,
                    ),
                  ),
                  TextField(
                    controller: widget.emailController,
                    decoration: const InputDecoration(
                      labelText: 'Địa chỉ email',
                      // errorText: state is CreateUserError
                      //     ? AppConfig.getErrorFirst(state.errors, "email")
                      //         .message
                      //     : null,
                    ),
                  ),
                  TextField(
                    controller: widget.contactPhoneController,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                      // errorText: state is CreateUserError
                      //     ? AppConfig.getErrorFirst(state.errors, "phone")
                      //         .message
                      //     : null,
                    ),
                  ),
                  TextField(
                    controller: widget.passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      // errorText: state is CreateUserError
                      //     ? AppConfig.getErrorFirst(state.errors, "password")
                      //         .message
                      //     : null,
                    ),
                  ),
                  TextField(
                    controller: widget.confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Nhập lại mật khẩu',
                      // errorText: state is CreateUserError
                      //     ? AppConfig.getErrorFirst(
                      //             state.errors, "confirmPassword")
                      //         .message
                      //     : null,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final params = CreateUserParams(
                        lastName: widget.lastNameController.text.trim(),
                        firstName: widget.firstNameController.text.trim(),
                        email: widget.emailController.text.trim(),
                        contactPhone: widget.contactPhoneController.text.trim(),
                        password: widget.passwordController.text.trim(),
                        confirmPassword:
                            widget.confirmPasswordController.text.trim(),
                      );

                      if (state is! CreateUserError) {
                        context
                            .read<AuthenticationBloc>()
                            .add(CreateUserEvent(params: params));
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Tạo mới'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
