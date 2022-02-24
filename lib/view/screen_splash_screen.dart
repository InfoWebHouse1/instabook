// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instabook/controllers/controller_splash_screen.dart';
import 'package:instabook/utills/utilities.dart';

class SplashScreen extends StatelessWidget {
  final splashScreenController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }

  buildBody(BuildContext context) {
    print("${splashScreenController.update_counter}");
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: CustomText(
            "InstaBook",
            Colors.white,
            FontWeight.bold,
            70.0,
          ),
        ),
      ),
    );
  }
}
