import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/Elements/PolylineService.dart';
import '../Consumer_Screens/ConfirmOrder.dart';
import '../DataModel/DB_Service.dart';
import 'package:refd_app/Elements/directions_model.dart';
import 'directions_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' show cos, sqrt, asin;

class path extends StatefulWidget {
  final Provider p;
  const path({required this.p, super.key});

  @override
  State<path> createState() => _path();
}

class _path extends State<path> {
  Completer<GoogleMapController> _controller = Completer();
  late Directions _info;
  static LatLng _userCurrentPosition = LatLng(0, 0);
  var consumerLan, consumerLat;
  Database service = Database();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getUserCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF66CDAA),
        title: Text("Your route to " + this.widget.p.get_commercialName),
        centerTitle: true,
      ),
      body: _userCurrentPosition.latitude == 0 &&
              _userCurrentPosition.longitude == 0
          ? Center(
              child: SpinKitFadingCube(
                size: 85,
                color: Colors.green,
              ),
            )
          : Stack(alignment: Alignment.center, children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: _userCurrentPosition,
                  // LatLng(24.719542, 46.641266), //>>>> here currentLocation
                  zoom: 12.4746,
                ),
                polylines: _polylines,
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _drawPolyline(_userCurrentPosition,
                      LatLng(this.widget.p.get_Lat, this.widget.p.get_Lang));
                  _controller.complete(controller);
                },
              ),
              _buildBottom(),
            ]),
    );
  }

  Future<void> _drawPolyline(LatLng from, LatLng to) async {
    Polyline polyline = await PolylineService().drawPolyline(from, to);
    _polylines.add(polyline);

    _setMarkerfrom(from);
    _setMarkerto(to);

    setState(() {});
  }

  void _setMarkerto(LatLng _location) async {
    var directions = (await DirectionsRepository().getDirections(
        origin: LatLng(consumerLat, consumerLan), destination: _location));
    setState(() => _info = directions!);
    _markers.add(
      Marker(
        markerId: MarkerId(_location.toString()),
        icon: BitmapDescriptor.defaultMarker,
        position: _location,
        infoWindow: InfoWindow(
          title: this.widget.p!.get_commercialName,
          snippet: "${_info!.totalDistance}, ${_info!.totalDuration}",
        ),
      ),
    );

    setState(() {});
  }

  void _setMarkerfrom(LatLng _location) {
    _markers.add(
      Marker(
        markerId: MarkerId(_location.toString()),
        icon: BitmapDescriptor.defaultMarker,
        position: _location,
        infoWindow: InfoWindow(
          title: "You ",
        ),
      ),
    );

    setState(() {});
  }

  Positioned _buildBottom() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16,
          bottom: 8.0,
          top: 4.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16.0,
                      ),
                      backgroundColor: Color(0xFF66CDAA),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ConfirmOrder()));
                    },
                    child: Text("Continue"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _getUserCurrentLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    consumerLat = currentPosition.latitude;
    consumerLan = currentPosition.longitude;
    setState(() {
      _userCurrentPosition =
          LatLng(currentPosition.latitude, currentPosition.longitude);
    });
  }
}
