// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/view/screen_edit_profile_screen.dart';

class CustomProfileEditButton extends StatelessWidget {
  const CustomProfileEditButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 3,
          color: Colors.white,
          splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          onPressed: () => Get.to(() => EditProfileScreen()),
          child: Center(
              child: Text(
            "Edit Profile",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }
}
