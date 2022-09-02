import 'package:geolocator/geolocator.dart';
import 'package:taxirider/api/config_maps.dart';
import 'package:taxirider/assistants/request_assistant.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    Uri uri = Uri.parse(url);
    var response = await RequestAssistant.getRequest(uri);

    if (response != "failed") {
      placeAddress = response["results"][0]["formatted_address"];
    }
    return placeAddress;
  }
}
