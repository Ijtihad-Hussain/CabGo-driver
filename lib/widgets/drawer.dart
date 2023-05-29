import 'package:cab_go_driver/ratings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/brandDivider.dart';
import '../utils/constants.dart';
import 'package:cab_go_driver/mainPage.dart';

class drawer extends StatefulWidget {
  final String? photoUrl;
  final String? userId;

  drawer({
    super.key,
    required String userName,
    this.photoUrl,
    this.userId,
  }) : _userName = userName;

  final String _userName;

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  String driverStatus = 'online';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      color: Colors.white,
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            Container(
              height: 150.h,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.photoUrl!),
                          radius: 25.r,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget._userName,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // ListTile(
                    //     leading: driverStatus == 'online'
                    //         ? Icon(Icons.toggle_on)
                    //         : Icon(Icons.toggle_off),
                    //     title: Text(
                    //       driverStatus == 'online' ? 'Online' : 'Offline',
                    //       style: kDrawerItemStyle,
                    //     ),
                    //     onTap: () async {
                    //       try {
                    //         // final userId = FirebaseAuth.instance.currentUser!.uid;
                    //         // print('User id is$userId');
                    //         final driverRef = FirebaseFirestore.instance
                    //             .collection('drivers')
                    //             .doc(widget.userId);
                    //         if (driverStatus == 'online') {
                    //           // Update the status to 'offline'
                    //           await driverRef.update({'status': 'offline'});
                    //           // Set the new status in the app's state
                    //           setState(() {
                    //             driverStatus = 'offline';
                    //           });
                    //         } else {
                    //           // Update the status to 'online'
                    //           await driverRef.update({'status': 'online'});
                    //           // Set the new status in the app's state
                    //           setState(() {
                    //             driverStatus = 'online';
                    //           });
                    //         }
                    //         print('success');
                    //       } catch (e) {
                    //         print('errorrrrrrrrrrrrr $e');
                    //       }
                    //     }),
                  ],
                ),
              ),
            ),
            BrandDivider(),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.monetization_on),
              title: const Text(
                'Earnings',
                style: kDrawerItemStyle,
              ),
              onTap: () async {
                Navigator.pushReplacementNamed(context, '/earnings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.generating_tokens_sharp),
              title: const Text(
                'Ratings',
                style: kDrawerItemStyle,
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewRatingsScreen(driverId: widget.userId!)),
                );
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.help_center),
            //   title: const Text(
            //     'Support',
            //     style: kDrawerItemStyle,
            //   ),
            //   onTap: () async {
            //     // Navigator.pushReplacementNamed(context, '/support');
            //   },
            // ),
            // ListTile(
            //   leading: const Icon(Icons.access_time_filled),
            //   title: const Text(
            //     'About',
            //     style: kDrawerItemStyle,
            //   ),
            //   onTap: () async {
            //     // Navigator.pushReplacementNamed(context, '/about');
            //   },
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                'Logout',
                style: kDrawerItemStyle.copyWith(
                  color: Colors.red,
                ),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // Navigate to Login Screen
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
