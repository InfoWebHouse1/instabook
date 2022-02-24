// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_auth.dart';
import 'package:instabook/controllers/controller_registration.dart';
import 'package:instabook/utills/utilities.dart';
import 'package:instabook/utills/widget/custom_button1.dart';
import 'package:instabook/utills/widget/custom_gender_button.dart';
import 'package:instabook/utills/widget/custom_horizontal_line.dart';
import 'package:instabook/utills/widget/custom_textFormField.dart';
import 'package:instabook/view/screen_login.dart';

class RegistrationScreen extends StatelessWidget {
  final authController = Get.put(AuthController());
  final registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: buildBody(context),
    );
  }

  buildBody(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: registerController.registerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //todo:  username form
                  CustomTextForm(
                    labelText: "Username",
                    controller: registerController.nameController,
                    icon: Icon(Icons.person),
                    validator: RequiredValidator(errorText: "Required *"),
                    isPassword: false,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //todo:  email form
                  CustomTextForm(
                    labelText: "Email",
                    controller: registerController.emailController,
                    icon: Icon(Icons.mail_rounded),
                    validator: MultiValidator(
                        [
                          RequiredValidator(errorText: "Required *"),
                          EmailValidator(errorText: "Not a Valid Email")
                        ],
                      ),
                    isPassword: false,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //todo: genderform
                  GenderButton(),
                  SizedBox(
                    height: 20.0,
                  ),
                  //todo: password form
                  CustomTextForm(
                    labelText: "Password",
                    controller: registerController.passwordController,
                    icon: Icon(Icons.lock_rounded),
                    validator: registerController.validatePass,
                    isPassword: true,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //todo: login button
                  Button1(
                    labelText: "Sign up",
                    onPressed: () {
                      registerController.validateSignUp();
                      print("Sign up");
                    },
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Text(
                    "Or",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  HorizontalLine(),
                  CustomRichText(
                    "Already have an account?",
                    " Sign in",
                    () => Get.offAll(() => LoginScreen()),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
