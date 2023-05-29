import 'dart:async';
import 'dart:ui';
import 'package:cab_go_driver/rideRequestsPage.dart';
import 'package:cab_go_driver/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      // Change the design size as per your requirements
      builder: (BuildContext context, Widget? child) => Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/splash.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.black.withOpacity(0.1),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo-removebg.png",
                    height: 320.h,
                    width: 320.w,
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
            Positioned(
              bottom: 72.h,
              right: 20.w,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kYellow),
                ),
                onPressed: () {
                  _handleLocationPermission();
                  final User? user = _auth.currentUser;
                  if (user != null) {
                    // User is already signed in, navigate to home page
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => RideRequestsPage(
                          // userName: user.displayName,
                          // userEmail: user.email,
                          // // userPhone: user.phoneNumber,
                          // photoURL: user.photoURL,
                          // userId: user.uid,
                        ),
                      ),
                    );
                    return;
                  }
                  Navigator.of(context).pushReplacementNamed('/login');
                  // Navigator.of(context).pushReplacementNamed('/home');
                },
                child: Text('get_started'.tr, style: CustomTextStyles.boldStyle,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
