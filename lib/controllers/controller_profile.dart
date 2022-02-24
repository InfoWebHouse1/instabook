// ignore_for_file: prefer_const_constructors

import 'dart:collection';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/services/services_database.dart';
import 'package:instabook/view/home.dart';
import 'package:instabook/view/navigation_tabs/screen_profile.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  final updateNameController = TextEditingController();
  final updateBioController = TextEditingController();
  final updatePhnController = TextEditingController();
  final updateGenderController = "".obs;
  var isThemeDark = false.obs;

  final authController = Get.put(AuthController());
  var showProgressIndicator = false.obs;

  var selectedGenderIndex = 0.obs;
  List<String> genderVal = ["", "Male", "Female"];

  File? newProfilePic;
  final ImagePicker picker = ImagePicker();
  String? imageUrl;

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
    update_counter.value = "cont_pr_list-${DateTime.now()} ${DateTime.now().microsecond} $updaters";
  }

  @override
  void onInit() {
    super.onInit();
    showProgressIndicator.value = false;
  }

  // Future<XFile?> getImage() async {
  //   return await ImagePicker().pickImage(source: ImageSource.gallery);
  // }

  getImage1() async {
    var image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
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
    Reference reference = FirebaseStorage.instance.ref().child("dp_folder/$filename");
    UploadTask uploadTask = reference.putFile(newProfilePic!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => print("Picture Uploaded"));
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

  void changeTheme(state){
    if(state == true){
      isThemeDark.value = true;
    }else{
      isThemeDark.value = false;
    }
    update();
  }
}
