// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:sos_app/core/components/views/alert_dialog.dart';
import 'package:sos_app/core/constants/api_config_constant.dart';
import 'package:sos_app/core/constants/logger_constant.dart';
import 'package:sos_app/core/services/injection_container_service.dart';
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
  late HubConnection? _notifyHub;
  UserModel currentUser = UserModel.constructor();
  List<Friendship> friendships = [];
  List<Marker> markers = [];

  Future<void> getCurrentUser() async {
    await Future.delayed(Duration.zero, () async {
      final user = await sl<AuthenticationLocalDataSource>().getCurrentUser();
      setState(() {
        currentUser = user;
      });
      if (currentUser.userId.isNotEmpty) {
        context.read<FriendshipBloc>().add(const GetFriendshipsEvent(
            params: GetFriendshipParams(userId: '', page: 1)));
        widget.mapController.move(
            LatLng(
              currentUser.latitude,
              currentUser.longitude,
            ),
            16);
      }
    });
  }

  Future<void> getFriendships() async {
    await Future.delayed(Duration.zero, () async {
      final localFriendships =
          await sl<FriendshipLocalDataSource>().getFriendships();
      setState(() {
        friendships = localFriendships;
      });
    });
  }

  Future<void> getNotifyHub() async {
    final accessToken =
        await sl<AuthenticationLocalDataSource>().getAccessToken();

    if (accessToken != null) {
      await Socket.instance.init(accessToken);
      setState(() {
        _notifyHub = Socket.instance.hubConnection;
      });
      if (_notifyHub != null) {
        _notifyHub!.on("ReceiveNotification", (arguments) async {
          // await GetStorage().remove(LocalDataSource.FRIENDSHIPS);
          context.read<FriendshipBloc>().add(const GetFriendshipsEvent(
              params: GetFriendshipParams(userId: '', page: 1)));
        });

        _notifyHub!.on("ReceiveLocation", (arguments) async {
          logger.d('Receive location in map widget: $arguments');
          final data = jsonDecode(arguments![0].toString());

          if (currentUser.userId == data['friendId']) {
            // widget.mapController.move(
            //     LatLng(
            //       data['latitude'],
            //       data['longitude'],
            //     ),
            //     8);
            setState(() {
              currentUser.latitude = data['latitude'];
              currentUser.longitude = data['longitude'];
            });
          }

          for (var friendship in friendships) {
            if (friendship.friendId == data['friendId']) {
              setState(() {
                friendship.friendLatitude = data['latitude'];
                friendship.friendLongitude = data['longitude'];
              });
            }
          }
        });
      }
    }
  }

  getMarkers() {
    final markerMe = Marker(
      point: widget.currentPos != null
          ? LatLng(
              widget.currentPos!.latitude,
              widget.currentPos!.longitude,
            )
          : LatLng(
              currentUser.latitude,
              currentUser.longitude,
            ),
      width: 60,
      height: 60,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {},
        child: CustomMarkerWidget(
          imageUrl: '${ApiConfig.BASE_IMAGE_URL}${currentUser.avatarUrl}',
          title: currentUser.fullName,
          colorPin: Colors.black,
        ),
      ),
    );

    setState(() {
      markers.add(markerMe);
    });

    if (friendships.isNotEmpty) {
      for (var friendship in friendships) {
        final markerFriendship = Marker(
          point: LatLng(
            friendship.friendLatitude,
            friendship.friendLongitude,
          ),
          width: 60,
          height: 60,
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {},
            child: CustomMarkerWidget(
              imageUrl: '${ApiConfig.BASE_IMAGE_URL}${friendship.friendAvatar}',
              title: friendship.fullName,
              colorPin: Colors.blue[800],
            ),
          ),
        );

        setState(() {
          markers.add(markerFriendship);
        });
      }
    }
  }

  @override
  void initState() {
    getCurrentUser();
    getNotifyHub();
    // getFriendships();
    getMarkers();
    super.initState();
  }

  @override
  void dispose() {
    if (_notifyHub != null) {
      _notifyHub!.off("ReceiveNotification");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FriendshipBloc, FriendshipState>(
      listener: (context, state) {
        if (state is FriendshipsLoaded) {
          setState(() {
            friendships = state.friendships;
          });
          // logger.f('friendships in map widget: $friendships');
        }
      },
      builder: (context, state) => FlutterMap(
        mapController: widget.mapController,
        options: MapOptions(
          initialCenter: LatLng(
            currentUser.latitude,
            currentUser.longitude,
          ),
          onMapReady: () {
            setState(() {});
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.sos_app',
            subdomains: const ['a', 'b', 'c'],
            tileProvider: CancellableNetworkTileProvider(),
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
                child: CustomMarkerWidget(
                  imageUrl:
                      '${ApiConfig.BASE_IMAGE_URL}${currentUser.avatarUrl}',
                  title: currentUser.fullName,
                  colorPin: Colors.black,
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
                                  Text(
                                      'Toạ độ: (${friendship.friendLatitude}, ${friendship.friendLongitude})'),
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
