// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key, this.onPressed}) : super(key: key);
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: Get.width * 0.4,
        height: 45,
        child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 2,
          primary: Colors.white,
        ),
        onPressed: onPressed,
        icon: SizedBox(
          width: 30,
          height: 30,
          child: Image.asset("assets/icons/google_icon.png"),
        ),
        label: Text(
                "Google",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
      ),);
  }
}
