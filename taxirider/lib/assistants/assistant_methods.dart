import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxirider/api/config_maps.dart';
import 'package:taxirider/assistants/request_assistant.dart';
import 'package:taxirider/data%20handler/app_data.dart';
import 'package:taxirider/models/address.dart';

import '../models/direction_details.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position? position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position?.latitude},${position?.longitude}&key=$mapKey";
    Uri uri = Uri.parse(url);
    var response = await RequestAssistant.getRequest(uri);

    // placeAddress = response["results"][0]["formatted_address"];
    response = json.decode(response);
    st1 = response["results"][0]["address_components"][1]["long_name"] +
        ", " +
        response["results"][0]["address_components"][2]["long_name"];
    st2 = response["results"][0]["address_components"][4]["long_name"];
    st3 = response["results"][0]["address_components"][5]["long_name"];
    st4 = response["results"][0]["address_components"][6]["long_name"];
    placeAddress = "$st1, $st2, $st3, $st4";
    Address userPickupAddress = Address(
      placeAddress,
      "",
      position!.latitude,
      position.longitude,
    );
    Provider.of<AppData>(context, listen: false)
        .updatePickUpLocationAddress(userPickupAddress);

    return placeAddress;
  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition, context) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";
    Uri uri = Uri.parse(directionUrl);
    var response = await RequestAssistant.getRequest(uri);

    response = json.decode(response);

    var directionDetails = DirectionDetails();

    directionDetails.encodedPoints =
        response["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        response["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        response["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText =
        response["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        response["routes"][0]["legs"][0]["duration"]["value"];

    // Provider.of<AppData>(context, listen: false)
    //     .updateTripDirectionDetails(directionDetails);

    return directionDetails;
  }

  static int calculateFares(DirectionDetails directionDetails) {
    //in terms USD
    double timeTraveledFare = (directionDetails.durationValue! / 60) * 0.20;
    double distanceTraveledFare =
        (directionDetails.distanceValue! / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    //Local currency
    //1$ = 77.5 INR
    double totalLocalAmount = totalFareAmount * 77.5;

    return totalLocalAmount.truncate();
  }
}
