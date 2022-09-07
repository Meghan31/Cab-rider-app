import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:taxirider/api/config_maps.dart';
import 'package:taxirider/assistants/request_assistant.dart';
import 'package:taxirider/data%20handler/app_data.dart';
import 'package:taxirider/models/address.dart';

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
    st1 = response["results"][0]["address_components"][3]["long_name"];
    st2 = response["results"][0]["address_components"][4]["long_name"];
    st3 = response["results"][0]["address_components"][5]["long_name"];
    st4 = response["results"][0]["address_components"][6]["long_name"];
    placeAddress = "$st1, $st2, $st3, $st4";
    print(placeAddress);
    Address userPickupAddress = Address(
      placeAddress,
      "",
      "",
      position!.latitude,
      position.longitude,
    );
    Provider.of<AppData>(context, listen: false)
        .updatePickUpLocationAddress(userPickupAddress);

    return placeAddress;
  }
}
