// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/controllers/controller_main_home.dart';

class MainHomeScreen extends StatelessWidget {
  final homeController = Get.put(MainHomeController());
  final authController = Get.put(AuthController());


  @override
  Widget build(BuildContext context) {
    homeController.update_counter;
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        onTap: homeController.onItemTapped,
        height: 50,
        backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.5),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
        index: homeController.selected_index.value,
        items: [
          Icon(
            Icons.home,
            size: 25,
            color: Theme.of(context).iconTheme.color,
          ),
          Icon(
            Icons.search,
            size: 25,
            color: Theme.of(context).iconTheme.color,
          ),
          Icon(
            Icons.add_a_photo,
            size: 25,
            color: Theme.of(context).iconTheme.color,
          ),
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 25,
            color: Theme.of(context).iconTheme.color,
          ),
          Icon(
            Icons.person,
            size: 25,
            color: Theme.of(context).iconTheme.color,
          ),
        ],
        animationDuration: Duration(milliseconds: 200),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    print("${homeController.update_counter} ${authController.update_counter}");
    return Obx(
      () => SafeArea(
        child: Center(
          child: homeController.body_view.elementAt(homeController.selected_index.value),
        ),
      ),
    );
  }
}
