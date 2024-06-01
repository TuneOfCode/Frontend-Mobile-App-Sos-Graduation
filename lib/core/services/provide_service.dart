import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class ProvideService {
  ProvideService._();

  static Future<List<LatLng>> getRouterMap(
      latitude1, longitude1, latitude2, longitude2) async {
    List<LatLng> routepoints = [];

    var url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$longitude1,$latitude1;$longitude2,$latitude2?steps=true&annotations=true&geometries=geojson&overview=full');
    var response = await http.get(url);

    var routers =
        jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
    for (int i = 0; i < routers.length; i++) {
      var reep = routers[i].toString();
      reep = reep.replaceAll("[", "");
      reep = reep.replaceAll("]", "");
      var lat1 = reep.split(',');
      var long1 = reep.split(",");
      routepoints.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
    }

    return routepoints;
  }
}
