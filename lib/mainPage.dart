// import 'dart:async';
// import 'dart:io';
// import 'package:cab_go_driver/models/address.dart';
// import 'package:cab_go_driver/rideRequestsPage.dart';
// import 'package:cab_go_driver/searchPage.dart';
// import 'package:cab_go_driver/utils/constants.dart';
// import 'package:cab_go_driver/utils/helperMethods.dart';
// import 'package:cab_go_driver/utils/progressDialog.dart';
// import 'package:cab_go_driver/utils/providerAppData.dart';
// import 'package:cab_go_driver/widgets/drawer.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_geofire/flutter_geofire.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart' as geo;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'models/directionDetails.dart';
// import 'models/driver.dart';
//
// class HomeScreen extends StatefulWidget {
//   final String? userName;
//   final String? userEmail;
//   final String? userPhone;
//   final String? photoURL;
//   final String? userId;
//   final String? pickAddress;
//   final String? destAddress;
//   final String? fairOffered;
//
//   const HomeScreen({
//     Key? key,
//     required this.userName,
//     this.userEmail,
//     this.userPhone,
//     this.photoURL,
//     this.userId,
//     this.pickAddress,
//     this.destAddress,
//     this.fairOffered
//   }) : super(key: key);
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
//   GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//
//   double searchSheetHeight = (Platform.isIOS) ? 122 : 120;
//   double rideDetailsSheetHeight = 0; // (Platform.isIOS) ? 122 : 120;
//   double requestingSheetHeight = 0;
//
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//   late GoogleMapController mapController;
//   double mapBottomPadding = 0;
//
//   List<LatLng> polylineCoordinates = [];
//   Set<Polyline> _polylines = {};
//   Set<Marker> _Markers = {};
//   Set<Circle> _Circles = {};
//
//   var geoLocator = geo.Geolocator();
//   geo.Position? currentPosition;
//   DirectionDetails? tripDirectionDetails;
//
//   DatabaseReference? rideRef;
//
//   CollectionReference<Map<String, dynamic>>? rideRequests;
//
//   DocumentReference<Map<String, dynamic>>? rideRequestRef;
//
//   DocumentReference<Object?>? rideRequestDocRef;
//
//   var driverLocation;
//   var latitude;
//   var longitude;
//
//   void setUpPositionLocator() async {
//     geo.Position position = await geo.Geolocator.getCurrentPosition(
//         desiredAccuracy: geo.LocationAccuracy.bestForNavigation);
//     currentPosition = position;
//
//     LatLng pos = LatLng(position.latitude, position.longitude);
//     CameraPosition cp = CameraPosition(target: pos, zoom: 14);
//     mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
//
//     driverLocation =
//         await HelperMethods.findCordinateAddress(position, context);
//     print('geoAddress$driverLocation');
//   }
//
//   // Create a new document in Firestore for the driver
//   void driverDocument() async {
//     geo.Position position = await geo.Geolocator.getCurrentPosition(
//         desiredAccuracy: geo.LocationAccuracy.bestForNavigation);
//     currentPosition = position;
//
//     latitude = await currentPosition?.latitude;
//     longitude = await currentPosition?.longitude;
//
//     LatLng pos = LatLng(position.latitude, position.longitude);
//     CameraPosition cp = CameraPosition(target: pos, zoom: 14);
//     mapController.animateCamera(CameraUpdate.newCameraPosition(cp));
//
//     driverLocation =
//         await HelperMethods.findCordinateAddress(position, context);
//     print('driver Location$driverLocation');
//
//     try {
//       await FirebaseFirestore.instance.collection('drivers').doc(_userId).set({
//         'userId': _userId ?? 'userID',
//         'name': _userName,
//         'phone': _userPhone,
//         'email': _userEmail,
//         'photoURL': _photoUrl,
//         'location': driverLocation,
//         'status': 'online',
//         'latitude': latitude,
//         'longitude': longitude,
//       });
//       print('driver document created');
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   String _userName = '';
//   String _userEmail = '';
//   String _userPhone = '';
//   String _photoUrl = '';
//   String _userId = '';
//   String _pickAddress = '';
//   String _destAddress = '';
//   String _fairOffered = '';
//
//   final TextEditingController _priceController = TextEditingController();
//   String? offerPrice;
//
//   @override
//   void dispose() {
//     _priceController.removeListener(_updatePrice);
//     _priceController.dispose();
//     super.dispose();
//   }
//
//   void _updatePrice() {
//     setState(() {
//       offerPrice = _priceController.text;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     HelperMethods.getCurrentUserInfo();
//     _userName = widget.userName!;
//     _userEmail = widget.userEmail!;
//     _userPhone = widget.userPhone!;
//     _photoUrl = widget.photoURL!;
//     _userId = widget.userId!;
//     _pickAddress = widget.pickAddress!;
//     _destAddress = widget.destAddress!;
//     _fairOffered = widget.fairOffered!;
//     _priceController.addListener(_updatePrice);
//     offerPrice;
//     latitude;
//     longitude;
//     driverAddress;
//     driverLocation;
//     destinationAddress;
//     currentPosition;
//     driverDocument();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, String>? args =
//         ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
//
//     final String pickupLocation = args?['pickup'] ?? 'empty';
//     final String destinationLocation = args?['destination'] ?? 'empty';
//
//     print('Pick address $_pickAddress and destination address $_destAddress and offered fair $_fairOffered');
//
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: kLBlack,
//       appBar: AppBar(
//         title: TextButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => RideRequestsPage(
//                 // userId: _userId,
//                 // userEmail: _userEmail,
//                 // userName: _userName,
//                 // // userPhone: _userPhone,
//                 // photoURL: _photoUrl,
//               )),
//             );
//           },
//           child: Center(child: Text('Ride Requests')),
//           style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all(kYellow)),
//           ),
//         backgroundColor: Colors.transparent,
//         ),
//       drawer: drawer(userName: _userName, photoUrl: _photoUrl, userId: _userId),
//       body: Stack(
//         children: [
//           GoogleMap(
//             padding: EdgeInsets.only(bottom: mapBottomPadding),
//             mapType: MapType.normal,
//             myLocationButtonEnabled: true,
//             myLocationEnabled: true,
//             zoomControlsEnabled: true,
//             zoomGesturesEnabled: true,
//             polylines: _polylines,
//             markers: _Markers,
//             circles: _Circles,
//             initialCameraPosition: googlePlex,
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//               mapController = controller;
//
//               setState(() {
//                 mapBottomPadding = (Platform.isIOS) ? 128 : 126;
//               });
//               setUpPositionLocator();
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void goOnline() {
//     Geofire.initialize('drivers');
//     Geofire.setLocation(currentFirebaseUser!.uid, currentPosition!.latitude,
//         currentPosition!.longitude);
//     tripRequestRef = FirebaseDatabase.instance
//         .ref()
//         .child('drivers/${currentFirebaseUser!.uid!}/newtrip');
//     tripRequestRef?.set('available');
//
//     tripRequestRef?.onValue.listen((event) {});
//   }
//
//   deleteRequest() {
//     rideRequestDocRef?.delete();
//     print('request deleted');
//   }
//
//
//   Future<void> getDirection() async {
//     var pickup = _pickAddress as Address;
//     var destination = _destAddress as Address;
//     // var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
//     // var destination = Provider.of<AppData>(context, listen: false).destinationAddress;
//
//     var pickLatLng = LatLng(pickup!.latitude!, pickup.longitude!);
//     var destinationLatLng =
//     LatLng(destination!.latitude!, destination.longitude!);
//
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) =>
//           ProgressDialog(status: 'Wait...'),
//     );
//     var thisDetails =
//     await HelperMethods.getDirectionDetails(pickLatLng, destinationLatLng);
//
//     setState(() {
//       tripDirectionDetails = thisDetails;
//     });
//
//     Navigator.pop(context);
//
//     PolylinePoints polylinePoints = PolylinePoints();
//     List<PointLatLng> results =
//     polylinePoints.decodePolyline(thisDetails!.encodedPoints!);
//
//     polylineCoordinates.clear();
//     if (results.isNotEmpty) {
//       results.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }
//
//     _polylines.clear();
//
//     setState(() {
//       Polyline polyline = Polyline(
//         polylineId: PolylineId('polyid'),
//         color: Color.fromARGB(255, 95, 109, 237),
//         points: polylineCoordinates,
//         jointType: JointType.round,
//         width: 4,
//         startCap: Cap.roundCap,
//         endCap: Cap.roundCap,
//         geodesic: true,
//       );
//       _polylines.add(polyline);
//     });
//
//     // make polyline to fit into the map
//
//     LatLngBounds bounds;
//     if (pickLatLng.latitude > destinationLatLng.latitude &&
//         pickLatLng.longitude > destinationLatLng.longitude) {
//       bounds =
//           LatLngBounds(southwest: destinationLatLng, northeast: pickLatLng);
//     } else if (pickLatLng.longitude > destinationLatLng.longitude) {
//       bounds = LatLngBounds(
//         southwest:
//         LatLng(destinationLatLng.latitude, destinationLatLng.longitude),
//         northeast: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
//       );
//     } else if (pickLatLng.latitude > destinationLatLng.latitude) {
//       bounds = LatLngBounds(
//         southwest: LatLng(destinationLatLng.latitude, pickLatLng.longitude),
//         northeast: LatLng(pickLatLng.latitude, destinationLatLng.longitude),
//       );
//     } else {
//       bounds =
//           LatLngBounds(southwest: pickLatLng, northeast: destinationLatLng);
//     }
//     mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
//
//     Marker pickupMarker = Marker(
//       markerId: const MarkerId('pickup'),
//       position: pickLatLng,
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//       infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
//     );
//
//     Marker destinationMarker = Marker(
//       markerId: const MarkerId('destination'),
//       position: destinationLatLng,
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//       infoWindow:
//       InfoWindow(title: destination.placeName, snippet: 'Destination'),
//     );
//
//     setState(() {
//       _Markers.add(pickupMarker);
//       _Markers.add(destinationMarker);
//     });
//
//     Circle pickupCircle = Circle(
//       circleId: const CircleId('pickup'),
//       strokeColor: Colors.green,
//       strokeWidth: 3,
//       radius: 12,
//       center: pickLatLng,
//       fillColor: Colors.greenAccent,
//     );
//
//     Circle destinationCircle = Circle(
//       circleId: const CircleId('destination'),
//       strokeColor: Colors.purple,
//       strokeWidth: 3,
//       radius: 12,
//       center: destinationLatLng,
//       fillColor: Colors.purpleAccent,
//     );
//
//     setState(() {
//       _Circles.add(pickupCircle);
//       _Circles.add(destinationCircle);
//     });
//   }
//
//
//   Future<void> updateRideRequestStatus(String status) async {
//     try {
//       await rideRequestDocRef?.update({'status': status});
//       print('Ride request status updated successfully!');
//     } catch (e) {
//       print('Error updating ride request status: $e');
//     }
//   }
// }
//
