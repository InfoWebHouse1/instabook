import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';

class LoginController extends GetxController {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>(debugLabel: "LoginScreenState");

  final authController = Get.put(AuthController());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var showProgressIndicator = false.obs;
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

  Future<void> validateLogin() async {
    if (loginFormKey.currentState!.validate()) {
      authController.signInWithEmailAndPassword(emailController.text, passwordController.text);
    } else {
      Get.snackbar(
        "Invalid",
        "Enter valid email and password",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String? validatePass(String? value) {
    if (value!.isEmpty) {
      return "Required *";
    } else if (value.length < 6) {
      return "Should be At least 6 characters.";
    } else if (value.length > 15) {
      return "Should not be more than 15 characters.";
    } else {
      return null;
    }
  }
}
