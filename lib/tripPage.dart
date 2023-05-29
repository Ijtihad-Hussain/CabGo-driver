import 'package:cab_go_driver/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripPage extends StatelessWidget {
  final String? driverName;
  final String? driverPhone;
  final String? riderName;
  final String? riderPhone;
  final String? pickupAddress;
  final String? destinationAddress;
  final double? fare;
  final String? requestId;

  TripPage({
    this.driverName,
    this.driverPhone,
    this.riderName,
    this.riderPhone,
    this.pickupAddress,
    this.destinationAddress,
    this.fare,
    this.requestId,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final CollectionReference rideRequests =
    FirebaseFirestore.instance.collection('rideRequests');
    final DocumentReference rideRequestRef = rideRequests.doc(requestId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLBlack,
        title: Text('tripDetails'.tr),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: rideRequestRef.snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('noRideReq'.tr));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rider: $riderName',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Phone: $riderPhone',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'pickA'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$pickupAddress',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'destA'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$destinationAddress',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'fair'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$fare',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(kYellow)),
                      onPressed: () async {
                        await rideRequestRef.update({'status': 'completed'});

                        // Create a new document in Firestore
                        await FirebaseFirestore.instance.collection('completedTrips').add({
                        'driverName': driverName,// Add driver name here,
                        'driverPhone': driverPhone,// Add driver name here,
                        'riderName': riderName,// Add driver name here,
                        'riderPhone': riderPhone,// Add driver name here,
                        'fare': fare, // Add fare here,
                        'pickupAddress': pickupAddress, // Add pickup address here,
                        'destinationAddress': destinationAddress, // Add destination address here,
                        });

                        Navigator.pop(context);
                      },
                      child: Text('complete'.tr),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(kYellow)),
                      onPressed: () async {
                        await rideRequestRef.update({'status': 'cancelled'});
                        Navigator.pop(context);
                      },
                      child: Text('cancel'.tr),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// class TripPage extends StatefulWidget {
//   final String? driverName;
//   final String? driverPhone;
//   final String? riderName;
//   final String? riderPhone;
//   final String? pickupAddress;
//   final String? destinationAddress;
//   final double? fare;
//   final String? requestId;
//
//   TripPage({
//     this.driverName,
//     this.driverPhone,
//     this.riderName,
//     this.riderPhone,
//     this.pickupAddress,
//     this.destinationAddress,
//     this.fare,
//     this.requestId,
//   });
//
//   @override
//   State<TripPage> createState() => _TripPageState();
// }
//
// class _TripPageState extends State<TripPage> {
//
//   @override
//   Widget build(BuildContext context) {
//     final CollectionReference rideRequests =
//         FirebaseFirestore.instance.collection('rideRequests');
//     final DocumentReference rideRequestRef = rideRequests.doc(widget.requestId);
//
//     // Create markers for pickup and destination addresses
//     Set<Marker> markers = {};
//     if (widget.pickupAddress != null) {
//       markers.add(Marker(
//         markerId: MarkerId('pickup'),
//         position: LatLng(37.4219983, -122.084),
//         infoWindow: InfoWindow(
//           title: 'Pickup Location',
//           snippet: widget.pickupAddress,
//         ),
//       ));
//     }
//     if (widget.destinationAddress != null) {
//       markers.add(Marker(
//         markerId: MarkerId('destination'),
//         position: LatLng(37.42796133580664, -122.085749655962),
//         infoWindow: InfoWindow(
//           title: 'Destination Location',
//           snippet: widget.destinationAddress,
//         ),
//       ));
//     }
//
//     // Set the initial camera position for the Google Map
//     CameraPosition cameraPosition = CameraPosition(
//       target: LatLng(37.4219983, -122.084),
//       zoom: 14.0,
//     );
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kLBlack,
//         title: Text('tripDetails'.tr),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: rideRequestRef.snapshots(),
//         builder:
//             (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (!snapshot.hasData) {
//             return Center(child: Text('noRideReq'.tr));
//           }
//
//           Map<String, dynamic> rideRequest =
//               snapshot.data!.data() as Map<String, dynamic>;
//
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: GoogleMap(
//                   initialCameraPosition: cameraPosition,
//                   markers: markers,
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: false,
//                   rotateGesturesEnabled: false,
//                   scrollGesturesEnabled: false,
//                   tiltGesturesEnabled: false,
//                   zoomControlsEnabled: false,
//                   zoomGesturesEnabled: false,
//                   onMapCreated: (GoogleMapController controller) {},
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Rider: ${widget.riderName}',
//                       style: TextStyle(
//                         fontSize: 20.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8.h),
//                     Text(
//                       'Phone: ${widget.riderPhone}',
//                       style: TextStyle(fontSize: 16.sp),
//                     ),
//                     SizedBox(height: 16.h),
//                     Text(
//                       'pickA'.tr,
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       '${widget.pickupAddress}',
//                       style: TextStyle(fontSize: 16.sp),
//                     ),
//                     SizedBox(height: 16.h),
//                     Text(
//                       'destA'.tr,
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       '${widget.destinationAddress}',
//                       style: TextStyle(fontSize: 16.sp),
//                     ),
//                     SizedBox(height: 16.h),
//                     Text(
//                       'fair'.tr,
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       '${widget.fare}',
//                       style: TextStyle(fontSize: 16.sp),
//                     ),
//                     SizedBox(height: 16.h),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
