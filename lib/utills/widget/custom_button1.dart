// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_login.dart';

class Button1 extends StatelessWidget {
  Button1({Key? key, required this.labelText, this.onPressed}) : super(key: key);
  final String labelText;
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
          primary: Theme.of(context).colorScheme.primary,
        ),
        onPressed: onPressed,
        icon: Icon(
                Icons.vpn_key_rounded,
                color: Colors.black,
              ),
        label: Text(
          labelText,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
