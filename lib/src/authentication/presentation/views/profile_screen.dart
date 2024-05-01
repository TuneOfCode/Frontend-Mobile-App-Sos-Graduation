import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos_app/core/components/widgets/toast_error.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/router/app_router.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';
import 'package:sos_app/src/authentication/presentation/widgets/loading_column.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_state.dart';
import 'package:sos_app/src/friendship/presentation/widgets/get_friendship_listview.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Image? _image;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _image = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getImage() async {
    var image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (kIsWeb) {
        _image = Image.network(image!.path);
      } else {
        _image = Image.file(File(image!.path));
      }
      logger.i('Image path upload: $_image');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thông tin tài khoản',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<FriendshipBloc, FriendshipState>(
          listener: (context, state) {
            if (state is FriendshipError) {
              ScaffoldMessenger.of(context).showSnackBar(
                ToastError(message: state.message).build(context),
              );
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                                radius: 60,
                                backgroundImage: _image == null
                                    ? Image.asset(
                                        'assets/images/marker.png',
                                        width: 80,
                                      ).image
                                    : _image!.image,
                              ),
                            ),
                            Positioned(
                              bottom: -8,
                              right: 0,
                              child: IconButton(
                                onPressed: getImage,
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            top: 12,
                          ),
                          child: Text(
                            'Trần Thanh Tú',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    )
                    // }
                    // ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 5,
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<AuthenticationBloc>()
                                .add(const GetProfileEvent());
                            Navigator.of(context)
                                .pushNamed(AppRouter.updateProfile);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(117, 116, 116, 0.251),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Chỉnh sửa trang cá nhân',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      BlocConsumer<AuthenticationBloc, AuthenticationState>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          if (state is LoggingUserOut) {
                            return const LoadingColumn(
                                message: 'Đang đăng xuất');
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 5,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<AuthenticationBloc>()
                                    .add(const LogoutUserEvent());
                                Navigator.of(context)
                                    .pushNamed(AppRouter.authentication);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(117, 116, 116, 0.251),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Đăng xuất',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                  ),
                  child: const Text(
                    'Danh sách bạn bè của tôi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: (state is GettingFriendships
                        ? const LoadingColumn(
                            message: 'Đang tải dữ liệu bạn bè')
                        : state is FriendshipsLoaded
                            ? Center(
                                child: GetFriendshipListView(
                                    friendships: state.friendships),
                              )
                            : const SizedBox.shrink()),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
