
import 'package:cab_go_driver/utils/providerAppData.dart';
import 'package:cab_go_driver/utils/requestHelper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../models/address.dart';
import '../models/directionDetails.dart';
import '../models/user.dart';
import 'constants.dart';

class HelperMethods{

  static void getCurrentUserInfo() async {

    currentFirebaseUser = await FirebaseAuth.instance.currentUser;
    String? userid = currentFirebaseUser?.uid;

    DatabaseReference userRef = FirebaseDatabase.instance.ref().child('users/$userid');
    userRef.once().then((DatabaseEvent event){
      if (event.snapshot.value != null){
        currentUserInfo = UserModel.fromSnapshot(event);
        print('my name is ${currentUserInfo?.email}');
    }
  });
}
  static Future<dynamic> findCordinateAddress(Position position, context) async{
    String placeAddress = '';

    var connectivityResult = await Connectivity().checkConnectivity();
    if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi){
      return placeAddress;
    }
    String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey';
    var response = await RequestHelper.getRequest(url);
    if (response != 'failed'){
      placeAddress = response['results'][0]['formatted_address'];

      Address pickupAddress = Address();
      pickupAddress.longitude = position.longitude;
      pickupAddress.latitude = position.latitude;
      pickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickupAddress(pickupAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails?> getDirectionDetails(LatLng startPosition, LatLng endPosition) async {
    // String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=AIzaSyAnPZwviAk7_pC3ZTgZHA_QLe8nSsdMlIs';
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&key=$apiKey';

    var response = await RequestHelper.getRequest(url);
    if (response == 'failed' || response['routes'].isEmpty){
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.durationText = response['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue = response['routes'][0]['legs'][0]['duration']['value'];
    directionDetails.distanceText = response['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue = response['routes'][0]['legs'][0]['distance']['value'];
    directionDetails.encodedPoints = response['routes'][0]['overview_polyline']['points'];
    return directionDetails;
  }

  static int estimateFares (DirectionDetails details){
    double baseFare = 3;
    double distanceFare = (details.distanceValue! / 100) * 0.3;
    double timeFare = (details.durationValue! / 60) * 0.2;
    double totalFare = baseFare + distanceFare + timeFare;

    return totalFare.truncate();
  }

}
