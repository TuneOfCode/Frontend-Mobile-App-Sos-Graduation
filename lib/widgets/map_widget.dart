import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
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
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: widget.mapController,
      options: const MapOptions(
        initialCenter: LatLng(
          16.4634687,
          107.5778275,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.sos_app',
          subdomains: const ['a', 'b', 'c'],
          tileProvider: CancellableNetworkTileProvider(),
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: widget.currentPos != null
                  ? LatLng(
                      widget.currentPos!.latitude,
                      widget.currentPos!.longitude,
                    )
                  : const LatLng(
                      10,
                      10,
                    ),
              width: 60,
              height: 60,
              alignment: Alignment.center,
              child: CustomMarkerWidget(
                imageUrl:
                    'https://lh3.googleusercontent.com/ogw/AF2bZygo9L-AquHOa_WA1fkxJyGh_hw7bNa91I35AJ6X=s32-c-mo',
                title: 'Trần Thanh Tú',
                colorPin: Colors.blue[600],
              ),
            ),
            const Marker(
              point: LatLng(16.5778849, 107.515872),
              width: 60,
              height: 60,
              alignment: Alignment.center,
              child: CustomMarkerWidget(
                imageUrl:
                    'https://lh3.googleusercontent.com/a-/ALV-UjV8__iFZZeLsW-9THiul9hVIySCXlwaJp9l2VQZquXg3gY=s40-p',
                title: 'Hoàng Thị Ngọc Yến',
                colorPin: Colors.pinkAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
