// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/view/screen_setting_profile.dart';

class NotificationScreen extends StatelessWidget {
  final generalController = Get.put(GeneralController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
          "Notification",
          generalController.isThemeDark.value ? Colors.white : Colors.black,
          FontWeight.bold,
          30.5,
        ),
        centerTitle: true,
      ),
      body: Center(child: Text("Notification Screen"),),
    );
  }
}
