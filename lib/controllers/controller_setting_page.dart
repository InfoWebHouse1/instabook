// ignore_for_file: prefer_const_constructors

import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/view/setting_pages/screen_theme_page.dart';
import 'package:lottie/lottie.dart';

class SettingPageController extends GetxController {
  final generalController = Get.put(GeneralController());
  final authController = Get.put(AuthController());


  List<String> menu = [
    "Theme",
    "Logout",
  ];

  List<IconData> icon = [
    Icons.brush_outlined,
    Icons.logout,
  ];

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

  void navigate_next(index, context) {
    if (menu[index] == "Theme") {
      Get.to(() => ThemePage());
    } else if (menu[index] == "Logout") {
      Get.defaultDialog(
        title: "Do you want to logout",
        content: SizedBox(
          width: 100,
          height: 100,
          child: Lottie.network(
            "https://assets6.lottiefiles.com/private_files/lf30_iynlqgqh.json",
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary),
            onPressed: () {
              print("Logout");
              authController.signOut();
            },
            child: Text(
              "Logout",
              style: TextStyle(
                color: generalController.isThemeDark.value
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.secondary),
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: generalController.isThemeDark.value
                    ? Colors.white
                    : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14.5,
              ),
            ),
          )
        ],
      );
    } else {
      //
    }
  }
}
