import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taxirider/models/nearby_available_drivers.dart';

import '../api/config_maps.dart';
import 'assistant_methods.dart';

class GeoFireAssistant {
  static List<AssistantMethods> nearbyAssistantList = [];
  static List<NearbyAvailableDrivers> nearbyAvailableDriversList = [];

  static void removeDriverFromList(String key) {
    int index =
        nearbyAvailableDriversList.indexWhere((element) => element.key == key);
    nearbyAvailableDriversList.removeAt(index);
  }

  static void updateDriverNearbyLocation(NearbyAvailableDrivers driver) {
    int index = nearbyAvailableDriversList
        .indexWhere((element) => element.key == driver.key);
    nearbyAvailableDriversList[index].latitude = driver.latitude;
    nearbyAvailableDriversList[index].longitude = driver.longitude;
  }

  // static Future<void> searchNearbyAssistant(Position currentPosition) async {
  //   // ignore: deprecated_member_use
  //   List<AssistantMethods> availableAssistant = [];
  //   // ignore: deprecated_member_use
  //   DatabaseReference assistantRef =
  //       FirebaseDatabase.instance.reference().child('assistants');
  //   // ignore: deprecated_member_use
  //   GeoFireAssistant geoFireAssistant = GeoFireAssistant(assistantRef);
  //   GeoFirePoint center = geoFireAssistant.point(
  //       latitude: currentPosition.latitude,
  //       longitude: currentPosition.longitude);
  //   // ignore: deprecated_member_use
  //   assistantRef.child(firebaseUser!.uid).once().then((event) {
  //     final dataSnapshot = event.snapshot;
  //     if (dataSnapshot.value != null) {
  //       // ignore: deprecated_member_use
  //       var values = dataSnapshot.value;
  //       values!.forEach((key, values) {
  //         double distanceInMeters = geoFireAssistant.distance(
  //             location1: center,
  //             location2: geoFireAssistant.point(
  //                 latitude: values['location']['latitude'],
  //                 longitude: values['location']['longitude']));
  //         if (distanceInMeters <= 10000) {
  //           availableAssistant.add(AssistantMethods.fromSnapshot(snapshot));
  //         }
  //       });
  //     }
  //   });
  //   nearbyAssistantList = availableAssistant;
  // }
}
