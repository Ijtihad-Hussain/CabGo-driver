

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Driver {
  final String name;
  final LatLng location;
  final double distance;

  Driver({required this.name, required this.location, required this.distance});
}