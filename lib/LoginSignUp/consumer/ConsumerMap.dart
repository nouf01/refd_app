import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:refd_app/Consumer_Screens/restaurantDetail.dart';
import 'package:refd_app/DataModel/Provider.dart';
import '../../DataModel/DB_Service.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:url_launcher/url_launcher.dart';

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

class ConsumerMap extends StatefulWidget {
  const ConsumerMap({super.key});

  @override
  State<ConsumerMap> createState() => _ConsumerMapState();
}

class _ConsumerMapState extends State<ConsumerMap> {
  late Completer<GoogleMapController> mapController;

  static LatLng _userCurrentPosition = LatLng(0, 0);
  final Set<Marker> _mapMarkers = {};
  var consumerLan, consumerLat;
  BitmapDescriptor? myIcon;

  //firebase variables
  Database db = Database();
  var currentProvider;
  var currentUser;

  //user info
  var userEmail,
      provname,
      provphoneNumber,
      logoURL,
      commercialReg,
      tags,
      rate,
      lat,
      lang;

  var SelectedProv,
      Selectedprovname,
      SelectedprovphoneNumber,
      SelectedlogoURL,
      Selectedtags,
      SelectedRate,
      SelectedLat,
      SelectedLang;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(10, 10)), 'images/logo7.png')
        .then((onValue) {
      myIcon = onValue;
    });
    _getUserCurrentLocation();
    _getProviders();
  }

  var refdMarker;
  // declared method to get Images
  Future<Uint8List> getImages() async {
    ByteData data = await rootBundle.load('images/refdLogo.png');
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: 80);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  var markerid = 0;

  var providerInfoId = 0;
  List<Map> providersInfo = [{}];
  Future _getProviders() async {
    //retrive all providers
    List<Provider> pList = await db.retrieveAllProviders();
    for (int i = 0; i < pList.length; i++) {
      currentProvider = pList[i];
      provname = currentProvider.get_commercialName;
      provphoneNumber = currentProvider.get_phoneNumber;
      logoURL = currentProvider.get_logoURL;
      commercialReg = currentProvider.get_commercialReg;
      tags = currentProvider.get_tags;
      rate = currentProvider.get_rate;
      lat = currentProvider.get_Lat;
      lang = currentProvider.get_Lang;
      providersInfo.add({
        "name": provname,
        "phoneNumber": provphoneNumber,
        "commercialReg": commercialReg,
        "tags": tags,
        "rate": rate,
        "logoURL": logoURL,
        "Lang": lang,
        "Lat": lat
      });

      /*Uint8List bytes =
          (await NetworkAssetBundle(Uri.parse(logoURL)).load(logoURL))
              .buffer
              .asUint8List();*/
      _mapMarkers.add(Marker(
        markerId: MarkerId("${i + 1}"),
        position: LatLng(lat, lang),
        infoWindow: InfoWindow(
          title: "$provname",
        ),
        icon: myIcon!, //fromBytes(await getImages(logoURL, 80)),
        onTap: () {
          var thisMarker = i + 1;
          setState(() {
            SelectedProv = pList[i];
            SelectedlogoURL = providersInfo[thisMarker]["logoURL"];
            Selectedprovname = providersInfo[thisMarker]["name"];
            SelectedprovphoneNumber = providersInfo[thisMarker]["phoneNumber"];
            Selectedtags = providersInfo[thisMarker]["tags"];
            SelectedRate = providersInfo[thisMarker]["rate"];
            SelectedLat = providersInfo[thisMarker]["Lat"];
            SelectedLang = providersInfo[thisMarker]["Lang"];
          });
        },
      ));
    }
  }

  void _getUserCurrentLocation() async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    consumerLan = currentPosition.latitude;
    consumerLat = currentPosition.longitude;
    setState(() {
      _userCurrentPosition =
          LatLng(currentPosition.latitude, currentPosition.longitude);
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController.complete(controller);
    });
  }

  MapType _currentMapType = MapType.normal;

  Widget _showProvider() {
    return AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        left: 0,
        right: 0,
        bottom: 0,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset.zero)
                  ]),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text("$SelectedRate"),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                    )
                  ]),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => restaurantDetail(
                                      currentProv: SelectedProv)));
                        },
                        child: ClipOval(
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(
                              SelectedlogoURL,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$Selectedprovname",
                              style: TextStyle(fontSize: 25),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              Selectedtags.toString()
                                  .replaceAll('[', '')
                                  .replaceAll(']', ''),
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            SizedBox(
                              height: 40,
                              width: 200,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await launchUrl(Uri.parse(
                                        'google.navigation:q=$SelectedLat, $SelectedLang&key=AIzaSyC02VeFbURsmFAN8jKyl_OhoqE0IMPSvQM'));
                                  },
                                  child: const Text(
                                    "Take me there!",
                                    selectionColor: Colors.white,
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFF89CDA7)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userCurrentPosition.latitude == 0 &&
              _userCurrentPosition.longitude == 0
          ? Center(
              child: SpinKitFadingCube(
                size: 85,
                color: Color(0xFF89CDA7),
              ),
            )
          : FutureBuilder(
              future: db.retrieveAllProviders(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(children: [
                    Positioned.fill(
                        child: Scaffold(
                      body: Container(
                        child: Stack(children: <Widget>[
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
                                  SelectedlogoURL = null;
                                  Selectedprovname = null;
                                  SelectedprovphoneNumber = null;
                                  Selectedtags = null;
                                });
                              }),
                          if (Selectedprovname != null)
                            _showProvider()
                          else
                            Text(
                              "",
                              style: TextStyle(fontSize: 40),
                            )
                        ]),
                      ),
                    )),
                  ]);
                }

                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: SpinKitFadingCube(
                      size: 85,
                      color: Color(0xFF89CDA7),
                    ),
                  );
                else
                  return Text("error", style: TextStyle(fontSize: 30));
              },
            ),
    );
  }
}
