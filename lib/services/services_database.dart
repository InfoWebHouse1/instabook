import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instabook/model/model_user.dart';

class UserDataBase {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool?> createNewUser(UserModel user) async {
    try {
      await firestore.collection("Users").doc(user.id).set({
        "name": user.name,
        "email": user.email,
        "imageUrl": user.imageUrl,
        "gender": user.gender,
        "bio": user.bio,
        "phoneNo": user.phoneNo,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel?> getUser(String? uid) async {
    try {
      DocumentSnapshot doc = await firestore.collection("Users").doc(uid!).get();
      return UserModel.fromDocumentSnapshot(documentSnapshot: doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> updateProfilePic(url) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await firestore.collection("Users").doc(user!.uid).update({"imageUrl": url});
      print("Image URl: $url");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateProfileBio(bio) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await firestore.collection("Users").doc(user!.uid).update({"bio": bio});
      print("bio: $bio");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateProfilePhn(phn) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await firestore.collection("Users").doc(user!.uid).update({"phoneNo": phn});
      print("phoneNo: $phn");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateProfileName(name) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await firestore.collection("Users").doc(user!.uid).update({"name": name});
      print("phoneNo: $name");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateProfileGender(gender) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await firestore.collection("Users").doc(user!.uid).update({"gender": gender});
      print("phoneNo: $gender");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


}
