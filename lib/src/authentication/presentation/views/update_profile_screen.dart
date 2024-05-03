import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos_app/core/components/widgets/button_base.dart';
import 'package:sos_app/core/components/widgets/text_field_base.dart';
import 'package:sos_app/core/components/widgets/toast_error.dart';
import 'package:sos_app/core/components/widgets/toast_success.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/app_config_constant.dart';
import 'package:sos_app/src/authentication/domain/entities/user.dart';
import 'package:sos_app/src/authentication/domain/params/update_user_params.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';
import 'package:sos_app/src/authentication/presentation/widgets/loading_column.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController contactPhoneController = TextEditingController();
  UpdateUserParams errorParams = const UpdateUserParams(
    userId: '',
    lastName: '',
    firstName: '',
    contactPhone: '',
    avatar: null,
  );

  UpdateUserParams params = const UpdateUserParams(
    userId: '',
    lastName: '',
    firstName: '',
    contactPhone: '',
    avatar: null,
  );

  Image? _image;
  XFile? _imageFile;
  User? _user;
  // PickedFile? _pickedFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _user = null;
    _image = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _handleListen(BuildContext context, AuthenticationState state) {
    if (state is UpdateUserError) {
      setState(() {
        errorParams = UpdateUserParams(
          userId: AppConfig.getErrorFirst(state.errors, 'userId'),
          lastName: AppConfig.getErrorFirst(state.errors, 'lastName'),
          firstName: AppConfig.getErrorFirst(state.errors, 'firstName'),
          contactPhone: AppConfig.getErrorFirst(state.errors, 'phone'),
          // avatar: AppConfig.getErrorFirst(state.errors, 'avatar'),
          avatar: null,
        );
      });

      final errorAvatar = AppConfig.getErrorFirst(state.errors, 'avatar');

      ScaffoldMessenger.of(context).showSnackBar(
        ToastError(message: errorAvatar.isEmpty ? state.message : errorAvatar)
            .build(context),
      );
    }

    if (state is UserUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const ToastSuccess(message: 'Cập nhật thông tin cá nhân thành công!')
            .build(context),
      );
      context.read<AuthenticationBloc>().add(const GetProfileEvent());
    }

    if (state is AuthenticationError) {
      ScaffoldMessenger.of(context).showSnackBar(
        ToastError(message: state.message).build(context),
      );
    }

    if (state is ProfileLoaded) {
      setState(() {
        _user = state.user;
        lastNameController.text = state.user.lastName;
        firstNameController.text = state.user.firstName;
        emailController.text = state.user.email;
        contactPhoneController.text = state.user.contactPhone;
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const ToastSuccess(message: 'Đã tải xong thông tin cá nhân')
      //       .build(context),
      // );
    }
  }

  _handleUpdateUser(BuildContext context) {
    setState(() {
      params = UpdateUserParams(
        userId: _user!.userId,
        lastName: lastNameController.text.trim(),
        firstName: firstNameController.text.trim(),
        contactPhone: contactPhoneController.text.trim(),
        // avatar: _imageFile == null ? '' : _imageFile!.path,
        avatar: _imageFile,
      );
    });
    context.read<AuthenticationBloc>().add(UpdateUserEvent(params: params));
  }

  Future getImagePicker() async {
    _imageFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (_imageFile != null) {
        if (kIsWeb) {
          _image = Image.network(_imageFile!.path);
        } else {
          _image = Image.file(File(_imageFile!.path));
        }
      }

      params = UpdateUserParams(
        userId: _user!.userId,
        lastName: lastNameController.text.trim(),
        firstName: firstNameController.text.trim(),
        contactPhone: contactPhoneController.text.trim(),
        avatar: _imageFile,
      );

      // context.read<AuthenticationBloc>().add(UpdateUserEvent(params: params));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cập nhật thông tin cá nhân',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) => _handleListen(context, state),
          // buildWhen: (previous, current) =>
          //     previous != current && current is ProfileLoaded,
          builder: (context, state) {
            if (state is GettingProfile) {
              return const LoadingColumn(message: 'Đang tải thông tin cá nhân');
            }

            return SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: _image == null
                                  ? (_user!.avatarUrl.isNotEmpty)
                                      ? Image.network(
                                          '${ApiConfig.BASE_IMAGE_URL}${_user!.avatarUrl}',
                                          width: 40,
                                        ).image
                                      : Image.asset(
                                              'assets/images/defaultAvatar.png')
                                          .image
                                  : _image!.image,
                            ),
                          ),
                          Positioned(
                            bottom: -8,
                            right: 0,
                            child: IconButton(
                              onPressed: getImagePicker,
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                        ),
                        child: Text(
                          _user!.fullName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
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
                            errorText: errorParams.lastName!,
                          ),
                          TextFieldBase(
                            controller: firstNameController,
                            labelText: 'Tên',
                            width: MediaQuery.of(context).size.width * 0.3,
                            errorText: errorParams.firstName!,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFieldBase(
                        controller: contactPhoneController,
                        labelText: 'Số điện thoại cá nhân',
                        width: MediaQuery.of(context).size.width * 0.8,
                        errorText: errorParams.contactPhone!,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: ButtonBase(
                          text: 'Cập nhật',
                          onPressed: () => _handleUpdateUser(context),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
