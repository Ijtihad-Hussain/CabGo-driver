

import 'package:firebase_database/firebase_database.dart';

class UserModel{
  String? fullName;
  String? email;
  String? phone;
  String? id;

  UserModel({
    this.email,
    this.fullName,
    this.id,
    this.phone
});

  UserModel.fromSnapshot(DatabaseEvent event){
    id = event.snapshot.key!;
    Map<String, dynamic> userData = event.snapshot.value as Map<String, dynamic>;
    phone = userData['phone'] as String;
    email = userData['email'] as String;
    fullName = userData['fullname'] as String;
  }

}