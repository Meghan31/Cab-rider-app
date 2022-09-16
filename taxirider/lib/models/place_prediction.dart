import 'package:flutter/material.dart';

class PlacePredictions extends ChangeNotifier {
  String? placeId;
  String? mainText;
  String? secondaryText;

  PlacePredictions(this.placeId, this.mainText, this.secondaryText);

  PlacePredictions.fromJson(Map<String, dynamic> json) {
    placeId = json['place_id'];
    mainText = json['structured_formatting']['main_text'];
    secondaryText = json['structured_formatting']['secondary_text'];
  }
}
