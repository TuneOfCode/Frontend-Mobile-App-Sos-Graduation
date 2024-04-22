import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sos_app/core/router/app_router.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_bloc.dart';
import 'package:sos_app/src/authentication/presentation/logic/authentication_event.dart';
import 'package:sos_app/widgets/icon_button_widget.dart';
import 'package:sos_app/widgets/map_widget.dart';
import 'package:sos_app/widgets/sos_phone_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Position? _currentPos;
  final MapController _mapController = MapController();
  late bool servicePermission = false;
  late LocationPermission permission;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  Future<Position?> _getCurrentPos() async {
    servicePermission = await Geolocator.isLocationServiceEnabled();

    try {
      if (!servicePermission) {
        debugPrint('>>>>>>>>>>>>>> Dịch vụ không được bật');
      }

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        debugPrint('>>>>>>>>>>>>>> Người dùng từ chối vĩnh viễn');
        // return null;
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(e.toString()),
      //   ),
      // );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            mapController: _mapController,
            currentPos: _currentPos,
          ),
          Positioned(
            top: 80,
            left: 5,
            child: InkWell(
              onTap: () {
                context.read<AuthenticationBloc>().add(const GetProfileEvent());
                Navigator.of(context).pushNamed(AppRouter.updateProfile);
              },
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
                      offset: const Offset(0, 3), // changes position of shadow
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
              onTap: () {},
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
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                height: 60,
                width: 60,
                child: const Icon(
                  Icons.chat,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          IconButtonWidget(
            left: 90,
            bottom: 40,
            iconColor: Colors.red[400],
            icon: Icons.car_crash,
            onPressed: () {},
          ),
          IconButtonWidget(
            left: 120,
            bottom: 100,
            iconColor: Colors.red[400],
            icon: Icons.medication,
            onPressed: () {},
          ),
          const SosPhoneWidget(),
          IconButtonWidget(
            right: 120,
            bottom: 100,
            iconColor: Colors.red[400],
            icon: Icons.storm,
            onPressed: () {},
          ),
          IconButtonWidget(
            right: 90,
            bottom: 40,
            iconColor: Colors.red[400],
            icon: Icons.fireplace,
            onPressed: () {},
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
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
                        offset:
                            const Offset(0, 3), // changes position of shadow
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
                Container(
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
                        offset:
                            const Offset(0, 3), // changes position of shadow
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
                onPressed: () async {
                  _currentPos = await _getCurrentPos();

                  setState(() {
                    if (_currentPos != null) {
                      _mapController.move(
                        LatLng(
                          _currentPos!.latitude,
                          _currentPos!.longitude,
                        ),
                        16,
                      );
                    }
                  });

                  debugPrint('====> vị trí hiện tại: $_currentPos');
                },
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
    );
  }
}