// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sos_app/core/components/views/alert_dialog.dart';
import 'package:sos_app/core/components/widgets/toast_error.dart';
import 'package:sos_app/core/constants/local_datasource_constant.dart';
import 'package:sos_app/core/router/app_router.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:sos_app/core/sockets/socket.dart';
import 'package:sos_app/core/sockets/webrtc.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/authentication/data/models/user_model.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_event.dart';
import 'package:sos_app/src/friendship/presentation/views/friendship_screen.dart';
import 'package:sos_app/src/friendship/presentation/widgets/notify_call.dart';
import 'package:sos_app/widgets/map_widget.dart';
import 'package:sos_app/widgets/sos_phone_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? currentPos;
  final MapController mapController = MapController();
  late bool servicePermission = false;
  late LocationPermission permission;
  UserModel currentUser = UserModel.constructor();
  Timer? timer;
  bool isShareCurrentLocation = false;

  Future<void> getCurrentUser() async {
    await Future.delayed(Duration.zero, () async {
      final user = await sl<AuthenticationLocalDataSource>().getCurrentUser();
      setState(() {
        currentUser = user;
      });
    });
  }

  Future<void> getSocket() async {
    final accessToken =
        await sl<AuthenticationLocalDataSource>().getAccessToken();

    if (accessToken != null) {
      await Socket.instance.init(accessToken);
      await WebRTCsHub.instance.init(accessToken);
      getCurrentPos();
    }
  }

  void trackPosition() async {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (isShareCurrentLocation) {
        await shareCurrentLocation();
      }
    });
  }

  @override
  void initState() {
    getSocket();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
    timer?.cancel();
  }

  Future<Position?> getCurrentPos() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();

    try {
      if (!servicePermission) {
        ScaffoldMessenger.of(context).showSnackBar(
            const ToastError(message: 'Dịch vụ vị trí không được bật!')
                .build(context));
      }

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        ScaffoldMessenger.of(context).showSnackBar(const ToastError(
                message: 'Ứng dụng này yêu cầu phải truy cập ví trí!')
            .build(context));

        getFriendships();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const ToastError(message: 'Có lỗi xảy ra khi truy cập vị trí')
              .build(context));
    }

    // List<Location> locations =
    //     await locationFromAddress("Phu Loc, Thua Thien Hue");
    // logger.d('locations: $locations');

    Position currentLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    );

    await getCurrentUser();

    if (currentUser.userId.isNotEmpty &&
        currentUser.latitude != currentLocation.latitude &&
        currentUser.longitude != currentLocation.longitude) {
      // await sl<FlutterSecureStorage>()
      //     .delete(key: LocalDataSource.CURRENT_USER);

      // context.read<AuthenticationBloc>().add(
      //       UpdateLocationEvent(
      //         params: UpdateLocationParams(
      //           userId: currentUser.userId,
      //           latitude: currentLocation.latitude,
      //           longitude: currentLocation.longitude,
      //         ),
      //       ),
      //     );

      // context.read<AuthenticationBloc>().add(const GetProfileEvent());
    }

    return currentLocation;
  }

  handleSetting(BuildContext context) {
    Navigator.of(context).pushNamed(AppRouter.setting);
  }

  getFriendships() {
    context.read<FriendshipBloc>().add(const GetFriendshipsEvent(
        params: GetFriendshipParams(userId: '', page: 1)));
  }

  handleFriendships(BuildContext context) {
    getFriendships();
    showDialog(
        context: context,
        builder: (context) {
          return const FriendshipScreen();
        });
  }

  shareCurrentLocation() async {
    // currentPos = await getCurrentPos();

    final box = GetStorage();

    final localLatitude = box.read(LocalDataSource.CURRENT_LATITUDE);
    final localLongitude = box.read(LocalDataSource.CURRENT_LONGITUDE);

    final fakeLocation = Random().nextDouble() * 0.00001;

    if (localLatitude == null || localLongitude == null) {
      box.write(LocalDataSource.CURRENT_LATITUDE,
          currentUser.latitude + fakeLocation);
      box.write(LocalDataSource.CURRENT_LONGITUDE,
          currentUser.longitude + fakeLocation);
    } else {
      box.write(LocalDataSource.CURRENT_LATITUDE, localLatitude + fakeLocation);
      box.write(
          LocalDataSource.CURRENT_LONGITUDE, localLongitude + fakeLocation);
    }

    DataMap data = {
      'friendId': currentUser.userId,
      'latitude': localLatitude,
      'longitude': localLongitude,
    };

    // await sl<FlutterSecureStorage>().delete(key: LocalDataSource.CURRENT_USER);
    // context.read<AuthenticationBloc>().add(
    //       UpdateLocationEvent(
    //         params: UpdateLocationParams(
    //           userId: currentUser.userId,
    //           latitude: newLatitude,
    //           longitude: newLongitude,
    //         ),
    //       ),
    //     );
    // context.read<AuthenticationBloc>().add(const GetProfileEvent());

    if (isShareCurrentLocation) {
      Socket.instance.hubConnection!
          .invoke("SendLocation", args: [jsonEncode(data)]);
    }

    // setState(() {
    //   if (currentPos != null) {
    //     mapController.move(
    //       LatLng(
    //         newLatitude,
    //         newLongitude,
    //       ),
    //       16,
    //     );
    //   }
    // });

    debugPrint('====> vị trí hiện tại: $currentPos');
  }

  handleCurrentPosition() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialogBase(
          title: const Text('Thông báo', style: TextStyle(fontSize: 20)),
          content: Text(
            !isShareCurrentLocation
                ? 'Bạn có muốn bật chia sẻ vị trí của bản thân đến bạn bè không?'
                : 'Bạn có muốn tắt chia sẻ vị trí của bản thân đến bạn bè không?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Từ chối'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isShareCurrentLocation = !isShareCurrentLocation;
                });
                isShareCurrentLocation ? trackPosition() : timer!.cancel();
                Navigator.of(context).pop();
              },
              child: Text(
                'Đồng ý',
                style: TextStyle(
                  color: Colors.green[800],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _handleNotification(BuildContext context) {}

  _handleContact(BuildContext context) {
    context.read<FriendshipBloc>().add(const GetFriendshipRecommendsEvent(
        params: GetFriendshipParams(userId: '', page: 1)));
    Navigator.of(context).pushNamed(AppRouter.contacts, arguments: 0);
  }

  @override
  Widget build(BuildContext context) {
    return NotifyCall(
      child: Scaffold(
        body: Stack(
          children: [
            MapWidget(
              mapController: mapController,
              currentPos: currentPos,
            ),
            Positioned(
              top: 80,
              left: 5,
              child: InkWell(
                onTap: () => handleSetting(context),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 3.0,
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        20,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 60,
                  width: 60,
                  child: const Icon(
                    Icons.settings,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 80,
              right: 5,
              child: InkWell(
                onTap: () => handleFriendships(context),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 3.0,
                      color: Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        20,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 60,
                  width: 60,
                  child: const Icon(
                    Icons.group,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SosPhoneWidget(),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => _handleNotification(context),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 3.0,
                          color: Colors.transparent,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            20,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      height: 60,
                      width: 60,
                      child: const Icon(
                        Icons.notifications,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _handleContact(context),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 3.0,
                          color: Colors.transparent,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            20,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      height: 60,
                      width: 60,
                      child: const Icon(
                        Icons.contacts,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 120,
              right: 5,
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    width: 3.0,
                    color: Colors.transparent,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      20,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                height: 60,
                width: 60,
                child: IconButton(
                  onPressed: handleCurrentPosition,
                  icon: const Icon(
                    Icons.my_location_sharp,
                    size: 40,
                    color: Colors.black,
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
