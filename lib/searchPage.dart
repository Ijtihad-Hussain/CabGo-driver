
import 'package:cab_go_driver/utils/brandDivider.dart';
import 'package:cab_go_driver/utils/constants.dart';
import 'package:cab_go_driver/utils/predictionTileWidget.dart';
import 'package:cab_go_driver/utils/providerAppData.dart';
import 'package:cab_go_driver/utils/requestHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/prediction.dart';

String? driverAddress;
String? destinationAddress;

class SearchPage extends StatefulWidget {
  // String? pickupLocation;
  // String? destinationLocation;
  SearchPage();
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var pickupController = TextEditingController();
  var destinationController = TextEditingController();
  var focusDestination = FocusNode();

  bool focused = false;

  void setFocus() {
    if (!focused) {
      FocusScope.of(context).requestFocus(focusDestination);
      focused = true;
    }
  }

  List<Prediction> destinationPredictionList = [];

  void searchPlace(String placeName) async {
    if (placeName.length > 1) {
      String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&types=geocode&key=$apiKey';
      var response = await RequestHelper.getRequest(url);

      if (response == 'failed') {
        return;
      }
      if (response['status'] == 'OK') {
        var predictionJson = response['predictions'];
        var thisList = (predictionJson as List)
            .map((e) => Prediction.fromJson(e))
            .toList();

        setState(() {
          destinationPredictionList = thisList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    setFocus();

    driverAddress = Provider.of<AppData>(context).pickupAddress?.placeName ?? '';
    pickupController.text = driverAddress!;

    destinationAddress = Provider.of<AppData>(context).destinationAddress?.placeName ?? '';
    destinationController.text = destinationAddress!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 210,
              decoration: const BoxDecoration(
                color: kLBlack,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white30,
                    blurRadius: 12,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    ),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 48, bottom: 28, right: 24, left: 24),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 5,
                    ),
                    Stack(
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back)),
                        const Center(
                          child: Text('Set Destination',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/cab.png',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: TextField(
                                controller: pickupController,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Pickup location',
                                  fillColor: Colors.white30,
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(6),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/images/destination.png',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(2.0),
                              child: TextField(
                                onChanged: (value) {
                                  searchPlace(value);
                                },
                                focusNode: focusDestination,
                                controller: destinationController,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Where to?',
                                  fillColor: Colors.white30,
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(6),
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

            (destinationPredictionList.length > 0)
                ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView.separated(
              padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        return destinationPredictionList != null
                            ? PredictionTileWidget(
                                prediction: destinationPredictionList[index],
                              )
                            : Container();
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          BrandDivider(),
                      itemCount: destinationPredictionList.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                    ),
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}
