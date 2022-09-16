// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
// import 'dart:html';
// import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxirider/assistants/assistant_methods.dart';
import 'package:taxirider/screens/search_screen.dart';
import 'package:taxirider/widgets/divider.dart';
import 'package:taxirider/widgets/progressDialog.dart';

import '../data handler/app_data.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/mainscreen';
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? currentAddress;
  Position? currentPosition;
  String location = 'Null, Press Button';
  String address = 'search';
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  GlobalKey<ScaffoldState> scaffolfkey = GlobalKey<ScaffoldState>();

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  Future<void> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
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

  Future<void> locatePosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(
        () => currentPosition = position,
      );
      LatLng latLngPosition = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition =
          CameraPosition(target: latLngPosition, zoom: 14);
      newGoogleMapController
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      Future<void> address =
          AssistantMethods.searchCoordinateAddress(currentPosition, context);
    }).catchError((e) {
      debugPrint(e);
    });

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffolfkey,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[900],
          title: const Text(
            'Main Screen',
            style: TextStyle(fontFamily: 'Brand-Bold'),
          ),
        ),
        drawer: Container(
          color: Colors.white,
          width: 255,
          child: Drawer(
            child: ListView(
              children: [
                Container(
                  height: 165,
                  child: DrawerHeader(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/user_icon.png",
                            height: 65,
                            width: 65,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Profile Name",
                                style: TextStyle(
                                    fontFamily: "Brand-Bold", fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                DividerWidget(),
                SizedBox(
                  height: 12,
                ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text(
                    "History",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "Visit Profile",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    "About",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              polylines: polylineSet,
              markers: markerSet,
              circles: circleSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
                setState(() {
                  bottomPaddingOfMap = 300;
                });
                locatePosition();
                _getGeoLocationPosition();
              },
            ),
            // Positioned(
            //   top: 45,
            //   left: 325,
            //   child: GestureDetector(
            //     onTap: () {
            //       locatePosition();
            //     },
            //     child: const Icon(
            //       Icons.my_location_outlined,
            //       size: 40,
            //       color: Colors.white70,
            //       shadows: [
            //         Shadow(
            //           blurRadius: 10.0,
            //           color: Colors.black54,
            //           offset: Offset(5.0, 5.0),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            //Hamburger button for drawer
            Positioned(
              top: 45,
              left: 22,
              child: GestureDetector(
                onTap: () {
                  scaffolfkey.currentState?.openDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 6,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7)),
                      ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                    radius: 20,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      const Text(
                        'Hey there!!',
                        style: TextStyle(fontSize: 10),
                      ),
                      const Text(
                        'Where to!!',
                        style:
                            TextStyle(fontSize: 20, fontFamily: "Brand-Bold"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()));
                          if (res == "obtainDirection") {
                            await getPlaceDirection();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('Search Drop Off'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                overflow: TextOverflow.ellipsis,
                                Provider.of<AppData>(context).pickUpLocation !=
                                        null
                                    ? Provider.of<AppData>(context)
                                        .pickUpLocation!
                                        .placeName
                                    : "Add Home",
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                "Your living home address",
                                style: TextStyle(
                                    fontSize: 12,
                                    // fontFamily: "Brand-Bold",
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      DividerWidget(),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add Office',
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                'Your office adderess',
                                style: TextStyle(
                                    fontSize: 12,
                                    // fontFamily: "Brand-Bold",
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: Container(
            //     height: 230,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(16),
            //         topRight: Radius.circular(16),
            //       ),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black,
            //           blurRadius: 16,
            //           spreadRadius: 0.5,
            //           offset: Offset(0.7, 0.7),
            //         ),
            //       ],
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(vertical: 18),
            //       child: Column(
            //         children: [
            //           Container(
            //             width: double.infinity,
            //             color: Colors.teal[200],
            //             child: Padding(
            //               padding: const EdgeInsets.symmetric(vertical: 18.0),
            //               child: Row(
            //                 children: [
            //                   Image.asset(
            //                     'assets/images/taxi.png',
            //                     height: 70,
            //                     width: 80,
            //                   ),
            //                   SizedBox(
            //                     width: 16,
            //                   ),
            //                   Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(
            //                         'Car',
            //                         style: TextStyle(
            //                             fontSize: 18, fontFamily: "Brand-Bold"),
            //                       ),
            //                       Text(
            //                         // (tripDirectionDetails != null)
            //                         //     ? tripDirectionDetails!.distanceText
            //                         //     : '',
            //                         '10km',
            //                         style: TextStyle(
            //                             fontSize: 16, color: Colors.grey),
            //                       ),
            //                     ],
            //                   ),
            //                   Expanded(
            //                     child: Container(),
            //                   ),
            //                   // Text(
            //                   //   (tripDirectionDetails != null)
            //                   //       ? '\$${AssistantMethods.calculateFares(tripDirectionDetails!)}'
            //                   //       : '',
            //                   //   style: TextStyle(
            //                   //       fontSize: 18, fontFamily: "Brand-Bold"),
            //                   // ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //           SizedBox(
            //             height: 20,
            //           ),
            //           Padding(
            //             padding: EdgeInsets.symmetric(horizontal: 16),
            //             child: Row(
            //               children: [
            //                 Icon(
            //                   FontAwesomeIcons.moneyBillAlt,
            //                   size: 18,
            //                   color: Colors.black54,
            //                 ),
            //                 SizedBox(
            //                   width: 16,
            //                 ),
            //                 Text('Cash'),
            //                 SizedBox(
            //                   width: 6,
            //                 ),
            //                 Icon(
            //                   Icons.keyboard_arrow_down,
            //                   color: Colors.black54,
            //                   size: 16,
            //                 ),
            //               ],
            //             ),
            //           ),
            //           SizedBox(
            //             height: 20,
            //           ),
            //           Padding(
            //             padding: EdgeInsets.symmetric(horizontal: 16),
            //             child: RaisedButton(
            //               child: Padding(
            //                 padding: const EdgeInsets.all(17.0),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Text(
            //                       'Request',
            //                       style: TextStyle(
            //                           fontSize: 20,
            //                           fontWeight: FontWeight.bold,
            //                           color: Colors.white),
            //                     ),
            //                     Icon(
            //                       FontAwesomeIcons.taxi,
            //                       color: Colors.white,
            //                       size: 26,
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //               color: Colors.teal[200],
            //               onPressed: () {
            //                 print('requesting a cab');
            //               },
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        )
        //
        //
        //
        //

        );
  }

  Future<void> getPlaceDirection() async {
    var initialpos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalpos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialpos!.latitude, initialpos.longitude);
    var dropOffLatLng = LatLng(finalpos!.latitude, finalpos.longitude);

    Timer? timer = Timer(Duration(milliseconds: 2000), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog2();
        }).then((value) {
      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });

    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng, context);
    print('this re encode points');
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints!);

    if (decodedPolyLinePointsResult.isNotEmpty) {
      pLineCoordinates.clear();
      if (decodedPolyLinePointsResult.length > 50) {
        int i = 0;
        while (i < decodedPolyLinePointsResult.length) {
          pLineCoordinates.add(LatLng(decodedPolyLinePointsResult[i].latitude,
              decodedPolyLinePointsResult[i].longitude));
          i++;
        }
      } else {
        pLineCoordinates = decodedPolyLinePointsResult
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList();
      }
      polylineSet.clear();
    }

    setState(() {
      Polyline polyline = Polyline(
          color: Colors.pink,
          polylineId: PolylineId('PolylineID'),
          jointType: JointType.round,
          points: pLineCoordinates,
          width: 5,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      polylineSet.add(polyline);
    });
    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }
    newGoogleMapController
        ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow:
          InfoWindow(title: initialpos.placeName, snippet: 'My Location'),
      position: pickUpLatLng,
      markerId: MarkerId('pickUpId'),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalpos.placeName, snippet: 'Drop Off Location'),
      position: dropOffLatLng,
      markerId: MarkerId('dropOffId'),
    );

    setState(() {
      markerSet.add(pickUpLocMarker);
      markerSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
        fillColor: Colors.blueAccent,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.blue,
        circleId: CircleId('pickUpId'));

    Circle dropOffLocCircle = Circle(
        fillColor: Colors.deepPurple,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.purple,
        circleId: CircleId('dropOffId'));
    setState(() {
      circleSet.add(pickUpLocCircle);
      circleSet.add(dropOffLocCircle);
    });
  }
}
