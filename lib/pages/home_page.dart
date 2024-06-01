// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sos_app/core/components/views/alert_dialog.dart';
import 'package:sos_app/core/components/widgets/toast_error.dart';
import 'package:sos_app/core/components/widgets/toast_success.dart';
import 'package:sos_app/core/constants/local_datasource_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/router/app_router.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:sos_app/core/sockets/socket.dart';
import 'package:sos_app/core/sockets/webrtc.dart';
import 'package:sos_app/core/utils/typedef.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/authentication/data/models/user_model.dart';
import 'package:sos_app/src/authentication/domain/params/update_location_params.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_state.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_event.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_state.dart';
import 'package:sos_app/src/friendship/presentation/views/friendship_screen.dart';
import 'package:sos_app/src/friendship/presentation/widgets/notify_call.dart';
import 'package:sos_app/src/notifications/domain/params/get_notifications_params.dart';
import 'package:sos_app/src/notifications/presentation/logic/notification_bloc.dart';
import 'package:sos_app/src/notifications/presentation/logic/notification_event.dart';
import 'package:sos_app/widgets/map_widget.dart';
import 'package:sos_app/widgets/sos_phone_widget.dart';
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? currentPos;
  final MapController mapController = MapController();
  UserModel currentUser = UserModel.constructor();
  Timer? timer;
  bool isShareCurrentLocation = false;
  final box = GetStorage();
  Timer? tracker;
  bool isTracking = false;
  List<String> friendshipIds = [];

  Future<void> getCurrentUser() async {
    await Future.delayed(Duration.zero, () async {
      final user = await sl<AuthenticationLocalDataSource>().getCurrentUser();
      setState(() {
        currentUser = user;
      });

      if (currentUser.userId.isNotEmpty) {
        await getFriendships();
        await getCurrentLocation();
      }
    });
  }

  Future<void> getSocket() async {
    final accessToken =
        await sl<AuthenticationLocalDataSource>().getAccessToken();

    if (accessToken != null) {
      await Socket.instance.init(accessToken);
      await WebRTCsHub.instance.init(accessToken);
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
    getCurrentUser();
    startTracker();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
    if (mounted) {
      timer?.cancel();
      tracker?.cancel();
    }
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    loc.Location locationR = loc.Location();

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        locationR.requestService();
        ScaffoldMessenger.of(context).showSnackBar(
            const ToastError(message: 'Dịch vụ vị trí không được bật!')
                .build(context));
      }

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(const ToastError(
                  message: 'Vui lòng cho phép ứng dụng truy cập vị trí!')
              .build(context));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        ScaffoldMessenger.of(context).showSnackBar(const ToastError(
                message: 'Ứng dụng này yêu cầu phải truy cập ví trí!')
            .build(context));
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          forceAndroidLocationManager: true,
        );

        locationR.enableBackgroundMode(enable: true);

        if (currentUser.userId.isNotEmpty) {
          await box.write(
              LocalDataSource.CURRENT_LATITUDE, currentLocation.latitude);
          await box.write(
              LocalDataSource.CURRENT_LONGITUDE, currentLocation.longitude);

          String currentAddress = '';

          if (!kIsWeb) {
            List<Placemark> placeMarks = await placemarkFromCoordinates(
              currentLocation.latitude,
              currentLocation.longitude,
            );
            Placemark place = placeMarks[0];
            currentAddress =
                '${place.street}, ${place.subAdministrativeArea}, ${place.country}';

            logger.f('currentLocation: $currentLocation');
            logger.f('currentAddress: $currentAddress');
          }

          setState(() {
            currentPos = currentLocation;
            currentUser.latitude = currentLocation.latitude;
            currentUser.longitude = currentLocation.longitude;
            currentUser.address = currentAddress;
          });
        }

        return currentLocation;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const ToastError(message: 'Có lỗi xảy ra khi truy cập vị trí!')
              .build(context));
    }
    return null;
  }

  handleSetting(BuildContext context) {
    Navigator.of(context).pushNamed(AppRouter.setting);
  }

  getFriendships() {
    context.read<FriendshipBloc>().add(GetFriendshipsEvent(
        params: GetFriendshipParams(userId: currentUser.userId, page: 1)));
  }

  handleFriendships(BuildContext context) {
    getFriendships();
    showDialog(
        context: context,
        builder: (context) {
          return const FriendshipScreen();
        });
  }

  fakeLocation(double localLatitude, double localLongitude) {
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

    setState(() {
      currentUser.latitude = localLatitude;
      currentUser.longitude = localLongitude;
    });
  }

  shareCurrentLocation() async {
    await getCurrentLocation();

    var localLatitude = await box.read(LocalDataSource.CURRENT_LATITUDE);
    var localLongitude = await box.read(LocalDataSource.CURRENT_LONGITUDE);

    if (localLongitude == null || localLatitude == null) {
      localLatitude = currentUser.latitude;
      localLongitude = currentUser.longitude;
    }

    // fakeLocation(localLatitude, localLongitude);

    DataMap data = {
      'friendId': currentUser.userId,
      'latitude': localLatitude,
      'longitude': localLongitude,
    };

    if (isShareCurrentLocation) {
      Socket.instance.hubConnection!.invoke("SendLocation",
          args: [jsonEncode(data), jsonEncode(friendshipIds)]);
    }
  }

  Future<void> sos() async {
    final isVictim = await box.read(LocalDataSource.IS_VICTIM);
    if (isVictim == null || currentUser == null) {
      return;
    }

    if (isVictim != null && isVictim && !currentUser.isVictim) {
      currentUser.isVictim = true;
    }

    var localLatitude = await box.read(LocalDataSource.CURRENT_LATITUDE);
    var localLongitude = await box.read(LocalDataSource.CURRENT_LONGITUDE);

    if (localLongitude == null || localLatitude == null) {
      localLatitude = currentUser.latitude;
      localLongitude = currentUser.longitude;
    }

    fakeLocation(localLatitude, localLongitude);

    DataMap data = {
      'victimId': currentUser.userId,
      'latitude': localLatitude ?? currentUser.latitude,
      'longitude': localLongitude ?? currentUser.longitude,
    };

    if (isTracking && Socket.instance.hubConnection != null) {
      Socket.instance.hubConnection!.invoke("SendTrackingLocation",
          args: [jsonEncode(data), jsonEncode(friendshipIds)]);
    }
  }

  void startTracker() async {
    final isVictim = await box.read(LocalDataSource.IS_VICTIM);
    final datetimeSos = await box.read(LocalDataSource.DATETIME_SOS);

    if (isVictim == null || !isVictim || datetimeSos == null) {
      return;
    }

    setState(() {
      isTracking = true;
    });

    logger.d('Start tracking victim');
    tracker = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        if (isTracking) {
          sos();
          questionSafe();
        } else {
          timer.cancel();
          logger.d('Stop tracking victim');
        }
      }
    });
  }

  void questionSafe() async {
    final datetimeSos = await box.read(LocalDataSource.DATETIME_SOS);
    final isShowSafe = await box.read(LocalDataSource.IS_SHOW_SAFE);

    if (isTracking &&
        isShowSafe == null &&
        datetimeSos != null &&
        DateTime.now().isAfter(DateTime.tryParse(datetimeSos)!)) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialogBase(
            title: const Text('Thông báo', style: TextStyle(fontSize: 20)),
            content: const Text(
              'Bạn đã an toàn chưa?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  box.write(
                      LocalDataSource.DATETIME_SOS,
                      DateTime.now()
                          .add(const Duration(seconds: 30))
                          .toString());
                  if (mounted) {
                    tracker!.cancel();
                  }
                  box.remove(LocalDataSource.IS_SHOW_SAFE);
                  startTracker();
                  Navigator.of(context).pop();
                },
                child: const Text('Từ chối'),
              ),
              TextButton(
                onPressed: () {
                  box.remove(LocalDataSource.IS_VICTIM);
                  box.remove(LocalDataSource.DATETIME_SOS);
                  box.remove(LocalDataSource.IS_TRACKING);
                  box.remove(LocalDataSource.IS_SHOW_SAFE);
                  logger.d('Stop tracking victim');
                  setState(() {
                    isTracking = false;
                    currentUser.isVictim = false;
                  });
                  if (Socket.instance.hubConnection != null) {
                    Socket.instance.hubConnection!.invoke("SendSafeFromVictim",
                        args: [jsonEncode(friendshipIds)]);
                  }
                  if (mounted) {
                    tracker!.cancel();
                  }
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouter.home,
                    ModalRoute.withName(''),
                  );
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
      await box.write(LocalDataSource.IS_SHOW_SAFE, true);
    }
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
              onPressed: () async {
                setState(() {
                  isShareCurrentLocation = !isShareCurrentLocation;
                });

                if (isShareCurrentLocation) {
                  trackPosition();
                } else {
                  final currentLocation = await getCurrentLocation();
                  context.read<AuthenticationBloc>().add(
                        UpdateLocationEvent(
                          params: UpdateLocationParams(
                            userId: currentUser.userId,
                            latitude: currentLocation!.latitude,
                            longitude: currentLocation.longitude,
                          ),
                        ),
                      );

                  context
                      .read<AuthenticationBloc>()
                      .add(const GetProfileEvent());

                  setState(() {
                    currentUser.latitude = currentLocation.latitude;
                    currentUser.longitude = currentLocation.longitude;
                  });

                  box.remove(LocalDataSource.IS_TRACKING);

                  if (mounted) {
                    timer!.cancel();
                  }
                }

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

  _handleNotification(BuildContext context) {
    context.read<NotificationBloc>().add(const GetNotificationsEvent(
        params: GetNotificationsParams(userId: '')));
    Navigator.of(context).pushNamed(AppRouter.notifications);
  }

  _handleContact(BuildContext context) {
    context.read<FriendshipBloc>().add(const GetFriendshipRecommendsEvent(
        params: GetFriendshipParams(userId: '', page: 1)));
    Navigator.of(context).pushNamed(AppRouter.contacts, arguments: 0);
  }

  @override
  Widget build(BuildContext context) {
    return NotifyCall(
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is LocationUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(const ToastSuccess(
                        message: 'Cập nhật vị trí hiện tại thành công!')
                    .build(context));
              }
            },
          ),
          BlocListener<FriendshipBloc, FriendshipState>(
            listener: (context, state) {
              if (state is FriendshipsLoaded) {
                setState(() {
                  friendshipIds =
                      state.friendships.map((fr) => fr.friendId).toList();
                });
              }
            },
          ),
        ],
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
                          offset: const Offset(0, 3),
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
                          offset: const Offset(0, 3),
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
                              offset: const Offset(0, 3),
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
                              offset: const Offset(0, 3),
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
                        offset: const Offset(0, 3),
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
      ),
    );
  }
}
