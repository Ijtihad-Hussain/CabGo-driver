import 'package:cab_go_driver/tripPage.dart';
import 'package:cab_go_driver/utils/constants.dart';
import 'package:cab_go_driver/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class RideRequestsPage extends StatefulWidget {
  final String? userName;
  // final String? userEmail;
  // // final String? userPhone;
  // final String? photoURL;
  // final String? userId;

  RideRequestsPage(
      {
      //   this.userId,
      // this.userEmail,
      // this.photoURL,
      this.userName,
      // // this.userPhone
      }
      );

  @override
  State<RideRequestsPage> createState() => _RideRequestsPageState();
}

class _RideRequestsPageState extends State<RideRequestsPage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference rideRequests =
  FirebaseFirestore.instance.collection('rideRequests');

  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  String _photoUrl = '';
  String _userId = '';
  var pickAddress;
  var destAddress;
  var fair;

  @override
  void initState() {
    final User? user = _auth.currentUser;
    super.initState();
    print('user id (uid) ${user?.uid}');
    // _userName = user.displayName;
    // _userEmail = widget.userEmail!;
    // // _userPhone = widget.userPhone!;
    // _photoUrl = widget.photoURL!;
    // _userId = widget.userId!;
    _userName = user!.displayName ?? widget.userName ?? '';
    print('user name $_userName');
    _userEmail = user!.email!;
    _photoUrl = user!.photoURL ?? 'https://cdn.pixabay.com/photo/2017/11/10/05/48/user-2935527_1280.png';
    _userId = user!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLBlack,
        title: Center(child: Text('rideReq'.tr)),
      ),
      drawer: drawer(
        userName: _userName,
        photoUrl: _photoUrl,
        userId: _userId,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: rideRequests.where('status', isEqualTo: 'pending').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('noRideReq'.tr));
          }

          // Play sound when new ride request is received
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.data!.docs.length > 0) {
            FlutterRingtonePlayer.play(
              android: AndroidSounds.notification,
              ios: IosSounds.glass,
              looping: false,
              volume: 1.0,
              asAlarm: false,
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedDocs =
              snapshot.data!.docs
                  .cast<QueryDocumentSnapshot<Map<String, dynamic>>>()
                  .toList()
                ..sort((b, a) => a
                    .data()['createdAt']
                    ?.compareTo(b.data()['createdAt']));

              Map<String, dynamic> rideRequest =
              sortedDocs[index].data() as Map<String, dynamic>;

              pickAddress = rideRequest['pickupAddress'];
              destAddress = rideRequest['destinationAddress'];
              fair = rideRequest['offered fair'];

              return ListTile(
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 16.sp),
                    children: <InlineSpan>[
                      TextSpan(
                        text: "pickup: ",
                        style: TextStyle(color: kYellow),
                      ),
                      TextSpan(
                        text: '$pickAddress',
                        style: TextStyle(color: Colors.indigo),
                      ),
                    ],
                  ),
                ),
                // Text("pickup: $pickAddress"),
                subtitle: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12.sp),
                    children: <InlineSpan>[
                      TextSpan(
                        text: "To: ",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      TextSpan(
                        text: '$destAddress ',
                        style: TextStyle(color: kBlack),
                      ),
                      TextSpan(
                        text: '\nFare:  ',
                        style: TextStyle(color: Colors.green[900]),
                      ),
                      TextSpan(
                        text: 'CHF ',
                        style: TextStyle(color: kBlack),
                      ),
                      TextSpan(
                        text: '$fair',
                        style: TextStyle(color: kBlack),
                      ),
                    ],
                  ),
                ),
                // Text("To: $destAddress  Fare:  $fair"),
                trailing: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(kYellow)),
                  onPressed: () async {
                    final rideRequestRef =
                    rideRequests.doc(snapshot.data!.docs[index].id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TripPage(
                          driverName: _userName,
                          driverPhone: _userPhone,
                          riderName: rideRequest['name'] ?? '',
                          riderPhone: rideRequest['phoneNumber'] ?? '',
                          pickupAddress: rideRequest['pickupAddress'] ?? '',
                          destinationAddress:
                          rideRequest['destinationAddress'] ?? '',
                          fare: rideRequest['offered fair'] ?? '',
                          requestId: rideRequest['requestId'] ?? '',
                        ),
                      ),
                    );
                    await rideRequestRef.update({'status': 'accepted', 'driverName': _userName, 'driverId': _userId});
                  },
                  child: Text('Accept'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// class _RideRequestsPageState extends State<RideRequestsPage> {
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   final CollectionReference rideRequests =
//       FirebaseFirestore.instance.collection('rideRequests');
//
//   String _userName = '';
//   String _userEmail = '';
//   String _userPhone = '';
//   String _photoUrl = '';
//   String _userId = '';
//   var pickAddress;
//   var destAddress;
//   var fair;
//
//   @override
//   void initState() {
//     final User? user = _auth.currentUser;
//     super.initState();
//     print('user id (uid) ${user?.uid}');
//     // _userName = user.displayName;
//     // _userEmail = widget.userEmail!;
//     // // _userPhone = widget.userPhone!;
//     // _photoUrl = widget.photoURL!;
//     // _userId = widget.userId!;
//     _userName = user!.displayName!;
//     _userEmail = user!.email!;
//     _photoUrl = user!.photoURL!;
//     _userId = user!.uid;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kLBlack,
//         title: Center(child: Text('rideReq'.tr)),
//       ),
//       drawer: drawer(
//         userName: _userName,
//         photoUrl: _photoUrl,
//         userId: _userId,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: rideRequests.where('status', isEqualTo: 'pending').snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('noRideReq'.tr));
//           }
//
//           // Play sound when new ride request is received
//           if (snapshot.connectionState == ConnectionState.active &&
//               snapshot.data!.docs.length > 0) {
//             FlutterRingtonePlayer.play(
//               android: AndroidSounds.notification,
//               ios: IosSounds.glass,
//               looping: false,
//               volume: 1.0,
//               asAlarm: false,
//             );
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (BuildContext context, int index) {
//               List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedDocs = snapshot.data!.docs.cast<QueryDocumentSnapshot<Map<String, dynamic>>>().toList()..sort((b, a) => a.data()['createdAt']?.compareTo(b.data()['createdAt']));
//
//               Map<String, dynamic> rideRequest = sortedDocs[index].data() as Map<String, dynamic>;
//
//               pickAddress = rideRequest['pickupAddress'];
//               destAddress = rideRequest['destinationAddress'];
//               fair = rideRequest['offered fair'];
//
//               return ListTile(
//                 title: RichText(
//                   text: TextSpan(
//                     style: TextStyle(fontSize: 16.sp),
//                     children: <InlineSpan>[
//                       TextSpan(
//                         text: "pickup: ",
//                         style: TextStyle(color: kYellow),
//                       ),
//                       TextSpan(
//                         text: '$pickAddress',
//                         style: TextStyle(color: Colors.indigo),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Text("pickup: $pickAddress"),
//                 subtitle: RichText(
//                   text: TextSpan(
//                     style: TextStyle(fontSize: 12.sp),
//                     children: <InlineSpan>[
//                       TextSpan(
//                         text: "To: ",
//                         style: TextStyle(color: Colors.redAccent),
//                       ),
//                       TextSpan(
//                         text: '$destAddress ',
//                         style: TextStyle(color: kBlack),
//                       ),
//                       TextSpan(
//                         text: '\nFare:  ',
//                         style: TextStyle(color: Colors.green[900]),
//                       ),
//                       TextSpan(
//                         text: 'CHF ',
//                         style: TextStyle(color: kBlack),
//                       ),
//                       TextSpan(
//                         text: '$fair',
//                         style: TextStyle(color: kBlack),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Text("To: $destAddress  Fare:  $fair"),
//                 trailing: ElevatedButton(
//                   style: ButtonStyle(
//                       backgroundColor: MaterialStateProperty.all(kYellow)),
//                   onPressed: () async {
//                     final rideRequestRef = rideRequests.doc(snapshot.data!.docs[index].id);
//                     await rideRequestRef.update({'status': 'accepted'});
//                     await rideRequestRef.update({'driverName': _userName, 'driverId': _userId});
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => TripPage(
//                           driverName: _userName,
//                           driverPhone: _userPhone,
//                           riderName: rideRequest['name'] ?? '',
//                           riderPhone: rideRequest['phoneNumber'] ?? '',
//                           pickupAddress: rideRequest['pickupAddress'] ?? '',
//                           destinationAddress: rideRequest['destinationAddress'] ?? '',
//                           fare: rideRequest['offered fair'] ?? '',
//                           requestId: rideRequest['requestId'] ?? '',
//                         ),
//                       ),
//                     );
//                   },
//                   child: Text('Accept'),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
