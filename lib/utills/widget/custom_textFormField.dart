// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextForm extends StatelessWidget {
  CustomTextForm({
    Key? key,
    required this.labelText,
    this.validator,
    this.controller,
    this.icon,
    this.isPassword,
  }) : super(key: key);
  final String labelText;
  final TextEditingController? controller;
  final Icon? icon;
  final String? Function(String? val)? validator;
  final bool? isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword!,
      controller: controller,
      cursorColor: Colors.transparent,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        icon: icon,
        labelText: labelText,
      ),
    );
  }
}
