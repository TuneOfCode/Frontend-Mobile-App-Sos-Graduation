// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:sos_app/core/components/views/alert_dialog.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/local_datasource_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
import 'package:sos_app/core/services/provide_service.dart';
import 'package:sos_app/core/sockets/socket.dart';
import 'package:sos_app/src/authentication/data/datasources/local/authentication_local_datasource.dart';
import 'package:sos_app/src/authentication/data/models/user_model.dart';
import 'package:sos_app/src/friendship/data/datasources/local/friendship_local_datasource.dart';
import 'package:sos_app/src/friendship/domain/entities/friendship.dart';
import 'package:sos_app/src/friendship/domain/params/get_friendship_params.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_bloc.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_event.dart';
import 'package:sos_app/src/friendship/presentation/logic/friendship_state.dart';
import 'package:sos_app/widgets/custom_marker_widget.dart';

class MapWidget extends StatefulWidget {
  final MapController mapController;
  final Position? currentPos;

  const MapWidget({
    super.key,
    required this.mapController,
    required this.currentPos,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  UserModel currentUser = UserModel.constructor();
  List<Friendship> friendships = [];
  List<Marker> markers = [];
  List<LatLng> routepoints = [];
  bool isShowRouter = false;
  final box = GetStorage();
  final _cacheStore = MemCacheStore();
  AudioPlayer player = AudioPlayer();
  final UrlSource bellSosWarning =
      UrlSource('${ApiConfig.BASE_IMAGE_URL}/medias/bell-sos-warning.mp3');

  Future<void> getCurrentUser() async {
    await Future.delayed(Duration.zero, () async {
      final user = await sl<AuthenticationLocalDataSource>().getCurrentUser();
      setState(() {
        currentUser = user;
      });
      if (currentUser.userId.isNotEmpty) {
        await getFriendships();
        widget.mapController.move(
            LatLng(
              currentUser.latitude,
              currentUser.longitude,
            ),
            16);
        if (!kIsWeb) {
          List<Placemark> placeMarks = await placemarkFromCoordinates(
            currentUser.latitude,
            currentUser.longitude,
          );
          Placemark place = placeMarks[0];
          String currentAddress =
              '${place.street}, ${place.subAdministrativeArea}, ${place.country}';
          setState(() {
            currentUser.address = currentAddress;
          });
        }
      }
    });
  }

  Future<void> getFriendships() async {
    await Future.delayed(Duration.zero, () async {
      final localFriendships =
          await sl<FriendshipLocalDataSource>().getFriendships();
      if (friendships.isEmpty && localFriendships.isNotEmpty) {
        setState(() {
          friendships = localFriendships;
        });
      } else {
        context.read<FriendshipBloc>().add(const GetFriendshipsEvent(
            params: GetFriendshipParams(userId: '', page: 1)));
      }
    });
  }

  Future<void> getNotifyHub() async {
    final accessToken =
        await sl<AuthenticationLocalDataSource>().getAccessToken();

    if (accessToken != null) {
      if (Socket.instance.hubConnection != null) {
        Socket.instance.hubConnection!.on("ReceiveLocation", (arguments) async {
          logger.d('Receive location in map widget: $arguments');
          final data = jsonDecode(arguments![0].toString());
          final latitude = double.parse(data['latitude'].toString());
          final longitude = double.parse(data['longitude'].toString());

          String currentAddress = '';
          if (!kIsWeb) {
            List<Placemark> placeMarks = await placemarkFromCoordinates(
              latitude,
              longitude,
            );
            Placemark place = placeMarks[0];
            currentAddress =
                '${place.street}, ${place.subAdministrativeArea}, ${place.country}';
          }

          if (mounted &&
              currentUser != null &&
              currentUser.userId == data['friendId'].toString()) {
            setState(() {
              currentUser.latitude = latitude;
              currentUser.longitude = longitude;
              currentUser.address = currentAddress;
            });
          }

          if (mounted && friendships != null && friendships.isNotEmpty) {
            for (var friendship in friendships) {
              if (friendship.friendId == data['friendId'].toString()) {
                setState(() {
                  friendship.friendLatitude = latitude;
                  friendship.friendLongitude = longitude;
                  friendship.friendshipAddress = currentAddress;
                });
              }
            }
          }

          final isTracking = box.read(LocalDataSource.IS_TRACKING);
          if (mounted && isTracking == null) {
            // widget.mapController.move(
            //     LatLng(
            //       latitude,
            //       longitude,
            //     ),
            //     20);

            box.write(LocalDataSource.IS_TRACKING, true);
          }
        });

        Socket.instance.hubConnection!.on("TrackLocation", (arguments) async {
          logger.d('Track location in map widget: $arguments');
          final data = jsonDecode(arguments![0].toString());
          final latitude = double.parse(data['latitude'].toString());
          final longitude = double.parse(data['longitude'].toString());
          final isTracking = box.read(LocalDataSource.IS_TRACKING);

          String currentAddress = '';
          if (!kIsWeb) {
            List<Placemark> placeMarks = await placemarkFromCoordinates(
              latitude,
              longitude,
            );
            Placemark place = placeMarks[0];
            currentAddress =
                '${place.street}, ${place.subAdministrativeArea}, ${place.country}';
          }

          if (mounted &&
              currentUser != null &&
              data != null &&
              currentUser.userId == data['victimId'].toString()) {
            setState(() {
              currentUser.latitude = latitude;
              currentUser.longitude = longitude;
              currentUser.isVictim = true;
              currentUser.address = currentAddress;
            });
          }

          if (mounted && friendships != null && friendships.isNotEmpty) {
            for (var friendship in friendships) {
              if (data != null &&
                  friendship.friendId == data['victimId'].toString()) {
                var routePointersData = await ProvideService.getRouterMap(
                  currentUser.latitude,
                  currentUser.longitude,
                  latitude,
                  longitude,
                );
                setState(() {
                  friendship.friendLatitude = latitude;
                  friendship.friendLongitude = longitude;
                  friendship.isVictim = true;
                  friendship.friendshipAddress = currentAddress;
                  routepoints = routePointersData;
                  isShowRouter = true;
                });

                if (isTracking != null && isTracking) {
                  await player.stop();
                  player.dispose();
                }
              }
            }
          }

          if (mounted && isTracking == null) {
            widget.mapController.move(
                LatLng(
                  latitude,
                  longitude,
                ),
                20);
            box.write(LocalDataSource.IS_TRACKING, true);
          }
          await player.resume();
        });

        Socket.instance.hubConnection!.on("ReceiveSafeFromVictim",
            (arguments) async {
          box.remove(LocalDataSource.IS_VICTIM);
          box.remove(LocalDataSource.DATETIME_SOS);
          box.remove(LocalDataSource.IS_TRACKING);

          final victimId = arguments![0].toString();
          logger.d('Receive safe from victim in map widget: $victimId');
          if (mounted && friendships != null && friendships.isNotEmpty) {
            for (var friendship in friendships) {
              if (victimId != null && friendship.friendId == victimId) {
                setState(() {
                  friendship.isVictim = false;
                  routepoints = [];
                  isShowRouter = false;
                });
              }
            }
          }

          await player.stop();
          player.dispose();
        });
      }
    }
  }

  @override
  void initState() {
    getCurrentUser();
    getNotifyHub();
    player = AudioPlayer();
    player.setReleaseMode(ReleaseMode.stop);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(bellSosWarning);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendshipBloc, FriendshipState>(
      listener: (context, state) async {
        if (state is FriendshipsLoaded) {
          setState(() {
            friendships = state.friendships;
          });

          if (!kIsWeb && friendships != null && friendships.isNotEmpty) {
            for (var friendship in friendships) {
              List<Placemark> placeMarks = await placemarkFromCoordinates(
                friendship.friendLatitude,
                friendship.friendLongitude,
              );
              Placemark place = placeMarks[0];
              String currentAddress =
                  '${place.street}, ${place.subAdministrativeArea}, ${place.country}';
              setState(() {
                friendship.friendshipAddress = currentAddress;
              });
            }
          }
        }
      },
      builder: (context, state) => FlutterMap(
        mapController: widget.mapController,
        options: MapOptions(
          initialCenter: LatLng(
            currentUser.latitude,
            currentUser.longitude,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.sos_app',
            subdomains: const ['a', 'b', 'c'],
            // tileProvider: CancellableNetworkTileProvider(),
            tileProvider: CachedTileProvider(
              maxStale: const Duration(days: 30),
              store: _cacheStore,
            ),
          ),
          Visibility(
            visible: isShowRouter,
            child: PolylineLayer(
              polylineCulling: false,
              polylines: [
                Polyline(points: routepoints, color: Colors.red, strokeWidth: 8)
              ],
            ),
          ),
          MarkerLayer(
            // markers: markers,
            markers: [
              Marker(
                point: LatLng(
                  currentUser.latitude,
                  currentUser.longitude,
                ),
                // point: widget.currentPos != null
                //     ? LatLng(
                //         widget.currentPos!.latitude,
                //         widget.currentPos!.longitude,
                //       )
                //     : LatLng(
                //         currentUser.latitude,
                //         currentUser.longitude,
                //       ),
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialogBase(
                          title: const Center(
                            child: Text(
                              'Thông tin bạn bè',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    'Họ và tên: ${currentUser.fullName} (Bạn)'),
                                Text('Vĩ độ: ${currentUser.latitude}'),
                                Text('Kinh độ: ${currentUser.longitude}'),
                                Text('Địa chỉ: ${currentUser.address}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: CustomMarkerWidget(
                    imageUrl:
                        '${ApiConfig.BASE_IMAGE_URL}${currentUser.avatarUrl}',
                    title: currentUser.fullName,
                    colorPin: Colors.black,
                    isVictim: currentUser.isVictim,
                  ),
                ),
              ),
              for (final friendship in friendships) ...[
                Marker(
                  point: LatLng(
                    friendship.friendLatitude,
                    friendship.friendLongitude,
                  ),
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialogBase(
                            title: const Center(
                              child: Text(
                                'Thông tin bạn bè',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Họ và tên: ${friendship.friendFullName}'),
                                  Text('Vĩ độ: ${friendship.friendLatitude}'),
                                  Text(
                                      'Kinh độ: ${friendship.friendLongitude}'),
                                  Text(
                                      'Địa chỉ: ${friendship.friendshipAddress}'),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: CustomMarkerWidget(
                      imageUrl:
                          '${ApiConfig.BASE_IMAGE_URL}${friendship.friendAvatar}',
                      title: friendship.fullName,
                      colorPin: Colors.blue[800],
                      isVictim: friendship.isVictim,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
