
import 'package:cab_go_driver/utils/progressDialog.dart';
import 'package:cab_go_driver/utils/providerAppData.dart';
import 'package:cab_go_driver/utils/requestHelper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../models/address.dart';
import '../models/prediction.dart';
import 'constants.dart';

class PredictionTileWidget extends StatelessWidget {

  final Prediction? prediction;

  PredictionTileWidget({this.prediction});

  void getPlaceDetails(String placeID, context) async {

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Please wait...'),
    );


    String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$apiKey';
    var response = await RequestHelper.getRequest(url);

    Navigator.pop(context);

    if (response == 'failed'){
      return;
    }
    if (response['status']== 'OK'){
      Address thisPlace = Address();
      thisPlace.placeName = response['result']['name'];
      thisPlace.placeId = placeID;
      thisPlace.latitude = response ['result']['geometry']['location']['lat'];
      thisPlace.longitude = response ['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context, listen: false).updateDestinationAddress(thisPlace);
      print(thisPlace.placeName);

      Navigator.pop(context, 'getDirection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getPlaceDetails(prediction!.placeId!, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 8,),
            Row(
              children: <Widget>[
                const Icon(Icons.wrong_location_outlined, color: Colors.blueAccent,),
                const SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(prediction?.mainText ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16),),
                      const SizedBox(height: 2,),
                      Text(prediction?.secondaryText ?? '', overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12),),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
}