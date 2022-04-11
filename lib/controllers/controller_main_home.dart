// ignore_for_file: prefer_const_constructors

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/view/navigation_tabs/screen_exlpore.dart';
import 'package:instabook/view/navigation_tabs/screen_home2.dart';
import 'package:instabook/view/navigation_tabs/screen_notification.dart';
import 'package:instabook/view/navigation_tabs/screen_post.dart';
import 'package:instabook/view/navigation_tabs/screen_profile.dart';

class MainHomeController extends GetxController{
  var updaters = Queue();
  var update_counter = "".obs;
  var selected_index = 0.obs;

  @override
  void onInit() {
    super.onInit();
    update1();
  }

  final List<Widget> body_view = [
    HomeScreen(),
    ExploreScreen(),
    PostScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

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


  void onItemTapped(int index){
    selected_index.value = index;
  }
}