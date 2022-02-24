import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? imageUrl;
  String? gender;
  String? bio;
  String? phoneNo;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.imageUrl,
    this.gender,
    this.bio,
    this.phoneNo,
  });

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    name = documentSnapshot.get("name");
    email = documentSnapshot.get("email");
    imageUrl = documentSnapshot.get("imageUrl");
    gender = documentSnapshot.get("gender");
    bio = documentSnapshot.get("bio");
    phoneNo = documentSnapshot.get("phoneNo");
  }
}
