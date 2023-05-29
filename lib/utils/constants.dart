
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

String apiKey = 'AIzaSyAnPZwviAk7_pC3ZTgZHA_QLe8nSsdMlIs';

User? currentFirebaseUser;

DatabaseReference? tripRequestRef;

UserModel? currentUserInfo;

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

const kYellow = Color(0xFFFFCF61);
const kBlack = Color(0xFF2F2F2F);
const kLBlack = Color(0xFF292D30);
const kDBlack = Color(0xFF191919);

class CustomTextStyles {
  static const boldStyle = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.bold,
      fontFamily: 'Rubik',
      fontSize: 14
  );
}

const kDrawerItemStyle = TextStyle(fontSize: 16);


