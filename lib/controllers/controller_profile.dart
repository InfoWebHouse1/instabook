// ignore_for_file: prefer_const_constructors

import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/services/services_database.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/view/home.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  final authController = Get.put(AuthController());

  final updateNameController = TextEditingController();
  final updateBioController = TextEditingController();
  final updatePhnController = TextEditingController();
  final updateGenderController = "".obs;

  var isProfileLoading = false.obs;
  var isFollowing = false.obs;
  var showProgressIndicator = false.obs;
  var selectedGenderIndex = 0.obs;
  var followersCount = 0.obs;
  var followingCount = 0.obs;

  List<String> genderVal = ["", "Male", "Female"];

  File? newProfilePic;
  final ImagePicker picker = ImagePicker();
  String? imageUrl;
  final DateTime timeStamp = DateTime.now();

  var updaters = Queue();
  var update_counter = "".obs;

  update1({from: ""}) {
    if (from != "") {
      updaters.add(from);
      // For tracking, who is calling this method
      if (updaters.length > 5) {
        updaters.removeFirst();
      }
    }
    update_counter.value =
        "cont_pr_list-${DateTime.now()} ${DateTime.now().microsecond} $updaters";
  }

  // Future<XFile?> getImage() async {
  //   return await ImagePicker().pickImage(source: ImageSource.gallery);
  // }

  getImage1() async {
    var image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
    newProfilePic = File(image!.path);
    update();
    print("Image Path $newProfilePic");
    // newProfilePic = await getImage();
    // if (newProfilePic != null && newProfilePic!.path.isNotEmpty) {
    //   update();
    // }
    // print("Change Profile Picture");
  }

  Future uploadImage() async {
    String filename = basename(newProfilePic!.path.split("/").last);
    Reference reference =
        FirebaseStorage.instance.ref().child("dp_folder/$filename");
    UploadTask uploadTask = reference.putFile(newProfilePic!);
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => print("Picture Uploaded"));
    imageUrl = await taskSnapshot.ref.getDownloadURL();
    await UserDataBase().updateProfilePic(imageUrl!.trim());
    print("Picture Uploaded $newProfilePic");
  }

  /*String getImageName(File? image) {
    return image!.path.split("/").last;
  }*/

  void editGenderIndex(int index) {
    selectedGenderIndex.value = index;
    updateGenderController.value = genderVal[index];
    update();
    print(updateGenderController.value);
  }

  saveData() async {
    showProgressIndicator.value = false;
    if (newProfilePic != null) {
      uploadImage();
    }
    if (updateNameController.text != "") {
      await UserDataBase().updateProfileName(updateNameController.text);
    }
    if (updateBioController.text != "") {
      await UserDataBase().updateProfileBio(updateBioController.text);
    }
    if (updatePhnController.text != "") {
      await UserDataBase().updateProfilePhn(updatePhnController.text);
    }
    if (updateGenderController.value != "") {
      await UserDataBase().updateProfileGender(updateGenderController.value);
    }
    update();
    Future.delayed(
      Duration(seconds: 3),
      () {
        showProgressIndicator.value = true;
        Get.offAll(
          () => MainHomeScreen(),
        );
      },
    );
  }

  handleUnFollowUser({profileId}) async {
    isFollowing.value = true;
    var user = await UserDataBase().getUser(authController.user!.uid);
    //todo: followers
    followerRef
        .doc(profileId)
        .collection("userFollowers")
        .doc(user!.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //todo: following
    followingRef
        .doc(user.id)
        .collection("userFollowing")
        .doc(profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    //todo: push notification
    notificationRef
        .doc(profileId)
        .collection("feed_items")
        .doc(user.id)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  checkIfFollowing({profileId}) async {
    var user = await UserDataBase().getUser(authController.user!.uid);
    DocumentSnapshot doc = await followerRef
        .doc(profileId)
        .collection("userFollowers")
        .doc(user!.id)
        .get();
    isFollowing.value = doc.exists;
    update();
  }

  getFollower({profileId}) async {
    QuerySnapshot snapshot =
        await followerRef.doc(profileId).collection("userFollowers").get();
    followersCount.value = snapshot.docs.length;
    update();
  }

  getFollowing({profileId}) async {
    QuerySnapshot snapshot =
        await followingRef.doc(profileId).collection("userFollowing").get();
    followingCount.value = snapshot.docs.length;
    update();
  }

  Future handleFollowUser({profileId}) async {
    isFollowing.value = true;
    var user = await UserDataBase().getUser(authController.user!.uid);
    //todo: followers
    followerRef.doc(profileId).collection("userFollowers").doc(user!.id).set({
      'followedBy': user.id,
      'followedTo': profileId,
    });
    //todo: following
    followingRef
        .doc(user.id)
        .collection("userFollowing")
        .doc(profileId)
        .set({});
    //todo: push notification
    notificationRef.doc(profileId).collection("feed_items").doc(user.id).set({
      "type": "follow",
      "ownerId": profileId,
      "userName": user.name,
      "userId": user.id,
      "userProfileImg": user.imageUrl,
      "timeStamp": timeStamp,
    });
  }
}
