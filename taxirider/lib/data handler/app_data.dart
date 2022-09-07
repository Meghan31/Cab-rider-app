import 'package:flutter/cupertino.dart';
import 'package:taxirider/models/address.dart';

class AppData extends ChangeNotifier {
  Address? pickUpLocation;
  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }
}
