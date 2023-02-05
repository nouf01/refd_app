import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:refd_app/LoginSignUp/providerSign/ProviderSignUp.dart';

class providerSetLoc extends StatefulWidget {
  const providerSetLoc({super.key});

  @override
  State<providerSetLoc> createState() => _MyproviderSetLocState();
}

class _MyproviderSetLocState extends State<providerSetLoc> {
  //variables needed for the map
  static LatLng _userCurrentPosition = LatLng(0, 0);
  late LatLng _providerLoc;
  late Marker _providerMarker;

  var currentLan, currentLat;
  late Completer<GoogleMapController> mapController;
  final Set<Marker> _mapMarkers = {};

  void _getUserCurrentLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition();

    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    currentLan = currentPosition.latitude;
    currentLat = currentPosition.longitude;
    setState(() {
      _userCurrentPosition =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      _providerLoc = _userCurrentPosition;
      _providerMarker =
          Marker(markerId: MarkerId("provider"), position: _providerLoc);
      _mapMarkers.add(_providerMarker);
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController.complete(controller);
    });
  }

  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
    _getUserCurrentLocation();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF66CDAA),
          title: Text("First set your location"),
        ),
        body: _userCurrentPosition.latitude == 0 &&
                _userCurrentPosition.longitude == 0
            ? Center(
                child: SpinKitFadingCube(
                  size: 85,
                  color: Color(0xFF66CDAA),
                ),
              )
            : Stack(
                children: [
                  Positioned.fill(
                      child: Scaffold(
                    body: Container(
                      child: Stack(children: [
                        GoogleMap(
                            markers: _mapMarkers,
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: _userCurrentPosition,
                              zoom: 15.0,
                            ),
                            onMapCreated: _onMapCreated,
                            zoomGesturesEnabled: true,
                            myLocationEnabled: true,
                            compassEnabled: true,
                            myLocationButtonEnabled: false,
                            onTap: (LatLng loc) {
                              setState(() {
                                _providerLoc = loc;
                                _providerMarker = Marker(
                                    markerId: MarkerId("provider"),
                                    position: _providerLoc);
                                _mapMarkers.remove(1);
                                _mapMarkers.add(_providerMarker);
                              });
                            }),
                        Container(
                          width: 500,
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProviderSignUp(
                                            providerLat: _providerLoc.latitude,
                                            providerLong:
                                                _providerLoc.longitude,
                                          )),
                                );
                              },
                              child: const Text(
                                "Confirm location",
                                selectionColor: Colors.white,
                                style: TextStyle(fontSize: 27),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 78, 183, 175)),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              )),
                        ),
                      ]),
                    ),
                  ))
                ],
              ));
  }
}
