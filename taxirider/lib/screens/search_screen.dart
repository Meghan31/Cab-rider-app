import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:taxirider/data%20handler/app_data.dart';
import 'package:taxirider/models/place_prediction.dart';

import '../api/config_maps.dart';
import '../assistants/request_assistant.dart';
import '../models/address.dart';
import '../widgets/divider.dart';
import '../widgets/progressDialog.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickupTextEditingController = TextEditingController();
  TextEditingController dropoffTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    String pickupAddress =
        Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    pickupTextEditingController.text = pickupAddress;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 6,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.75)),
                ],
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(left: 25, top: 50, right: 25, bottom: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Set Drop Off',
                            style: TextStyle(
                                fontSize: 18, fontFamily: "Brand-Bold"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/pickicon.png',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: TextField(
                                controller: pickupTextEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Pickup Location',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11, top: 8, bottom: 8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/desticon.png',
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: TextField(
                                onChanged: (value) {
                                  findPlace(value);
                                },
                                controller: dropoffTextEditingController,
                                decoration: InputDecoration(
                                  hintText: 'Where to?',
                                  fillColor: Colors.grey[200],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11, top: 8, bottom: 8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            (placePredictionList.length > 0)
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListView.separated(
                      padding: EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return PredictionTile(
                          placePredictions: placePredictionList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          DividerWidget(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<List> findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&radius=5000&types=geocode&key=$mapKey&components=country:in";
      Uri uri1 = Uri.parse(autoCompleteUrl);
      var res = await RequestAssistant.getRequest(uri1);
      res = jsonDecode(res);
      var predictions = res["predictions"];

      var placesList = (predictions as List)
          .map((e) => PlacePredictions.fromJson(e))
          .toList();
      setState(() {
        placePredictionList = placesList;
      });
      return placesList;
    }
    return [];
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;
  PredictionTile({Key? key, required this.placePredictions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        getPlaceAddressDetails(placePredictions.placeId, context);
      },
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.add_location),
                SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        placePredictions.mainText ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(
                        placePredictions.secondaryText ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String? placeId, context) async {
    showDialog(
        context: context, builder: (BuildContext context) => ProgressDialog());
    String placeDetailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?&place_id=$placeId&key=$mapKey';
    Uri uri = Uri.parse(placeDetailsUrl);
    var res = await RequestAssistant.getRequest(uri);
    Navigator.pop(context);
    res = jsonDecode(res);
    if (res["status"] == "OK") {
      Address address = Address(
          res["result"]["name"],
          res["result"]["place_id"],
          res["result"]["geometry"]["location"]["lat"],
          res["result"]["geometry"]["location"]["lng"]);

      Provider.of<AppData>(context, listen: false)
          .updateDropOffLocationAddress(address);
      print("This is drop off location:: ");
      print(address.placeName);
      Navigator.pop(context, 'obtainDirection');
    }
  }
}
