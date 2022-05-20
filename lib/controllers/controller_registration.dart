import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';

class RegisterController extends GetxController{
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>(debugLabel: "RegisterScreenState");

  final authController = Get.put(AuthController());

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController uidController = TextEditingController();
  TextEditingController imageURLController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();

  /*String? uid;
  String? imageURL;*/

  var showProgressIndicator = false.obs;
  var genderController = "".obs;
  var selectedGenderIndex = 0.obs;
  var updaters = Queue();
  var update_counter = "".obs;

  List<String> genderVal = ["","Male","Female"];



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


  void changeGenderIndex (int index){
    selectedGenderIndex.value = index;
    genderController.value = genderVal[index];
    update();
    print(genderController.value);
  }

  String? validatePass(String? val) {
    if (val!.isEmpty) {
      return "Required *";
    } else if (val.length < 6) {
      return "Should be At least 6 characters.";
    } else if (val.length > 15) {
      return "Should not be more than 15 characters.";
    } else {
      return null;
    }
  }

  Future<void> validateSignUp() async {
    if (registerFormKey.currentState!.validate()) {
      authController.createUser(
        uidController.text,
        nameController.text,
        emailController.text,
        imageURLController.text,
        genderController.value,
        passwordController.text,
        bioController.text,
        phoneNoController.text,
        DateTime.now().toString(),
      );
    } else {
      Get.snackbar(
        "Blank Fields",
        "Enter all required fields",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}