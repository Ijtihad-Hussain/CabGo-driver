import 'dart:io';
import 'package:cab_go_driver/emailSignIn.dart';
import 'package:cab_go_driver/phoneNumberDialog.dart';
import 'package:cab_go_driver/rideRequestsPage.dart';
import 'package:cab_go_driver/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'mainPage.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
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
    String? phoneNumber = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return PhoneNumberDialog();
      },
    );
    // final String? phoneNumber = await _getPhoneNumber();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // user canceled the sign-in flow
        return;
      }

      // Get the Google authentication credentials
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase using the Google credentials
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = userCredential.user!;

      final String userId = googleUser.id;

      final String? name = googleUser.displayName;
      final String? email = googleUser.email;
      final String? photoURL = googleUser.photoUrl!;

      // Create a new document in Firestore for the driver
      await FirebaseFirestore.instance.collection('drivers').doc(userId).set({
        'userId': user.uid,
        'name': googleUser.displayName,
        'phone': phoneNumber,
        'email': googleUser.email,
        'photoURL': googleUser.photoUrl,
      });

// Pass the user's name, email, and phone number to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => RideRequestsPage(
              // userName: name,
              // userEmail: email,
              // // userPhone: phoneNumber,
              // photoURL: photoURL,
              // userId: userId,
              ),
        ),
      );
    } catch (e) {
// handle sign-in errors
      print('Error signing in with Google: $e');
    }
  }

  Future<String?> _getPhoneNumber() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String? phoneNumber;
        return AlertDialog(
          title: Text('Enter Phone Number'),
          content: TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(hintText: 'Enter your phone number'),
            onChanged: (value) {
              phoneNumber = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(phoneNumber);
              },
            ),
          ],
        );
      },
    );
  }

  Future<UserCredential?> signInWithFacebook() async {
    // Sign in with Facebook
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        // User canceled the sign-in flow or an error occurred
        return null;
      }

      // Authenticate with Firebase
      final AuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Retrieve user data
      final User user = userCredential.user!;
      final String name = user.displayName!;
      final String email = user.email!;
      final String photoURL = user.photoURL!;
      final String? phoneNumber = await _getPhoneNumber();
      print('mobile number: $phoneNumber');

      print(name);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => RideRequestsPage(userName: '',),
        ),
      );

      // Use the user data to send a ride request to the driver
      // sendRideRequest(displayName, email, photoURL);

      return userCredential;
    } catch (e) {
      // handle sign-in errors
      print('Error signing in with Google: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print('${currentFirebaseUser?.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDBlack,
      body: Padding(
        padding: EdgeInsets.all(60.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                "assets/images/cab.png",
                height: 60.h,
                width: 60.w,
              ),
              Image.asset(
                "assets/images/logonew.png",
                height: 320.h,
                width: 320.w,
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kYellow),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/mail.png",
                        height: 25.h,
                        width: 25.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'emailLogin'.tr,
                        style: CustomTextStyles.boldStyle,
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return EmailSignInForm();
                    },
                  );
                },
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kYellow),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/go.png",
                        height: 25.h,
                        width: 25.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'googleLogin'.tr,
                        style: CustomTextStyles.boldStyle,
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  await signInWithGoogle();
                },
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kYellow),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/images/fb.png",
                        height: 25.h,
                        width: 25.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'facebookLogin'.tr,
                        style: CustomTextStyles.boldStyle,
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  await signInWithFacebook();
                  // final UserCredential? userCredential = await signInWithFacebook();
                  // if (userCredential != null) {
                  //   Navigator.of(context).pushReplacementNamed('/home');
                  // }
                },
              ),
              // if (Platform.isIOS)
              //   ElevatedButton(
              //       style: ButtonStyle(
              //         backgroundColor: MaterialStateProperty.all(kYellow),
              //       ),
              //       child: Text('appleLogin'.tr),
              //       onPressed: () {
              //         // Navigate to home screen
              //       }),
              // SizedBox(height: 14.h),
              // TextButton(
              //   onPressed: () {
              //     Navigator.of(context).pushReplacement(
              //       MaterialPageRoute(
              //         builder: (context) => const HomeScreen(
              //           userName: 'Unknown',
              //           userEmail: '',
              //           userPhone: '',
              //           photoURL: '',
              //         ),
              //       ),
              //     );
              //   },
              //   child: const Text('Skip'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
