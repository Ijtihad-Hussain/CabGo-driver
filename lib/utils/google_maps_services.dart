
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsServices {
  static Future<Map<String, dynamic>> getDirections(
      LatLng origin, LatLng destination) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=<AIzaSyAnPZwviAk7_pC3ZTgZHA_QLe8nSsdMlIs>";
    http.Response response = await http.get(Uri.parse(url));
    Map<String, dynamic> data = jsonDecode(response.body);
    return data['routes'][0]['legs'][0]['distance'];
  }
}
