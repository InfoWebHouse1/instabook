// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/view/screen_edit_profile_screen.dart';

class CustomButton extends StatelessWidget {
  final String name;
  final Function() onPressed;
  final controller;
  const CustomButton({Key? key, required this.name, required this.onPressed, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.5,
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 3,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.9),
          splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
          onPressed: onPressed,
          child: Center(
              child: Text(
                name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: controller.isThemeDark.value ? Colors.white : Colors.black,
            ),
          )),
        ),
      ),
    );
  }
}
