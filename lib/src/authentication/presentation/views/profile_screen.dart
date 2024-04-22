import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';

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
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {},
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
                          onPressed: () {},
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
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 5,
                        ),
                        child: ElevatedButton(
                          onPressed: () {},
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
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
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
                    // child: ListView.builder(
                    //   padding: const EdgeInsets.only(top: 20),
                    //   physics: const NeverScrollableScrollPhysics(),
                    //   shrinkWrap: true,
                    //   itemCount: state.authUser.playlists!
                    //       .length, // Playlist.playlists.length
                    //   itemBuilder: (context, index) {
                    //     return PlaylistCardWidget(
                    //         playlist: state.authUser.playlists![index]);
                    //   },
                    // ),
                    child: const Center(
                      child: Text(
                        'Danh sách bạn bè trống',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
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
