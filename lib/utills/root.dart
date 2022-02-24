// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/controllers/controller_root.dart';
import 'package:instabook/controllers/controller_user.dart';
import 'package:instabook/view/home.dart';
import 'package:instabook/view/screen_splash_screen.dart';

class RootScreen extends StatelessWidget {
  final authController = Get.put(AuthController());
  final rootController = Get.put(RootController());

  @override
  Widget build(BuildContext context) {
    print("${rootController.update_counter} ${authController.update_counter} ");
    return Obx((){
      if (authController.user != null) {
        return MainHomeScreen();
      } else {
        return SplashScreen();
      }
    });
  }

  /*buildBody() {
    print("${rootController.update_counter} ${authController.update_counter} ");
    return );
  }*/

}
