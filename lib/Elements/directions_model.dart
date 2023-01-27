import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//This class will give us the real  Distance & Duration of the trip path
class Directions {
  final String totalDistance;
  final String totalDuration;

  const Directions({
    required this.totalDistance,
    required this.totalDuration,
  });

  factory Directions.fromMap(Map<String, dynamic> map) {
    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    // Distance & Duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}
