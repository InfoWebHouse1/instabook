import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? imageUrl;
  String? gender;
  String? bio;
  String? phoneNo;
  //String? timeStamp;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.imageUrl,
    this.gender,
    this.bio,
    this.phoneNo,
    //this.timeStamp,
  });

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.get("id");
    name = documentSnapshot.get("name");
    email = documentSnapshot.get("email");
    imageUrl = documentSnapshot.get("imageUrl");
    gender = documentSnapshot.get("gender");
    bio = documentSnapshot.get("bio");
    phoneNo = documentSnapshot.get("phoneNo");
    //timeStamp = documentSnapshot.get("timeStamp");
  }
  Map toMap(UserModel userModel){
    var data = Map<String, dynamic>();
    data["id"] = userModel.id;
    data["name"] = userModel.name;
    data["email"] = userModel.email;
    data["imageUrl"] = userModel.imageUrl;
    data["gender"] = userModel.gender;
    data["bio"] = userModel.bio;
    data["phoneNo"] = userModel.phoneNo;
    return data;
  }

  UserModel.fromMap(Map<String, dynamic> mapData){
    id = mapData["id"];
    name = mapData["name"];
    email = mapData["email"];
    imageUrl = mapData["imageUrl"];
    gender = mapData["gender"];
    bio = mapData["bio"];
    phoneNo = mapData["phoneNo"];
  }
}
